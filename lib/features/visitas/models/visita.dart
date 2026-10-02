enum VisitStatus { pending, inProgress, completed, incident }

extension VisitStatusLabel on VisitStatus {
  String get label => switch (this) {
    VisitStatus.pending => 'Pendiente',
    VisitStatus.inProgress => 'En curso',
    VisitStatus.completed => 'Completada',
    VisitStatus.incident => 'Novedad',
  };
}

class Visita {
  Visita({
    required this.id,
    required this.pointOfSaleId,
    required this.date,
    required this.order,
    required this.scheduledTime,
    required this.estimatedDurationMinutes,
    required this.distanceKm,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.incidentReason,
    this.incidentJustification,
  });

  final String id;
  final String pointOfSaleId;
  final DateTime date;
  final int order;
  final String scheduledTime;
  final int estimatedDurationMinutes;
  final double distanceKm;
  VisitStatus status;
  DateTime? checkIn;
  DateTime? checkOut;
  String? incidentReason;
  String? incidentJustification;
}
