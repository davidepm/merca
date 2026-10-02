import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../features/visitas/models/visita.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final VisitStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      VisitStatus.pending => AppTheme.warning,
      VisitStatus.inProgress => AppTheme.primary,
      VisitStatus.completed => AppTheme.success,
      VisitStatus.incident => AppTheme.danger,
    };
    return Chip(
      avatar: Icon(Icons.circle, size: 10, color: color),
      label: Text(status.label),
      side: BorderSide(color: color.withValues(alpha: .35)),
      backgroundColor: color.withValues(alpha: .1),
      visualDensity: VisualDensity.compact,
    );
  }
}
