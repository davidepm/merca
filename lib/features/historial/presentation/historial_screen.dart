import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../shared/widgets/app_states.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../exhibiciones/providers/exhibiciones_provider.dart';
import '../../visitas/models/visita.dart';
import '../../visitas/providers/visitas_provider.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});
  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  VisitStatus? _status;
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitasProvider>();
    final exhibitions = context.watch<ExhibicionesProvider>();
    if (visits.isLoading) return const LoadingState();
    final results = visits
        .filter(_status, query: _query)
        .where(
          (item) =>
              item.status == VisitStatus.completed ||
              item.status == VisitStatus.incident,
        )
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historial',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Filtrar por PDV',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<VisitStatus?>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        DropdownMenuItem(
                          value: VisitStatus.completed,
                          child: Text('Completadas'),
                        ),
                        DropdownMenuItem(
                          value: VisitStatus.incident,
                          child: Text('Novedades'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _status = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Todas las visitas corresponden a la jornada simulada actual.',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('Fecha'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const EmptyState(
                  message: 'No hay visitas en el historial para este filtro.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final visit = results[index];
                    final point = visits.pointOfSaleFor(visit);
                    final duration =
                        visit.checkIn != null && visit.checkOut != null
                        ? visit.checkOut!.difference(visit.checkIn!)
                        : null;
                    return Card(
                      child: ListTile(
                        title: Text(point?.name ?? ''),
                        subtitle: Text(
                          '${formatDate(visit.date)} · ${duration == null ? 'Sin duración' : formatDuration(duration)}\n${visit.status == VisitStatus.incident ? visit.incidentReason ?? 'Novedad' : 'Exhibición registrada'} · ${exhibitions.evidenceForVisit(visit.id).length} evidencias',
                        ),
                        isThreeLine: true,
                        trailing: StatusChip(status: visit.status),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
