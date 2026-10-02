import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatters.dart';
import '../models/exhibicion.dart';
import '../providers/exhibiciones_provider.dart';

class ExhibicionFormScreen extends StatefulWidget {
  const ExhibicionFormScreen({super.key, required this.visitId});
  final String visitId;
  @override
  State<ExhibicionFormScreen> createState() => _ExhibicionFormScreenState();
}

class _ExhibicionFormScreenState extends State<ExhibicionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brand = TextEditingController();
  final _product = TextEditingController();
  final _fronts = TextEditingController();
  final _spaces = TextEditingController();
  final _quantity = TextEditingController(text: '0');
  final _observations = TextEditingController();
  final _justification = TextEditingController();
  String? _type;
  bool _available = true;
  bool _stockout = false;
  bool _popInstalled = false;
  bool _popMissing = false;
  bool _competitor = false;
  static const _types = [
    'Góndola',
    'Cabecera',
    'Isla',
    'Exhibidor',
    'Caja',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    final item = context.read<ExhibicionesProvider>().forVisit(widget.visitId);
    if (item != null) {
      _brand.text = item.brand;
      _product.text = item.product;
      _fronts.text = '${item.fronts}';
      _spaces.text = '${item.spaces}';
      _quantity.text = '${item.observedQuantity}';
      _observations.text = item.observations;
      _justification.text = item.justification ?? '';
      _type = item.type;
      _available = item.productAvailable;
      _stockout = item.stockout;
      _popInstalled = item.popInstalled;
      _popMissing = item.popMissing;
      _competitor = item.competitorPresent;
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _brand,
      _product,
      _fronts,
      _spaces,
      _quantity,
      _observations,
      _justification,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final provider = context.read<ExhibicionesProvider>();
    final errors = provider.validate(
      brand: _brand.text,
      product: _product.text,
      type: _type ?? '',
      fronts: _fronts.text,
      spaces: _spaces.text,
      observations: _observations.text,
    );
    if (!_formKey.currentState!.validate() || errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los campos obligatorios.')),
      );
      setState(() {});
      return;
    }
    await provider.saveExhibition(
      Exhibition(
        id: 'exhibition-${widget.visitId}',
        visitId: widget.visitId,
        type: _type!,
        brand: _brand.text.trim(),
        product: _product.text.trim(),
        fronts: int.parse(_fronts.text),
        spaces: int.parse(_spaces.text),
        productAvailable: _available,
        stockout: _stockout,
        popInstalled: _popInstalled,
        popMissing: _popMissing,
        observedQuantity: int.tryParse(_quantity.text) ?? 0,
        competitorPresent: _competitor,
        observations: _observations.text.trim(),
        justification: _justification.text.trim().isEmpty
            ? null
            : _justification.text.trim(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exhibición guardada correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final evidence = context.watch<ExhibicionesProvider>().evidenceForVisit(
      widget.visitId,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de exhibición')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Los campos marcados con * son obligatorios.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    _Section(
                      title: 'Información de exhibición',
                      children: [
                        TextFormField(
                          controller: _brand,
                          decoration: const InputDecoration(
                            labelText: 'Marca *',
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _product,
                          decoration: const InputDecoration(
                            labelText: 'Producto o categoría *',
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _type,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de exhibición *',
                          ),
                          items: _types
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _type = value),
                          validator: (value) =>
                              value == null ? 'Selecciona un tipo.' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fronts,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Número de frentes *',
                                ),
                                validator: _number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _spaces,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Número de espacios *',
                                ),
                                validator: _number,
                              ),
                            ),
                          ],
                        ),
                        SwitchListTile(
                          value: _popInstalled,
                          onChanged: (value) =>
                              setState(() => _popInstalled = value),
                          title: const Text('Material POP instalado'),
                        ),
                        SwitchListTile(
                          value: _popMissing,
                          onChanged: (value) =>
                              setState(() => _popMissing = value),
                          title: const Text('Material POP faltante'),
                        ),
                      ],
                    ),
                    _Section(
                      title: 'Disponibilidad',
                      children: [
                        SwitchListTile(
                          value: _available,
                          onChanged: (value) =>
                              setState(() => _available = value),
                          title: const Text('Producto disponible'),
                        ),
                        SwitchListTile(
                          value: _stockout,
                          onChanged: (value) =>
                              setState(() => _stockout = value),
                          title: const Text('Existe quiebre de stock'),
                        ),
                        TextFormField(
                          controller: _quantity,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Cantidad observada',
                          ),
                        ),
                        SwitchListTile(
                          value: _competitor,
                          onChanged: (value) =>
                              setState(() => _competitor = value),
                          title: const Text('Presencia de competencia'),
                        ),
                      ],
                    ),
                    _Section(
                      title: 'Observaciones',
                      children: [
                        TextFormField(
                          controller: _observations,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Observaciones *',
                            alignLabelWithHint: true,
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _justification,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Justificación opcional',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                    _Section(
                      title: 'Evidencias',
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context
                              .read<ExhibicionesProvider>()
                              .addSimulatedEvidence(widget.visitId),
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: const Text('Agregar evidencia'),
                        ),
                        if (evidence.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Aún no hay evidencias. Puedes agregarlas de forma simulada.',
                            ),
                          )
                        else
                          ...evidence.map(
                            (item) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.image_outlined),
                                title: Text(item.type),
                                subtitle: Text(formatDate(item.createdAt)),
                                trailing: IconButton(
                                  tooltip: 'Eliminar evidencia',
                                  onPressed: () => context
                                      .read<ExhibicionesProvider>()
                                      .removeEvidence(item.id),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _save,
                      child: const Text('Guardar exhibición'),
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

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? 'Este campo es obligatorio.'
      : null;
  String? _number(String? value) =>
      int.tryParse(value ?? '') == null ? 'Ingresa un número válido.' : null;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    ),
  );
}
