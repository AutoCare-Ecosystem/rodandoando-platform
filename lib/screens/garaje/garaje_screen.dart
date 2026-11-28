import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/vehiculo.dart';
import '../../widgets/common/torque_card.dart';
import '../../widgets/common/indicador_card.dart';
import '../../widgets/common/health_bar.dart';

/// Pantalla 2 — Cockpit Principal / Inicio.
///
/// Muestra el vehículo activo, salud, próximo servicio, gastos e indicadores.
class GarajeScreen extends StatelessWidget {
  final VoidCallback? onAddVehicle;

  const GarajeScreen({super.key, this.onAddVehicle});

  @override
  Widget build(BuildContext context) {
    final vehiculo = Vehiculo.demo;
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

              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildVehiculoCard(context, vehiculo)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: _buildDiagnosticoCard(context)),
                  ],
                )
              else ...[
                _buildVehiculoCard(context, vehiculo),
                const SizedBox(height: AppSpacing.lg),
                _buildDiagnosticoCard(context),
              ],

              const SizedBox(height: AppSpacing.xl),
              _buildIndicadores(isMobile),
              const SizedBox(height: AppSpacing.xl),

              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildProximoPaso(context)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: _buildHechoParaDurar(context)),
                  ],
                )
              else ...[
                _buildProximoPaso(context),
                const SizedBox(height: AppSpacing.lg),
                _buildHechoParaDurar(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool showButton) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EL PLACER DE TENER TODO BAJO CONTROL',
          style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text('Tu garaje.', style: tt.displayLarge?.copyWith(fontSize: showButton ? 40 : 32)),
            ),
            if (showButton)
              OutlinedButton.icon(
                onPressed: onAddVehicle,
                style: OutlinedButton.styleFrom(
                  backgroundColor: cs.surface,
                  side: BorderSide(color: cs.outline),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Añadir vehículo'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Cada kilómetro cuenta. Cada detalle, también.', style: tt.bodyMedium),
      ],
    );
  }

  /// Tarjeta oscura de alto contraste para el vehículo (igual en modo claro y oscuro según Figma).
  Widget _buildVehiculoCard(BuildContext context, Vehiculo v) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borde, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MI VEHÍCULO PRINCIPAL',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.nieblaSutil, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(v.marca, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.niebla)),
                    Text('${v.modelo}   /   ${v.anio}', style: const TextStyle(fontSize: 14, color: AppColors.nieblaSutil)),
                  ],
                ),
              ),
              if (v.placa != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.asfalto,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                    border: Border.all(color: AppColors.borde),
                  ),
                  child: Text(v.placa!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.niebla)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.asfalto,
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
              border: Border.all(color: AppColors.borde),
            ),
            child: const Center(
              child: Icon(Icons.directions_car, size: 68, color: AppColors.nieblaSutil),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${v.saludPorcentaje}%', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700, color: AppColors.niebla)),
              const SizedBox(width: AppSpacing.lg),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Salud del vehículo', style: TextStyle(fontSize: 14, color: AppColors.nieblaSutil)),
                    SizedBox(height: AppSpacing.xs),
                    Text('●  En excelente estado', style: TextStyle(fontSize: 13, color: AppColors.nieblaSutil)),
                  ],
                ),
              ),
              const Text('Ver diagnóstico →', style: TextStyle(fontSize: 13, color: AppColors.nieblaSutil)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticoCard(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Todo en orden', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('Listo para tu próxima aventura.', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          const HealthBar(label: 'Motor', porcentaje: 94),
          const HealthBar(label: 'Frenos', porcentaje: 92),
          const HealthBar(label: 'Neumáticos', porcentaje: 81),
          const HealthBar(label: 'Batería', porcentaje: 89),
        ],
      ),
    );
  }

  Widget _buildIndicadores(bool isMobile) {
    final items = [
      ('Kilometraje', '54,320 km', 'Registrado hoy'),
      ('Próximo servicio', 'En 38 días', 'Cambio de aceite'),
      ('Gasto del mes', '\$4,200 MXN', 'Noviembre 2026'),
    ];

    return Row(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < items.length - 1 ? (isMobile ? AppSpacing.sm : AppSpacing.lg) : 0),
            child: IndicadorCard(
              etiqueta: item.$1,
              valor: item.$2,
              subtitulo: item.$3,
              compact: isMobile,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProximoPaso(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.rojoMazda.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('El próximo paso', style: tt.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.rojoMazda,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                ),
                child: const Text(
                  'Programado',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.niebla),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'CAMBIO DE ACEITE PRÓXIMO',
            style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Cambio de aceite y filtro',
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                TextSpan(
                  text: '  ·  En 750 km  ·  18 dic 2026',
                  style: tt.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.rojoMazda,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Un motor cuidado, un viaje sin límites.', style: tt.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildHechoParaDurar(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HECHO PARA DURAR', style: tt.labelSmall),
          const SizedBox(height: AppSpacing.md),
          Text('Lo extraordinario está\nen los detalles.', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text('Tu pasión. Nuestro cuidado.', style: tt.bodySmall),
        ],
      ),
    );
  }
}
