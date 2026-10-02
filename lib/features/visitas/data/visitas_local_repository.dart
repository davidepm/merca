import '../models/punto_venta.dart';
import '../models/visita.dart';

class VisitasLocalRepository {
  final List<PuntoVenta> _pointsOfSale = const [
    PuntoVenta(
      id: 'pdv-1',
      name: 'Supermercado La Economia',
      client: 'La Economia',
      address: 'Av. Francisco de Orellana 402',
      city: 'Guayaquil',
      zone: 'Norte',
      latitude: -2.146,
      longitude: -79.908,
    ),
    PuntoVenta(
      id: 'pdv-2',
      name: 'Mi Comisariato Kennedy',
      client: 'El Rosado',
      address: 'Av. San Jorge 112',
      city: 'Guayaquil',
      zone: 'Kennedy',
      latitude: -2.171,
      longitude: -79.899,
    ),
    PuntoVenta(
      id: 'pdv-3',
      name: 'Tia Alborada',
      client: 'Tiendas Industriales Asociadas',
      address: 'Av. Rodolfo Baquerizo',
      city: 'Guayaquil',
      zone: 'Alborada',
      latitude: -2.137,
      longitude: -79.899,
    ),
    PuntoVenta(
      id: 'pdv-4',
      name: 'Megamaxi Norte',
      client: 'Corporacion Favorita',
      address: 'Av. de las Americas 106',
      city: 'Quito',
      zone: 'Norte',
      latitude: -0.165,
      longitude: -78.482,
    ),
    PuntoVenta(
      id: 'pdv-5',
      name: 'Aki Centro',
      client: 'Corporacion Favorita',
      address: 'Av. 9 de Octubre 707',
      city: 'Guayaquil',
      zone: 'Centro',
      latitude: -2.194,
      longitude: -79.886,
    ),
    PuntoVenta(
      id: 'pdv-6',
      name: 'Gran Aki Sur',
      client: 'Corporacion Favorita',
      address: 'Av. Quito y El Oro',
      city: 'Guayaquil',
      zone: 'Sur',
      latitude: -2.211,
      longitude: -79.902,
    ),
    PuntoVenta(
      id: 'pdv-7',
      name: 'Supermaxi Urdesa',
      client: 'Corporacion Favorita',
      address: 'Victor Emilio Estrada 805',
      city: 'Guayaquil',
      zone: 'Urdesa',
      latitude: -2.164,
      longitude: -79.909,
    ),
    PuntoVenta(
      id: 'pdv-8',
      name: 'Tia Garzota',
      client: 'Tiendas Industriales Asociadas',
      address: 'Av. Guillermo Pareja Rolando',
      city: 'Guayaquil',
      zone: 'Garzota',
      latitude: -2.145,
      longitude: -79.894,
    ),
  ];

  Future<List<PuntoVenta>> obtenerPuntosDeVenta() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _pointsOfSale;
  }

  Future<List<Visita>> obtenerVisitasDelDia() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final today = DateTime.now();
    return [
      Visita(
        id: 'v-1',
        pointOfSaleId: 'pdv-1',
        date: today,
        order: 1,
        scheduledTime: '09:30',
        estimatedDurationMinutes: 45,
        distanceKm: 1.2,
        status: VisitStatus.pending,
      ),
      Visita(
        id: 'v-2',
        pointOfSaleId: 'pdv-2',
        date: today,
        order: 2,
        scheduledTime: '10:45',
        estimatedDurationMinutes: 40,
        distanceKm: 2.8,
        status: VisitStatus.pending,
      ),
      Visita(
        id: 'v-3',
        pointOfSaleId: 'pdv-3',
        date: today,
        order: 3,
        scheduledTime: '12:00',
        estimatedDurationMinutes: 35,
        distanceKm: 3.1,
        status: VisitStatus.pending,
      ),
      Visita(
        id: 'v-4',
        pointOfSaleId: 'pdv-4',
        date: today,
        order: 4,
        scheduledTime: '14:30',
        estimatedDurationMinutes: 50,
        distanceKm: 4.6,
        status: VisitStatus.pending,
      ),
      Visita(
        id: 'v-5',
        pointOfSaleId: 'pdv-5',
        date: today,
        order: 5,
        scheduledTime: '08:00',
        estimatedDurationMinutes: 40,
        distanceKm: 1.8,
        status: VisitStatus.completed,
        checkIn: today.copyWith(hour: 8),
        checkOut: today.copyWith(hour: 8, minute: 38),
      ),
      Visita(
        id: 'v-6',
        pointOfSaleId: 'pdv-6',
        date: today,
        order: 6,
        scheduledTime: '08:50',
        estimatedDurationMinutes: 45,
        distanceKm: 2.1,
        status: VisitStatus.completed,
        checkIn: today.copyWith(hour: 8, minute: 50),
        checkOut: today.copyWith(hour: 9, minute: 32),
      ),
      Visita(
        id: 'v-7',
        pointOfSaleId: 'pdv-7',
        date: today,
        order: 7,
        scheduledTime: '07:10',
        estimatedDurationMinutes: 35,
        distanceKm: 2.4,
        status: VisitStatus.completed,
        checkIn: today.copyWith(hour: 7, minute: 10),
        checkOut: today.copyWith(hour: 7, minute: 43),
      ),
      Visita(
        id: 'v-8',
        pointOfSaleId: 'pdv-8',
        date: today,
        order: 8,
        scheduledTime: '13:15',
        estimatedDurationMinutes: 30,
        distanceKm: 2.7,
        status: VisitStatus.incident,
        incidentReason: 'PDV cerrado',
      ),
    ];
  }

  Future<void> guardarVisita(Visita visita) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
