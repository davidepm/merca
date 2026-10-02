import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../exhibiciones/providers/exhibiciones_provider.dart';
import '../providers/visitas_provider.dart';

class NovedadFormScreen extends StatefulWidget {
  const NovedadFormScreen({super.key, required this.visitId});
  final String visitId;
  @override
  State<NovedadFormScreen> createState() => _NovedadFormScreenState();
}

class _NovedadFormScreenState extends State<NovedadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _justification = TextEditingController();
  String? _reason;
  bool _hasEvidence = false;
  final _reasons = const [
    'PDV cerrado',
    'No se permitió el ingreso',
    'Dirección incorrecta',
    'Sin responsable disponible',
    'Problemas de transporte',
    'Otro',
  ];

  @override
  void dispose() {
    _justification.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _reason == null) {
      setState(() {});
      return;
    }
    final saved = await context.read<VisitasProvider>().registerIncident(
      widget.visitId,
      reason: _reason!,
      justification: _justification.text.trim(),
    );
    if (!mounted) return;
    if (saved) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'Novedad guardada correctamente.'
              : context.read<VisitasProvider>().error!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Registrar novedad')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Indica por qué no fue posible realizar la visita.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: _reason,
                    decoration: const InputDecoration(labelText: 'Motivo *'),
                    items: _reasons
                        .map(
                          (reason) => DropdownMenuItem(
                            value: reason,
                            child: Text(reason),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _reason = value),
                    validator: (value) =>
                        value == null ? 'Selecciona un motivo.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _justification,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Justificación *',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Describe la novedad.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await context
                          .read<ExhibicionesProvider>()
                          .addSimulatedEvidence(widget.visitId);
                      if (mounted) setState(() => _hasEvidence = true);
                    },
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(
                      _hasEvidence
                          ? 'Evidencia simulada agregada'
                          : 'Agregar evidencia opcional',
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Guardar novedad'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
