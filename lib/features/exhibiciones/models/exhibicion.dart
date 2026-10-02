class Exhibition {
  const Exhibition({
    required this.id,
    required this.visitId,
    required this.type,
    required this.brand,
    required this.product,
    required this.fronts,
    required this.spaces,
    required this.productAvailable,
    required this.stockout,
    required this.popInstalled,
    required this.popMissing,
    required this.observedQuantity,
    required this.competitorPresent,
    required this.observations,
    this.justification,
  });

  final String id;
  final String visitId;
  final String type;
  final String brand;
  final String product;
  final int fronts;
  final int spaces;
  final bool productAvailable;
  final bool stockout;
  final bool popInstalled;
  final bool popMissing;
  final int observedQuantity;
  final bool competitorPresent;
  final String observations;
  final String? justification;
}
