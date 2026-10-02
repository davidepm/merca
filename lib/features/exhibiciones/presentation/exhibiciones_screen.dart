import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/app_states.dart';
import '../../visitas/models/visita.dart';
import '../../visitas/providers/visitas_provider.dart';
import '../providers/exhibiciones_provider.dart';
import 'exhibicion_form_screen.dart';

class ExhibicionesScreen extends StatelessWidget {
  const ExhibicionesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitasProvider>();
    final exhibitions = context.watch<ExhibicionesProvider>();
    if (visits.isLoading || exhibitions.isLoading) return const LoadingState();
    final relevant = visits.visits
        .where(
          (visit) =>
              visit.status == VisitStatus.inProgress ||
              exhibitions.forVisit(visit.id) != null,
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Exhibiciones',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: relevant.isEmpty
              ? const EmptyState(
                  message:
                      'Inicia una visita para registrar su gestión de exhibición.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: relevant.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final visit = relevant[index];
                    final exhibition = exhibitions.forVisit(visit.id);
                    final point = visits.pointOfSaleFor(visit);
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          exhibition == null
                              ? Icons.pending_actions_outlined
                              : Icons.check_circle_outline,
                        ),
                        title: Text(point?.name ?? 'Punto de venta'),
                        subtitle: Text(
                          exhibition == null
                              ? 'Gestión pendiente'
                              : '${exhibition.brand} · ${exhibition.type}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: visit.status == VisitStatus.inProgress
                            ? () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ExhibicionFormScreen(visitId: visit.id),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
