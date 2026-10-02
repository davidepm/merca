String formatDate(DateTime date) {
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  return '${date.day} de ${months[date.month - 1]} de ${date.year}';
}

String formatTime(DateTime? date) {
  if (date == null) return 'Sin registrar';
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  return '${minutes ~/ 60} h ${minutes % 60} min';
}
