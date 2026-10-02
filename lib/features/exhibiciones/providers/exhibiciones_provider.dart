import 'package:flutter/foundation.dart';

import '../data/exhibiciones_local_repository.dart';
import '../models/evidencia.dart';
import '../models/exhibicion.dart';

class ExhibicionesProvider extends ChangeNotifier {
  ExhibicionesProvider(this._repository);

  final ExhibicionesLocalRepository _repository;
  List<Exhibition> _exhibitions = [];
  List<Evidence> _evidence = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Exhibition> get exhibitions => List.unmodifiable(_exhibitions);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _exhibitions = await _repository.obtenerExhibiciones();
      _evidence = await _repository.obtenerEvidencias();
    } catch (_) {
      _error = 'No fue posible cargar las exhibiciones.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Exhibition? forVisit(String visitId) {
    for (final exhibition in _exhibitions) {
      if (exhibition.visitId == visitId) return exhibition;
    }
    return null;
  }

  List<Evidence> evidenceForVisit(String visitId) =>
      _evidence.where((item) => item.visitId == visitId).toList();

  Map<String, String> validate({
    required String brand,
    required String product,
    required String type,
    required String fronts,
    required String spaces,
    required String observations,
  }) {
    final errors = <String, String>{};
    if (brand.trim().isEmpty) errors['brand'] = 'La marca es obligatoria.';
    if (product.trim().isEmpty) {
      errors['product'] = 'El producto o categoria es obligatorio.';
    }
    if (type.isEmpty) errors['type'] = 'Selecciona el tipo de exhibicion.';
    if (int.tryParse(fronts) == null || int.parse(fronts) < 0) {
      errors['fronts'] = 'Ingresa un numero valido de frentes.';
    }
    if (int.tryParse(spaces) == null || int.parse(spaces) < 0) {
      errors['spaces'] = 'Ingresa un numero valido de espacios.';
    }
    if (observations.trim().isEmpty) {
      errors['observations'] = 'Las observaciones son obligatorias.';
    }
    return errors;
  }

  Future<void> saveExhibition(Exhibition exhibition) async {
    await _repository.guardarExhibicion(exhibition);
    _exhibitions.removeWhere((item) => item.visitId == exhibition.visitId);
    _exhibitions.add(exhibition);
    notifyListeners();
  }

  Future<void> addSimulatedEvidence(String visitId) async {
    final evidence = Evidence(
      id: 'evidence-${DateTime.now().microsecondsSinceEpoch}',
      visitId: visitId,
      type: 'Fotografia de exhibicion',
      createdAt: DateTime.now(),
    );
    await _repository.guardarEvidencia(evidence);
    _evidence.add(evidence);
    notifyListeners();
  }

  Future<void> removeEvidence(String evidenceId) async {
    await _repository.eliminarEvidencia(evidenceId);
    _evidence.removeWhere((item) => item.id == evidenceId);
    notifyListeners();
  }
}
