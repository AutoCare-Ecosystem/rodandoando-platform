import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/servicio.dart';
import '../../widgets/common/torque_card.dart';
import '../../widgets/common/estado_badge.dart';

/// Pantalla 5 — Detalle de Servicio Certificado.
///
/// Desglose completo: estado, costo, piezas y mano de obra, adjuntos,
/// taller de confianza y próximo servicio.
class DetalleServicioScreen extends StatelessWidget {
  final Servicio servicio;

  const DetalleServicioScreen({super.key, required this.servicio});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Detalle de servicio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= AppTheme.desktopBreakpoint;
          final isMobile = constraints.maxWidth < AppTheme.mobileBreakpoint;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, !isMobile),
                const SizedBox(height: AppSpacing.xl),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildContenidoPrincipal(context)),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(child: _buildPanelLateral(context)),
                    ],
                  )
                else ...[
                  _buildContenidoPrincipal(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPanelLateral(context),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool showButton) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVICIOS / HISTORIAL',
          style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text('Detalle de servicio.', style: tt.displayLarge?.copyWith(fontSize: showButton ? 40 : 32)),
            ),
            if (showButton)
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: cs.surface,
                  side: BorderSide(color: cs.outline),
                ),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Editar mantenimiento'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('La tranquilidad también está en los detalles.', style: tt.bodyMedium),
      ],
    );
  }

  Widget _buildContenidoPrincipal(BuildContext context) {
    return Column(
      children: [
        _buildResumen(context),
        const SizedBox(height: AppSpacing.xl),
        _buildTablaPiezas(context),
        const SizedBox(height: AppSpacing.xl),
        _buildNotas(context),
      ],
    );
  }

  Widget _buildResumen(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EstadoBadge(estado: servicio.estado, highlighted: true),
          const SizedBox(height: AppSpacing.lg),
          Text(servicio.titulo, style: tt.displayMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${servicio.fecha}   /   ${_formatKm(servicio.kilometraje)} km   /   Mercedes-Benz',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${servicio.costoEstimado.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: cs.onSurface),
              ),
              const SizedBox(width: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('MXN · pagado', style: tt.bodyMedium),
              ),
              const Spacer(),
              Text('Pago registrado  ✓', style: tt.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTablaPiezas(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final piezas = [
      ('Aceite sintético 5W-40 · 5 L', 650.00),
      ('Filtro de aceite', 350.00),
      ('Mano de obra', 250.00),
    ];
    final total = piezas.fold<double>(0, (sum, p) => sum + p.$2);

    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Piezas y mano de obra', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: Text('CONCEPTO', style: tt.labelSmall)),
              Text('IMPORTE', style: tt.labelSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...piezas.map((p) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(child: Text(p.$1, style: tt.bodyLarge?.copyWith(fontSize: 14))),
                        Text('\$${p.$2.toStringAsFixed(2)}', style: tt.bodyLarge?.copyWith(fontSize: 14)),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              )),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: Text('Total (IVA incluido)', style: tt.titleSmall)),
              Text('\$${total.toStringAsFixed(2)}', style: tt.headlineMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotas(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Un detalle más.', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Se revisaron niveles, mangueras y juntas del motor. Todo en orden.',
            style: tt.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildPanelLateral(BuildContext context) {
    return Column(
      children: [
        _buildTaller(context),
        const SizedBox(height: AppSpacing.xl),
        _buildAdjuntos(context),
        const SizedBox(height: AppSpacing.xl),
        _buildProximoServicio(context),
      ],
    );
  }

  Widget _buildTaller(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TALLER', style: tt.labelSmall),
          const SizedBox(height: AppSpacing.md),
          Text('Mecánica Sanremo', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('Tu clásico, en buenas manos.', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Text('Av. Insurgentes Sur 1280, CDMX', style: tt.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Ver información del taller →',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.rojoMazda),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjuntos(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adjuntos', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          _adjuntoItem(context, 'PDF', 'Factura del servicio', 'factura_071126.pdf · 245 KB'),
          const SizedBox(height: AppSpacing.md),
          _adjuntoItem(context, 'JPG', 'Orden de trabajo', 'orden_servicio.jpg · 1.2 MB'),
        ],
      ),
    );
  }

  Widget _adjuntoItem(BuildContext context, String tipo, String nombre, String detalle) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 38,
          height: 32,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: cs.outline, width: 0.6),
          ),
          child: Center(
            child: Text(tipo, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.rojoMazda)),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: tt.bodyLarge?.copyWith(fontSize: 14)),
              Text(detalle, style: tt.bodySmall),
            ],
          ),
        ),
        Text('↓', style: tt.headlineMedium),
      ],
    );
  }

  Widget _buildProximoServicio(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRÓXIMO SERVICIO',
            style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('En 750 km', style: tt.displayMedium),
          const SizedBox(height: AppSpacing.lg),
          Text('Ya tienes un recordatorio activo.', style: tt.bodySmall),
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
