import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

/// Indicador numérico reutilizable (54,320 km | En 38 días | \$4,200 MXN).
///
/// Replica los "Indicador" del diseño Figma: valor grande + etiqueta + subtítulo.
class IndicadorCard extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final String? subtitulo;
  final IconData? icono;
  final Color? colorValor;
  final bool compact;

  const IndicadorCard({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.subtitulo,
    this.icono,
    this.colorValor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: cs.outline, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            etiqueta.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.labelSmall?.copyWith(
              fontSize: compact ? 10 : 11,
              color: tt.bodySmall?.color,
            ),
          ),
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
          Row(
            children: [
              if (icono != null) ...[
                Icon(icono, color: colorValor ?? cs.onSurface, size: compact ? 16 : 20),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 16 : 28,
                    fontWeight: FontWeight.w700,
                    color: colorValor ?? cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitulo!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodySmall?.copyWith(fontSize: compact ? 11 : 12),
            ),
          ],
        ],
      ),
    );
  }
}
