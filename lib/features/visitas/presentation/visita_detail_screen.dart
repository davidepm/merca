import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../exhibiciones/presentation/exhibicion_form_screen.dart';
import '../../exhibiciones/providers/exhibiciones_provider.dart';
import '../models/visita.dart';
import '../providers/visitas_provider.dart';
import 'cierre_visita_screen.dart';
import 'novedad_form_screen.dart';

class VisitaDetailScreen extends StatefulWidget {
  const VisitaDetailScreen({super.key, required this.visitId});
  final String visitId;

  @override
  State<VisitaDetailScreen> createState() => _VisitaDetailScreenState();
}

class _VisitaDetailScreenState extends State<VisitaDetailScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startVisit() async {
    final success = await context.read<VisitasProvider>().startVisit(
      widget.visitId,
    );
    if (!mounted) return;
    final message = success
        ? 'Entrada registrada con GPS simulado.'
        : context.read<VisitasProvider>().error!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitasProvider>();
    final visit = visits.visits
        .where((item) => item.id == widget.visitId)
        .firstOrNull;
    if (visit == null) {
      return const Scaffold(body: Center(child: Text('Visita no encontrada.')));
    }
    final point = visits.pointOfSaleFor(visit);
    final exhibition = context.watch<ExhibicionesProvider>().forVisit(visit.id);
    final elapsed = visit.checkIn == null
        ? null
        : DateTime.now().difference(visit.checkIn!);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del PDV')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point?.name ?? 'Punto de venta',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(point?.client ?? ''),
                  const SizedBox(height: 12),
                  StatusChip(status: visit.status),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            label:
                                '${point?.address ?? ''}, ${point?.city ?? ''}',
                          ),
                          _InfoRow(
                            icon: Icons.map_outlined,
                            label: 'Zona ${point?.zone ?? ''} · GPS simulado',
                          ),
                          _InfoRow(
                            icon: Icons.schedule_outlined,
                            label:
                                '${visit.scheduledTime} · ${visit.estimatedDurationMinutes} minutos estimados',
                          ),
                          _InfoRow(
                            icon: Icons.directions_walk_outlined,
                            label:
                                '${visit.distanceKm.toStringAsFixed(1)} km de distancia simulada',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (visit.status == VisitStatus.inProgress) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Visita en curso\nEntrada: ${formatTime(visit.checkIn)} · ${formatDuration(elapsed!)}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (visit.status == VisitStatus.pending) ...[
                    FilledButton.icon(
                      onPressed: _startVisit,
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar visita'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NovedadFormScreen(visitId: visit.id),
                        ),
                      ),
                      icon: const Icon(Icons.report_outlined),
                      label: const Text('Registrar novedad'),
                    ),
                  ],
                  if (visit.status == VisitStatus.inProgress) ...[
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ExhibicionFormScreen(visitId: visit.id),
                        ),
                      ),
                      icon: const Icon(Icons.view_quilt_outlined),
                      label: Text(
                        exhibition == null
                            ? 'Registrar exhibición'
                            : 'Editar exhibición',
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CierreVisitaScreen(visitId: visit.id),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Finalizar visita'),
                    ),
                  ],
                  if (visit.status == VisitStatus.completed) ...[
                    const Divider(height: 32),
                    Text(
                      'Visita completada',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('Salida: ${formatTime(visit.checkOut)}'),
                  ],
                  if (visit.status == VisitStatus.incident) ...[
                    const Divider(height: 32),
                    Text(
                      'Novedad registrada',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(visit.incidentReason ?? ''),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    ),
  );
}
