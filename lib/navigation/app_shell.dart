import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';
import '../screens/garaje/garaje_screen.dart';
import '../screens/servicios/servicios_screen.dart';
import '../screens/gastos/gastos_screen.dart';
import '../screens/alta_vehiculo/alta_vehiculo_screen.dart';
import '../widgets/common/brand_logo.dart';

/// Shell de navegación principal — se adapta a 3 tamaños según Figma:
/// - Móvil (< 600px): Barra superior + NavigationBar inferior
/// - Tablet (600px..1024px): Rail lateral compacto de iconos
/// - PC (>= 1024px): Sidebar completo con Mi Garaje + TopBar
class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  bool _showAltaVehiculo = false;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.garage_outlined), selectedIcon: Icon(Icons.garage), label: 'Garaje'),
    NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Servicios'),
    NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Gastos'),
    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
  ];

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
      _showAltaVehiculo = false;
    });
  }

  void _openAltaVehiculo() {
    setState(() {
      _showAltaVehiculo = true;
    });
  }

  Widget get _currentScreen {
    if (_showAltaVehiculo) {
      return const AltaVehiculoScreen();
    }
    return switch (_currentIndex) {
      0 => GarajeScreen(onAddVehicle: _openAltaVehiculo),
      1 => const ServiciosScreen(),
      2 => const GastosScreen(),
      3 => const AltaVehiculoScreen(),
      _ => GarajeScreen(onAddVehicle: _openAltaVehiculo),
    };
  }

  String get _breadcrumb {
    if (_showAltaVehiculo) return 'Añadir vehículo';
    return switch (_currentIndex) {
      0 => 'Garaje',
      1 => 'Servicios',
      2 => 'Gastos',
      3 => 'Perfil',
      _ => 'Garaje',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= AppTheme.desktopBreakpoint;
        final isTablet = width >= AppTheme.mobileBreakpoint && !isDesktop;

        if (isDesktop || isTablet) {
          return Scaffold(
            backgroundColor: bg,
            body: Row(
              children: [
                if (isDesktop) _buildSidebar(context) else _buildTabletRail(context),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      const Divider(height: 1),
                      Expanded(child: _currentScreen),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // ── Móvil (< 600px) ──
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: cs.surface,
            titleSpacing: AppSpacing.lg,
            title: const BrandLogo(fontSize: 16),
            actions: [
              IconButton(
                tooltip: widget.themeMode == ThemeMode.dark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
                icon: Icon(
                  widget.themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                ),
                onPressed: widget.onToggleTheme,
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
            ),
          ),
          body: _currentScreen,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectTab,
            destinations: _destinations,
          ),
        );
      },
    );
  }

  // ── Rail compacto para Tablet (600px..1024px) ──
  Widget _buildTabletRail(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 76,
      color: cs.surface,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface),
              children: const [
                TextSpan(text: 'R'),
                TextSpan(text: 'A', style: TextStyle(color: AppColors.rojoMazda)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _tabletNavItem(context, 0, Icons.garage_outlined, Icons.garage, 'Garaje'),
          _tabletNavItem(context, 1, Icons.build_outlined, Icons.build, 'Servicios'),
          _tabletNavItem(context, 2, Icons.bar_chart_outlined, Icons.bar_chart, 'Gastos'),
          _tabletNavItem(context, 3, Icons.person_outline, Icons.person, 'Perfil'),
          const Spacer(),
          IconButton(
            tooltip: widget.themeMode == ThemeMode.dark ? 'Modo claro' : 'Modo oscuro',
            icon: Icon(
              widget.themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _tabletNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String tooltip) {
    final isActive = !_showAltaVehiculo && _currentIndex == index;
    final tt = Theme.of(context).textTheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _selectTab(index),
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isActive ? AppColors.rojoMazda : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          ),
          child: Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.niebla : tt.bodyMedium?.color,
            size: 22,
          ),
        ),
      ),
    );
  }

  // ── Sidebar completo para PC (>= 1024px) ──
  Widget _buildSidebar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: 232,
      color: cs.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xs),
                      child: BrandLogo(fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Text('TU ESPACIO, TU CAMINO', style: tt.labelSmall),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    _navItem(context, 0, Icons.grid_view_outlined, Icons.grid_view, 'Garaje'),
                    _navItem(context, 1, Icons.build_outlined, Icons.build, 'Servicios'),
                    _navItem(context, 2, Icons.bar_chart_outlined, Icons.bar_chart, 'Gastos'),
                    _navItem(context, 3, Icons.person_outline, Icons.person, 'Perfil'),

                    const SizedBox(height: AppSpacing.xxl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MI GARAJE', style: tt.labelSmall),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                              border: Border.all(color: cs.outline),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mercedes-Benz', style: tt.titleSmall),
                                const SizedBox(height: AppSpacing.xs),
                                Text('190E 2.5-16 Evo II · 1990', style: tt.bodySmall),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          InkWell(
                            onTap: _openAltaVehiculo,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                              child: Text(
                                '+  Añadir vehículo',
                                style: tt.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _showAltaVehiculo ? AppColors.rojoMazda : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('●  Todo bajo control', style: tt.bodySmall),
                          const SizedBox(height: AppSpacing.md),
                          Text('Centro de ayuda  →', style: tt.bodySmall),
                          const SizedBox(height: AppSpacing.xl),
                          Text('Alex Morgan', style: tt.titleSmall),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Conductor apasionado', style: tt.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isActive = !_showAltaVehiculo && _currentIndex == index;
    return _SidebarNavItem(
      icon: isActive ? activeIcon : icon,
      label: label,
      isActive: isActive,
      onTap: () => _selectTab(index),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final tt = Theme.of(context).textTheme;

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      color: bg,
      child: Row(
        children: [
          Text('Mi espacio   /   $_breadcrumb', style: tt.bodyMedium),
          const Spacer(),
          Text('Martes, 10 de noviembre de 2026', style: tt.bodySmall),
          const SizedBox(width: AppSpacing.lg),
          IconButton(
            tooltip: widget.themeMode == ThemeMode.dark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
            icon: Icon(
              widget.themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: tt.bodyMedium?.color,
            ),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: tt.bodyMedium?.color),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final highlighted = widget.isActive || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.isActive
                ? cs.surfaceContainerHighest
                : _isHovered
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.55)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            border: widget.isActive
                ? Border.all(color: cs.outline, width: 0.7)
                : _isHovered
                    ? Border.all(color: cs.outline.withValues(alpha: 0.5), width: 0.7)
                    : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isActive
                    ? AppColors.rojoMazda
                    : _isHovered
                        ? cs.onSurface
                        : tt.bodyMedium?.color,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  color: highlighted ? cs.onSurface : tt.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
