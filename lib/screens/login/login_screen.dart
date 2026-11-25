import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/brand_logo.dart';
import '../../widgets/common/torque_text_field.dart';
import '../registro/registro_screen.dart';

/// Pantalla 1 — Acceso y Selección de Rol (LoginScreen).
///
/// Autenticación unificada con selección de perfil (CONDUCTOR o TALLER).
/// Columna única en móvil, dos columnas en escritorio.
class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onToggleTheme;

  const LoginScreen({
    super.key,
    required this.onLogin,
    this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  String _rolSeleccionado = 'conductor';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin();
    }
  }

  void _goToRegistro() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegistroScreen(
          onRegister: () {
            Navigator.of(context).pop();
            widget.onLogin();
          },
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= AppTheme.mobileBreakpoint;
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: _buildBrandPanel(context)),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: _buildFormPanel(context),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BrandLogo(fontSize: 20),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildFormPanel(context),
                    ],
                  ),
                );
              },
            ),
            if (widget.onToggleTheme != null)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: IconButton(
                  tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
                  icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                  onPressed: widget.onToggleTheme,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandPanel(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BrandLogo(fontSize: 24),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Cada kilómetro cuenta.\nCada detalle, también.',
            style: tt.displayLarge?.copyWith(fontSize: 36, height: 1.25),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Tu espacio. Tu camino. Sin límites.', style: tt.bodyLarge?.copyWith(color: tt.bodyMedium?.color)),
        ],
      ),
    );
  }

  Widget _buildFormPanel(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Bienvenido', style: tt.displayMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('Inicia sesión para acceder a tu garaje.', style: tt.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),

              TorqueTextField(
                label: 'Correo electrónico',
                hint: 'tu@correo.com',
                controller: _emailCtrl,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              TorqueTextField(
                label: 'Contraseña',
                hint: '••••••••',
                controller: _passCtrl,
                focusNode: _passFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('Tipo de cuenta', style: tt.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(child: _rolChip(context, 'CONDUCTOR', 'conductor')),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _rolChip(context, 'TALLER', 'taller')),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              ElevatedButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: _goToRegistro,
                  child: Text('¿No tienes cuenta? Regístrate', style: tt.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rolChip(BuildContext context, String label, String value) {
    final isSelected = _rolSeleccionado == value;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => setState(() => _rolSeleccionado = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rojoMazda.withValues(alpha: 0.15) : cs.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          border: Border.all(
            color: isSelected ? AppColors.rojoMazda : cs.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.rojoMazda : tt.bodyMedium?.color,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
