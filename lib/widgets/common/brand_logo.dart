import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Logotipo tipográfico de Rodando Ando con "ANDO." en rojo de la app.
class BrandLogo extends StatelessWidget {
  final double fontSize;

  const BrandLogo({super.key, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: cs.onSurface,
        ),
        children: const [
          TextSpan(text: 'RODANDO '),
          TextSpan(
            text: 'ANDO',
            style: TextStyle(color: AppColors.rojoMazda),
          ),
        ],
      ),
    );
  }
}
