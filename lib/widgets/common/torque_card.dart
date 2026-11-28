import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

/// Tarjeta contenedora reutilizable con estilo Rodando Ando.
///
/// Se adapta automáticamente al tema claro u oscuro respetando
/// el radio de 12px del diseño Figma.
class TorqueCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const TorqueCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: cs.outline, width: 0.7),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
