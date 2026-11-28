import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/servicio.dart';
import '../../widgets/common/torque_card.dart';
import '../../widgets/common/servicio_card.dart';
import '../detalle_servicio/detalle_servicio_screen.dart';

/// Pantalla 4 — Plan de Mantenimientos.
///
/// Vista con pestañas Todos / En progreso / Historial, banner de recordatorio,
/// listado de servicios y panel lateral de resumen.
class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  int _filtroActual = 0;

  List<Servicio> get _serviciosFiltrados {
    final todos = Servicio.demos;
    return switch (_filtroActual) {
      1 => todos.where((s) => s.estado == EstadoServicio.enProgreso).toList(),
      2 => todos.where((s) => s.estado == EstadoServicio.completado).toList(),
      _ => todos,
    };
  }

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
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildListaServicios(context)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: _buildPanelLateral(context)),
                  ],
                )
              else ...[
                _buildListaServicios(context),
                if (isMobile) ...[
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Registrar mantenimiento'),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                _buildPanelLateral(context),
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
          'CUIDADO / MANTENIMIENTOS',
          style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text('Cada detalle importa.', style: tt.displayLarge?.copyWith(fontSize: showButton ? 40 : 32)),
            ),
            if (showButton)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Registrar mantenimiento'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Todo el cuidado de tu vehículo, en un solo lugar.', style: tt.bodyMedium),
      ],
    );
  }

  Widget _buildListaServicios(BuildContext context) {
    final servicios = _serviciosFiltrados;
    return Column(
      children: [
        _buildFiltros(context),
        const SizedBox(height: AppSpacing.lg),
        _buildBannerRecordatorio(context),
        const SizedBox(height: AppSpacing.lg),
        ...servicios.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: ServicioCard(
              servicio: s,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DetalleServicioScreen(servicio: s)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltros(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final filtros = [
      ('Todos', Servicio.demos.length),
      ('En progreso', Servicio.demos.where((s) => s.estado == EstadoServicio.enProgreso).length),
      ('Historial', Servicio.demos.where((s) => s.estado == EstadoServicio.completado).length),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: cs.outline, width: 0.7),
      ),
      child: Row(
        children: List.generate(filtros.length, (i) {
          final isActive = _filtroActual == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filtroActual = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isActive ? cs.surfaceContainerHighest : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                  border: isActive ? Border.all(color: cs.outline, width: 0.7) : null,
                ),
                child: Center(
                  child: Text(
                    '${filtros[i].$1}  ${filtros[i].$2}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? cs.onSurface : tt.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBannerRecordatorio(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TU PRÓXIMO SERVICIO', style: tt.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Cambio de aceite y filtro en 750 km.', style: tt.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildPanelLateral(BuildContext context) {
    return Column(
      children: [
        _buildPlanCuidado(context),
        const SizedBox(height: AppSpacing.xl),
        _buildConsejo(context),
      ],
    );
  }

  Widget _buildPlanCuidado(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tu plan de cuidado', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('Mercedes-Benz · TOR-190', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          _planItem(context, '01', 'Pendiente', cs.onSurface),
          const SizedBox(height: AppSpacing.lg),
          _planItem(context, '01', 'En progreso', AppColors.rojoMazda),
          const SizedBox(height: AppSpacing.lg),
          _planItem(context, '01', 'Completado', cs.onSurface),
        ],
      ),
    );
  }

  Widget _planItem(BuildContext context, String count, String label, Color color) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(width: AppSpacing.xl),
        Text(label, style: tt.bodyLarge),
      ],
    );
  }

  Widget _buildConsejo(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EL CUIDADO EMPIEZA CONTIGO',
            style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Un pequeño hábito.\nUn gran recorrido.', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text('Revisa la presión de tus neumáticos cada 15 días.', style: tt.bodySmall),
        ],
      ),
    );
  }
}
