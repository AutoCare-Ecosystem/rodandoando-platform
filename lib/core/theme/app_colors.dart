import 'package:flutter/material.dart';

/// Paleta de colores Rodando Ando — extraída del diseño Figma (Oscuro y Claro).
class AppColors {
  AppColors._();

  // ── Fondos Oscuro ───────────────────────────────────────
  static const Color asfalto = Color(0xFF0B0D0D); // fondo principal oscuro
  static const Color superficie = Color(0xFF141818); // tarjetas / sidebar oscuro
  static const Color superficieAlt = Color(0xFF1A1E1E); // hover / variante oscuro

  // ── Fondos Claro ────────────────────────────────────────
  static const Color nieblaFondo = Color(0xFFF4F6F6); // fondo principal claro
  static const Color blancoPuro = Color(0xFFFFFFFF); // tarjetas / sidebar claro
  static const Color grisClaro = Color(0xFFEAECEC); // hover / variante claro

  // ── Acento ──────────────────────────────────────────────
  static const Color rojoMazda = Color(0xFFD62E00); // acento primario
  static const Color rojoMazdaDark = Color(0xFFB02500); // hover del botón

  // ── Semánticos ──────────────────────────────────────────
  static const Color enOrden = Color(0xFF5DD6A6); // verde éxito
  static const Color enOrdenClaro  = Color(0xFF16A34A); // verde éxito sobre claro
  static const Color atencion = Color(0xFFFFC35C); // ámbar advertencia
  static const Color error = Color(0xFFEF4444); // rojo error

  // ── Texto Oscuro ────────────────────────────────────────
  static const Color niebla = Color(0xFFF4F6F6); // texto principal oscuro
  static const Color nieblaSutil = Color(0xFFB0B4B4); // texto secundario oscuro
  static const Color nieblaApagada = Color(0xFF6B7070); // texto desactivado oscuro

  // ── Texto Claro ─────────────────────────────────────────
  static const Color textoOscuro = Color(0xFF0B0D0D); // texto principal claro
  static const Color textoOscuroSutil = Color(0xFF525858); // texto secundario claro
  static const Color textoOscuroApagado = Color(0xFF8C9292); // texto desactivado claro

  // ── Bordes / separadores ────────────────────────────────
  static const Color borde = Color(0xFF2A2E2E);
  static const Color separador = Color(0xFF222626);
  static const Color bordeClaro = Color(0xFFE0E4E4);
  static const Color separadorClaro = Color(0xFFE5E8E8);
}
