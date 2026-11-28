import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/models/servicio.dart';
import 'estado_badge.dart';
import 'torque_card.dart';

/// Tarjeta de servicio reutilizable, como en la lista de mantenimientos.
class ServicioCard extends StatelessWidget {
  final Servicio servicio;
  final VoidCallback? onTap;

  const ServicioCard({super.key, required this.servicio, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return TorqueCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  servicio.titulo,
                  style: tt.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              EstadoBadge(estado: servicio.estado),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${servicio.fecha}  /  ${_formatKm(servicio.kilometraje)} km',
            style: tt.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                '\$${servicio.costoEstimado.toStringAsFixed(2)} MXN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              const Text(
                'Ver detalle →',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.rojoMazda,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatKm(int km) {
    final str = km.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
