import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../shared/widgets/app_states.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/providers/auth_provider.dart';
import '../../visitas/models/visita.dart';
import '../../visitas/presentation/visita_detail_screen.dart';
import '../../visitas/providers/visitas_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitasProvider>();
    final user = context.watch<AuthProvider>().user;
    if (visits.isLoading) return const LoadingState();
    if (visits.error != null) {
      return ErrorState(message: visits.error!, onRetry: visits.load);
    }
    final next = visits.filter(VisitStatus.pending).firstOrNull;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buenos días, ${user?.name.split(' ').first ?? 'Carlos'}',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(formatDate(DateTime.now())),
            const SizedBox(height: 24),
            Text(
              'Resumen de tu jornada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final metrics = [
                          _Metric(
                            label: 'Asignadas',
                            value: '${visits.visits.length}',
                          ),
                          _Metric(
                            label: 'Completadas',
                            value: '${visits.completedCount}',
                          ),
                          _Metric(
                            label: 'Pendientes',
                            value: '${visits.pendingCount}',
                          ),
                          _Metric(
                            label: 'Novedades',
                            value: '${visits.incidentCount}',
                          ),
                        ];
                        if (constraints.maxWidth < 400) {
                          return Wrap(
                            children: metrics
                                .map(
                                  (metric) => SizedBox(
                                    width: constraints.maxWidth / 2,
                                    child: metric,
                                  ),
                                )
                                .toList(),
                          );
                        }
                        return Row(
                          children: metrics
                              .map((metric) => Expanded(child: metric))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    LinearProgressIndicator(
                      value: visits.progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${visits.completedCount} de ${visits.visits.length} visitas completadas',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Próxima visita',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (next == null)
              const EmptyState(
                message: 'No tienes visitas pendientes para hoy.',
              )
            else
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VisitaDetailScreen(visitId: next.id),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visits.pointOfSaleFor(next)?.name ?? 'Punto de venta',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${next.scheduledTime} · ${next.estimatedDurationMinutes} minutos estimados',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            StatusChip(status: next.status),
                            const Spacer(),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'La ruta es una visualización simulada en esta versión.',
                  ),
                ),
              ),
              icon: const Icon(Icons.route_outlined),
              label: const Text('Ver ruta de hoy'),
            ),
            const SizedBox(height: 24),
            Text(
              'Alertas y pendientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('${visits.pendingCount} visitas pendientes'),
                subtitle: const Text(
                  'Revisa los horarios planificados antes de iniciar tu ruta.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
