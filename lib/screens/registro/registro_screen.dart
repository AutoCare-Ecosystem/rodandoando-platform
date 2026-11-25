import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/brand_logo.dart';
import '../../widgets/common/torque_text_field.dart';

/// Pantalla de Registro de Cuenta (RegistroScreen).
///
/// Basada en las entidades `usuario` y `taller` de la plataforma Rodando Ando.
/// Incluye navegación de foco con Enter entre campos y diseño responsivo.
class RegistroScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback? onToggleTheme;

  const RegistroScreen({
    super.key,
    required this.onRegister,
    this.onToggleTheme,
  });

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _tallerNombreCtrl = TextEditingController();
  final _tallerDirCtrl = TextEditingController();
  final _tallerTelCtrl = TextEditingController();

  final _nombreFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();
  final _tallerNombreFocus = FocusNode();
  final _tallerDirFocus = FocusNode();
  final _tallerTelFocus = FocusNode();

  String _rolSeleccionado = 'conductor';

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _tallerNombreCtrl.dispose();
    _tallerDirCtrl.dispose();
    _tallerTelCtrl.dispose();

    _nombreFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    _tallerNombreFocus.dispose();
    _tallerDirFocus.dispose();
    _tallerTelFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Cuenta creada exitosamente!')),
      );
      widget.onRegister();
    }
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
            'Tu garaje digital,\nsiempre contigo.',
            style: tt.displayLarge?.copyWith(fontSize: 36, height: 1.25),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Registra tus vehículos, controla tus mantenimientos y lleva el historial completo en un solo lugar.',
            style: tt.bodyLarge?.copyWith(color: tt.bodyMedium?.color),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPanel(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isTaller = _rolSeleccionado == 'taller';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Crear cuenta', style: tt.displayMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('Únete a Rodando Ando como conductor o taller.', style: tt.bodyMedium),
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
              const SizedBox(height: AppSpacing.lg),

              TorqueTextField(
                label: 'Nombre completo',
                hint: 'Ej. Alex Morgan',
                controller: _nombreCtrl,
                focusNode: _nombreFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

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
                hint: 'Mínimo 6 caracteres',
                controller: _passCtrl,
                focusNode: _passFocus,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPassFocus),
                validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              TorqueTextField(
                label: 'Confirmar contraseña',
                hint: '••••••••',
                controller: _confirmPassCtrl,
                focusNode: _confirmPassFocus,
                obscureText: true,
                textInputAction: isTaller ? TextInputAction.next : TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (isTaller) {
                    FocusScope.of(context).requestFocus(_tallerNombreFocus);
                  } else {
                    _submit();
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                  if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),

              if (isTaller) ...[
                const SizedBox(height: AppSpacing.lg),
                TorqueTextField(
                  label: 'Nombre del taller',
                  hint: 'Ej. Mecánica Sanremo',
                  controller: _tallerNombreCtrl,
                  focusNode: _tallerNombreFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_tallerDirFocus),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre del taller' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TorqueTextField(
                  label: 'Dirección del taller',
                  hint: 'Ej. Av. Insurgentes Sur 1280',
                  controller: _tallerDirCtrl,
                  focusNode: _tallerDirFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_tallerTelFocus),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la dirección' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TorqueTextField(
                  label: 'Teléfono',
                  hint: 'Ej. 55 1234 5678',
                  controller: _tallerTelCtrl,
                  focusNode: _tallerTelFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un teléfono' : null,
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),

              ElevatedButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text('Crear cuenta'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('¿Ya tienes cuenta? Inicia sesión', style: tt.bodyMedium),
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
