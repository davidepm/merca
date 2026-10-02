class Evidence {
  const Evidence({
    required this.id,
    required this.visitId,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String visitId;
  final String type;
  final DateTime createdAt;
}
