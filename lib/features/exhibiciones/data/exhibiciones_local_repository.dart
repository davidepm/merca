import '../models/evidencia.dart';
import '../models/exhibicion.dart';

class ExhibicionesLocalRepository {
  final List<Exhibition> _exhibitions = [];
  final List<Evidence> _evidence = [];

  Future<List<Exhibition>> obtenerExhibiciones() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List.of(_exhibitions);
  }

  Future<List<Evidence>> obtenerEvidencias() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List.of(_evidence);
  }

  Future<void> guardarExhibicion(Exhibition exhibition) async {
    _exhibitions.removeWhere((item) => item.visitId == exhibition.visitId);
    _exhibitions.add(exhibition);
  }

  Future<void> guardarEvidencia(Evidence evidence) async =>
      _evidence.add(evidence);

  Future<void> eliminarEvidencia(String evidenceId) async {
    _evidence.removeWhere((item) => item.id == evidenceId);
  }
}
