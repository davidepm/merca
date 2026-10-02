import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_pdv/features/auth/data/auth_local_repository.dart';
import 'package:gestion_pdv/features/auth/providers/auth_provider.dart';
import 'package:gestion_pdv/features/exhibiciones/data/exhibiciones_local_repository.dart';
import 'package:gestion_pdv/features/exhibiciones/providers/exhibiciones_provider.dart';
import 'package:gestion_pdv/features/visitas/data/visitas_local_repository.dart';
import 'package:gestion_pdv/features/visitas/models/visita.dart';
import 'package:gestion_pdv/features/visitas/providers/visitas_provider.dart';

void main() {
  group('AuthProvider', () {
    test('permite login con credenciales demo', () async {
      final provider = AuthProvider(AuthLocalRepository());
      expect(await provider.login('mercaderista@demo.com', '123456'), isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.user!.name, 'Carlos Mendoza');
    });

    test('rechaza credenciales incorrectas', () async {
      final provider = AuthProvider(AuthLocalRepository());
      expect(await provider.login('incorrecto@demo.com', '123456'), isFalse);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.error, isNotNull);
    });
  });

  group('VisitasProvider', () {
    late VisitasProvider provider;
    setUp(() async {
      provider = VisitasProvider(VisitasLocalRepository());
      await provider.load();
    });

    test('inicia una visita y cambia su estado', () async {
      expect(await provider.startVisit('v-1'), isTrue);
      expect(provider.activeVisit!.id, 'v-1');
      expect(provider.visits.first.status, VisitStatus.inProgress);
    });

    test('no permite dos visitas activas', () async {
      await provider.startVisit('v-1');
      expect(await provider.startVisit('v-2'), isFalse);
      expect(
        provider.visits.where(
          (visit) => visit.status == VisitStatus.inProgress,
        ),
        hasLength(1),
      );
    });

    test('registra una novedad', () async {
      expect(
        await provider.registerIncident(
          'v-2',
          reason: 'PDV cerrado',
          justification: 'Puertas cerradas.',
        ),
        isTrue,
      );
      final visit = provider.visits.firstWhere((item) => item.id == 'v-2');
      expect(visit.status, VisitStatus.incident);
      expect(visit.incidentReason, 'PDV cerrado');
    });

    test('finaliza una visita que tiene exhibición', () async {
      await provider.startVisit('v-1');
      expect(await provider.finishVisit('v-1', hasExhibition: true), isTrue);
      final visit = provider.visits.first;
      expect(visit.status, VisitStatus.completed);
      expect(visit.checkOut, isNotNull);
      expect(provider.activeVisit, isNull);
    });

    test('calcula visitas completadas y pendientes', () {
      expect(provider.completedCount, 3);
      expect(provider.pendingCount, 4);
    });
  });

  test('valida los campos obligatorios de exhibición', () {
    final provider = ExhibicionesProvider(ExhibicionesLocalRepository());
    final errors = provider.validate(
      brand: '',
      product: '',
      type: '',
      fronts: 'x',
      spaces: '',
      observations: '',
    );
    expect(
      errors.keys,
      containsAll([
        'brand',
        'product',
        'type',
        'fronts',
        'spaces',
        'observations',
      ]),
    );
  });
}
