import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Barra de progreso horizontal con porcentaje — replica los indicadores de
/// salud del vehículo (Motor 94%, Frenos 92%, etc.) del diseño Figma.
class HealthBar extends StatelessWidget {
  final String label;
  final int porcentaje;

  const HealthBar({super.key, required this.label, required this.porcentaje});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: tt.bodyMedium),
              Text('$porcentaje %', style: tt.bodyMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: porcentaje / 100,
              minHeight: 3,
              backgroundColor: cs.outline,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.rojoMazda),
            ),
          ),
        ],
      ),
    );
  }
}
