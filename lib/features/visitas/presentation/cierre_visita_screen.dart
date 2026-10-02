import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatters.dart';
import '../../exhibiciones/providers/exhibiciones_provider.dart';
import '../providers/visitas_provider.dart';

class CierreVisitaScreen extends StatelessWidget {
  const CierreVisitaScreen({super.key, required this.visitId});
  final String visitId;

  Future<void> _finish(BuildContext context) async {
    final visits = context.read<VisitasProvider>();
    final exhibitions = context.read<ExhibicionesProvider>();
    final exhibition = exhibitions.forVisit(visitId);
    if (exhibition == null) return;
    final evidence = exhibitions.evidenceForVisit(visitId);
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Finalizar visita?'),
        content: Text(
          evidence.isEmpty
              ? 'No hay evidencias registradas. Puedes finalizar, pero se recomienda agregar al menos una.'
              : 'La visita se marcará como completada y podrás iniciar otra.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Volver a editar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmation != true) return;
    final success = await visits.finishVisit(visitId, hasExhibition: true);
    if (!context.mounted) return;
    if (success) Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Visita finalizada correctamente.' : visits.error!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitasProvider>();
    final exhibition = context.watch<ExhibicionesProvider>().forVisit(visitId);
    final evidence = context.watch<ExhibicionesProvider>().evidenceForVisit(
      visitId,
    );
    final visit = visits.visits.where((item) => item.id == visitId).firstOrNull;
    if (visit == null) {
      return const Scaffold(body: Center(child: Text('Visita no encontrada.')));
    }
    final point = visits.pointOfSaleFor(visit);
    final duration = visit.checkIn == null
        ? Duration.zero
        : DateTime.now().difference(visit.checkIn!);
    return Scaffold(
      appBar: AppBar(title: const Text('Cierre de visita')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Revisa el resumen antes de finalizar.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point?.name ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text('Entrada: ${formatTime(visit.checkIn)}'),
                          Text(
                            'Salida simulada: ${formatTime(DateTime.now())}',
                          ),
                          Text('Duración: ${formatDuration(duration)}'),
                          const Divider(),
                          Text(
                            exhibition == null
                                ? 'Exhibición: pendiente'
                                : 'Exhibición: ${exhibition.brand} · ${exhibition.type}',
                          ),
                          Text('Evidencias: ${evidence.length}'),
                          if (exhibition != null)
                            Text('Observaciones: ${exhibition.observations}'),
                        ],
                      ),
                    ),
                  ),
                  if (evidence.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Advertencia: no existe evidencia registrada.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: exhibition == null
                        ? null
                        : () => _finish(context),
                    child: const Text('Finalizar visita'),
                  ),
                  if (exhibition == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Debes registrar los campos obligatorios de exhibición para finalizar.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
