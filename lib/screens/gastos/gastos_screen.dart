import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/gasto.dart';
import '../../widgets/common/torque_card.dart';
import '../../widgets/common/indicador_card.dart';

/// Pantalla 6 — Gastos y Estadísticas.
///
/// Selector de periodo, gasto total, gráfica de barras, desglose, rendimiento.
class GastosScreen extends StatelessWidget {
  const GastosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
              _buildIndicadores(isMobile),
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
                if (isMobile) ...[
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Registrar gasto'),
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool showButton) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FINANZAS / TU VEHÍCULO',
          style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text('Tus gastos, en claro.', style: tt.displayLarge?.copyWith(fontSize: showButton ? 40 : 32)),
            ),
            if (showButton)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Registrar gasto'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Conoce cuánto inviertes en cada kilómetro.', style: tt.bodyMedium),
      ],
    );
  }

  Widget _buildIndicadores(bool isMobile) {
    final items = [
      ('Gasto total', '\$3,850', 'Noviembre 2026'),
      ('Combustible', '\$2,250 MXN', '58% del total'),
      ('Mantenimiento', '\$1,250 MXN', '32% del total'),
    ];

    if (isMobile) {
      return Column(
        children: [
          IndicadorCard(etiqueta: items[0].$1, valor: items[0].$2, subtitulo: items[0].$3),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: IndicadorCard(etiqueta: items[1].$1, valor: items[1].$2, subtitulo: items[1].$3, compact: true)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: IndicadorCard(etiqueta: items[2].$1, valor: items[2].$2, subtitulo: items[2].$3, compact: true)),
            ],
          ),
        ],
      );
    }

    return Row(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < items.length - 1 ? AppSpacing.lg : 0),
            child: IndicadorCard(etiqueta: item.$1, valor: item.$2, subtitulo: item.$3),
          ),
        );
      }),
    );
  }

  Widget _buildContenidoPrincipal(BuildContext context) {
    return Column(
      children: [
        _buildGrafica(context),
        const SizedBox(height: AppSpacing.xl),
        _buildUltimosMovimientos(context),
      ],
    );
  }

  Widget _buildGrafica(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cada gasto, en perspectiva.', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('Noviembre 2026  /  Pesos mexicanos', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _barra(context, 'Combustible', 2250, 2250, AppColors.rojoMazda),
                const SizedBox(width: AppSpacing.xl),
                _barra(context, 'Mantenimiento', 1250, 2250, AppColors.rojoMazda),
                const SizedBox(width: AppSpacing.xl),
                _barra(context, 'Otros', 350, 2250, AppColors.rojoMazda),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
        ],
      ),
    );
  }

  Widget _barra(BuildContext context, String label, double valor, double max, Color color) {
    final tt = Theme.of(context).textTheme;
    final ratio = valor / max;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('\$${valor.toInt()}', style: tt.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 120 * ratio,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: tt.bodySmall),
        ],
      ),
    );
  }

  Widget _buildUltimosMovimientos(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final gastos = Gasto.demos;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Últimos movimientos', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(flex: 3, child: Text('CONCEPTO', style: tt.labelSmall)),
              Expanded(flex: 2, child: Text('FECHA', style: tt.labelSmall)),
              Expanded(child: Text('IMPORTE', style: tt.labelSmall, textAlign: TextAlign.end)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...gastos.map((g) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(g.concepto, style: tt.bodyLarge?.copyWith(fontSize: 14))),
                        Expanded(flex: 2, child: Text(g.fecha, style: tt.bodySmall)),
                        Expanded(
                          child: Text(
                            '\$${g.monto.toStringAsFixed(2)}',
                            style: tt.bodyLarge?.copyWith(fontSize: 14),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildPanelLateral(BuildContext context) {
    return Column(
      children: [
        _buildRendimiento(context),
        const SizedBox(height: AppSpacing.xl),
        _buildResumenAnual(context),
      ],
    );
  }

  Widget _buildRendimiento(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RENDIMIENTO PROMEDIO', style: tt.labelSmall),
          const SizedBox(height: AppSpacing.md),
          Text('14.2 km/l', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: AppSpacing.xl),
          Text('↑  8% mejor que el mes anterior', style: tt.bodySmall),
        ],
      ),
    );
  }

  Widget _buildResumenAnual(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tu inversión anual', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('2026', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('\$4,200 MXN', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: AppSpacing.md),
          Text('Un registro claro. Mejores decisiones.', style: tt.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          Text('Costo por kilómetro', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('\$2.85 MXN', style: tt.displayMedium),
          const SizedBox(height: AppSpacing.xl),
          Text('Calculado sobre 1,474 km registrados.', style: tt.bodySmall),
        ],
      ),
    );
  }
}
