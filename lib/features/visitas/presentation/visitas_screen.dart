import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/app_states.dart';
import '../../../shared/widgets/status_chip.dart';
import '../models/visita.dart';
import '../providers/visitas_provider.dart';
import 'visita_detail_screen.dart';

class VisitasScreen extends StatefulWidget {
  const VisitasScreen({super.key});
  @override
  State<VisitasScreen> createState() => _VisitasScreenState();
}

class _VisitasScreenState extends State<VisitasScreen> {
  VisitStatus? _filter;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VisitasProvider>();
    if (provider.isLoading) {
      return const LoadingState(label: 'Cargando puntos de venta...');
    }
    if (provider.error != null) {
      return ErrorState(message: provider.error!, onRetry: provider.load);
    }
    final visits = provider.filter(_filter);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Visitas de hoy',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _FilterChip(
                label: 'Todas',
                selected: _filter == null,
                onSelected: () => setState(() => _filter = null),
              ),
              ...VisitStatus.values.map(
                (status) => _FilterChip(
                  label: status.label,
                  selected: _filter == status,
                  onSelected: () => setState(() => _filter = status),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: visits.isEmpty
              ? const EmptyState(message: 'No hay visitas para este filtro.')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: visits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    final point = provider.pointOfSaleFor(visit);
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VisitaDetailScreen(visitId: visit.id),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(child: Text('${visit.order}')),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      point?.name ?? 'Punto de venta',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(point?.client ?? ''),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${point?.address ?? ''} · ${point?.zone ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${visit.scheduledTime} · ${visit.estimatedDurationMinutes} min · ${visit.distanceKm.toStringAsFixed(1)} km',
                                    ),
                                    const SizedBox(height: 8),
                                    StatusChip(status: visit.status),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    ),
  );
}
