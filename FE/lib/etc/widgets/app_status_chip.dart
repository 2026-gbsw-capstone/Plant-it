import 'package:flutter/material.dart';

import '../../data/model/plant_model.dart';
import '../constants/app_colors.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  factory AppStatusChip.health(HealthStatus status) {
    switch (status) {
      case HealthStatus.good:
        return const AppStatusChip(label: 'Good', color: AppColors.success);
      case HealthStatus.warning:
        return const AppStatusChip(label: 'Warning', color: AppColors.warning);
      case HealthStatus.danger:
        return const AppStatusChip(label: 'Danger', color: AppColors.danger);
    }
  }

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
