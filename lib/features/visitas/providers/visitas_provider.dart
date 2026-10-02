import 'package:flutter/foundation.dart';

import '../data/visitas_local_repository.dart';
import '../models/punto_venta.dart';
import '../models/visita.dart';

class VisitasProvider extends ChangeNotifier {
  VisitasProvider(this._repository);

  final VisitasLocalRepository _repository;
  List<Visita> _visits = [];
  List<PuntoVenta> _pointsOfSale = [];
  bool _isLoading = false;
  String? _error;

  List<Visita> get visits => List.unmodifiable(_visits);
  bool get isLoading => _isLoading;
  String? get error => _error;
  Visita? get activeVisit => _visits.cast<Visita?>().firstWhere(
    (visit) => visit?.status == VisitStatus.inProgress,
    orElse: () => null,
  );
  int get completedCount =>
      _visits.where((visit) => visit.status == VisitStatus.completed).length;
  int get pendingCount =>
      _visits.where((visit) => visit.status == VisitStatus.pending).length;
  int get incidentCount =>
      _visits.where((visit) => visit.status == VisitStatus.incident).length;
  double get progress => _visits.isEmpty ? 0 : completedCount / _visits.length;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _pointsOfSale = await _repository.obtenerPuntosDeVenta();
      _visits = await _repository.obtenerVisitasDelDia();
    } catch (_) {
      _error = 'No fue posible cargar las visitas. Intenta nuevamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PuntoVenta? pointOfSaleFor(Visita visit) {
    for (final point in _pointsOfSale) {
      if (point.id == visit.pointOfSaleId) return point;
    }
    return null;
  }

  List<Visita> filter(VisitStatus? status, {String query = ''}) {
    final normalized = query.trim().toLowerCase();
    return _visits.where((visit) {
      final point = pointOfSaleFor(visit);
      final matchesStatus = status == null || visit.status == status;
      final matchesQuery =
          normalized.isEmpty ||
          (point?.name.toLowerCase().contains(normalized) ?? false);
      return matchesStatus && matchesQuery;
    }).toList()..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<bool> startVisit(String visitId) async {
    if (activeVisit != null) {
      _error =
          'Ya existe una visita en curso. Finalizala antes de iniciar otra.';
      notifyListeners();
      return false;
    }
    final visit = _byId(visitId);
    if (visit == null || visit.status != VisitStatus.pending) return false;
    visit.status = VisitStatus.inProgress;
    visit.checkIn = DateTime.now();
    await _repository.guardarVisita(visit);
    notifyListeners();
    return true;
  }

  Future<bool> finishVisit(
    String visitId, {
    required bool hasExhibition,
  }) async {
    final visit = _byId(visitId);
    if (visit == null ||
        visit.status != VisitStatus.inProgress ||
        !hasExhibition) {
      _error = hasExhibition
          ? 'La visita no esta en curso.'
          : 'Registra la exhibicion antes de finalizar la visita.';
      notifyListeners();
      return false;
    }
    visit.status = VisitStatus.completed;
    visit.checkOut = DateTime.now();
    await _repository.guardarVisita(visit);
    notifyListeners();
    return true;
  }

  Future<bool> registerIncident(
    String visitId, {
    required String reason,
    required String justification,
  }) async {
    final visit = _byId(visitId);
    if (visit == null || (activeVisit != null && activeVisit!.id != visitId)) {
      _error =
          'No puedes registrar una novedad mientras otra visita esta en curso.';
      notifyListeners();
      return false;
    }
    visit.status = VisitStatus.incident;
    visit.incidentReason = reason;
    visit.incidentJustification = justification;
    await _repository.guardarVisita(visit);
    notifyListeners();
    return true;
  }

  Visita? _byId(String id) {
    for (final visit in _visits) {
      if (visit.id == id) return visit;
    }
    return null;
  }
}
