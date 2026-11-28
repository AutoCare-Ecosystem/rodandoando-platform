import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/torque_card.dart';
import '../../widgets/common/torque_text_field.dart';

/// Pantalla 3 — Alta de Vehículo / Garaje.
///
/// Flujo guiado en pasos para registrar un nuevo vehículo.
class AltaVehiculoScreen extends StatefulWidget {
  const AltaVehiculoScreen({super.key});

  @override
  State<AltaVehiculoScreen> createState() => _AltaVehiculoScreenState();
}

class _AltaVehiculoScreenState extends State<AltaVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _pasoActual = 0;

  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _anioCtrl = TextEditingController();
  final _apodoCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _vinCtrl = TextEditingController();

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _anioCtrl.dispose();
    _apodoCtrl.dispose();
    _kmCtrl.dispose();
    _vinCtrl.dispose();
    super.dispose();
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
                    Expanded(flex: 2, child: _buildFormulario(context)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: _buildInfoLateral(context)),
                  ],
                )
              else ...[
                _buildFormulario(context),
                const SizedBox(height: AppSpacing.xl),
                _buildInfoLateral(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MI GARAJE / NUEVO VEHÍCULO',
          style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Tu nuevo vehículo.', style: tt.displayLarge?.copyWith(fontSize: isWide ? 40 : 32)),
        const SizedBox(height: AppSpacing.sm),
        Text('Empecemos por lo esencial. Nosotros cuidamos el resto.', style: tt.bodyMedium),
      ],
    );
  }

  Widget _buildFormulario(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return TorqueCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(context),
            const SizedBox(height: AppSpacing.xl),
            Text('Empecemos por lo esencial.', style: tt.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Personaliza tu garaje y recibe recordatorios inteligentes.',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),

            LayoutBuilder(
              builder: (context, c) {
                final isFieldWide = c.maxWidth > 500;
                if (isFieldWide) {
                  return Column(
                    children: [
                      Row(children: [
                        Expanded(child: TorqueTextField(label: 'Marca', hint: 'Ej. Mercedes-Benz', controller: _marcaCtrl, validator: _requerido)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: TorqueTextField(label: 'Modelo', hint: 'Ej. 190E 2.5-16', controller: _modeloCtrl, validator: _requerido)),
                      ]),
                      const SizedBox(height: AppSpacing.lg),
                      Row(children: [
                        Expanded(child: TorqueTextField(label: 'Año', hint: 'Ej. 1990', controller: _anioCtrl, keyboardType: TextInputType.number, validator: _requerido)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: TorqueTextField(label: 'Apodo', hint: 'Ej. La Bestia', controller: _apodoCtrl)),
                      ]),
                      const SizedBox(height: AppSpacing.lg),
                      Row(children: [
                        Expanded(child: TorqueTextField(label: 'Kilometraje actual', hint: 'Ej. 54320', controller: _kmCtrl, keyboardType: TextInputType.number, validator: _requerido)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: TorqueTextField(label: 'VIN (opcional)', hint: '17 caracteres', controller: _vinCtrl)),
                      ]),
                    ],
                  );
                }
                return Column(
                  children: [
                    TorqueTextField(label: 'Marca', hint: 'Ej. Mercedes-Benz', controller: _marcaCtrl, validator: _requerido),
                    const SizedBox(height: AppSpacing.lg),
                    TorqueTextField(label: 'Modelo', hint: 'Ej. 190E 2.5-16', controller: _modeloCtrl, validator: _requerido),
                    const SizedBox(height: AppSpacing.lg),
                    TorqueTextField(label: 'Año', hint: 'Ej. 1990', controller: _anioCtrl, keyboardType: TextInputType.number, validator: _requerido),
                    const SizedBox(height: AppSpacing.lg),
                    TorqueTextField(label: 'Apodo', hint: 'Ej. La Bestia', controller: _apodoCtrl),
                    const SizedBox(height: AppSpacing.lg),
                    TorqueTextField(label: 'Kilometraje actual', hint: 'Ej. 54320', controller: _kmCtrl, keyboardType: TextInputType.number, validator: _requerido),
                    const SizedBox(height: AppSpacing.lg),
                    TorqueTextField(label: 'VIN (opcional)', hint: '17 caracteres', controller: _vinCtrl),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                border: Border.all(color: cs.outline),
              ),
              child: Text(
                'Tus datos están seguros. Solo tú decides quién ve tu garaje.',
                style: tt.bodySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                OutlinedButton(
                  onPressed: _pasoActual > 0 ? () => setState(() => _pasoActual--) : null,
                  child: const Text('Anterior'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_pasoActual < 2) {
                        setState(() => _pasoActual++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Vehículo registrado exitosamente!')),
                        );
                      }
                    }
                  },
                  child: Text(_pasoActual < 2 ? 'Siguiente paso →' : 'Confirmar registro'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final pasos = ['01  Tu vehículo', '02  Su historia', '03  Confirmación'];

    return Row(
      children: List.generate(pasos.length, (i) {
        final isActive = i <= _pasoActual;
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pasos[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? cs.onSurface : tt.labelSmall?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                height: 3,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.rojoMazda : cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoLateral(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TorqueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UN GARAJE A TU MEDIDA',
            style: tt.labelSmall?.copyWith(color: AppColors.rojoMazda, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Tu pasión merece\nun buen cuidado.', style: tt.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          const _InfoItem(numero: '01', titulo: 'Nunca olvides un servicio.', desc: 'Recordatorios según el uso de tu vehículo.'),
          const SizedBox(height: AppSpacing.xl),
          const _InfoItem(numero: '02', titulo: 'Toda su historia, contigo.', desc: 'Facturas, talleres y mantenimientos.'),
          const SizedBox(height: AppSpacing.xl),
          const _InfoItem(numero: '03', titulo: 'Cada gasto, en su sitio.', desc: 'Decide mejor con una visión completa.'),
        ],
      ),
    );
  }

  String? _requerido(String? v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null;
}

class _InfoItem extends StatelessWidget {
  final String numero;
  final String titulo;
  final String desc;

  const _InfoItem({required this.numero, required this.titulo, required this.desc});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(numero, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.rojoMazda)),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: tt.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(desc, style: tt.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
