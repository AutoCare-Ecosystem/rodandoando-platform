import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/models/servicio.dart';

/// Badge de estado del servicio (Pendiente / En progreso / Completado).
class EstadoBadge extends StatelessWidget {
  final EstadoServicio estado;
  final bool highlighted;

  const EstadoBadge({
    super.key,
    required this.estado,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = switch (estado) {
      EstadoServicio.pendiente => 'Pendiente',
      EstadoServicio.enProgreso => 'En progreso',
      EstadoServicio.completado => 'Completado',
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.rojoMazda : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        border: highlighted ? null : Border.all(color: cs.outline, width: 0.6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: highlighted ? AppColors.niebla : cs.onSurface,
        ),
      ),
    );
  }
}
