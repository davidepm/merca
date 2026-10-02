class PuntoVenta {
  const PuntoVenta({
    required this.id,
    required this.name,
    required this.client,
    required this.address,
    required this.city,
    required this.zone,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String client;
  final String address;
  final String city;
  final String zone;
  final double latitude;
  final double longitude;
}
