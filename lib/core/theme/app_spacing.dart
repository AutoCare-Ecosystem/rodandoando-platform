/// Espaciado coherente con la escala del diseño Figma TORQUE.
///
/// Escala: 4 · 8 · 12 · 16 · 24 · 32 · 48
class AppSpacing {
  AppSpacing._();

  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Radios de esquina según Figma:
  // 8 → controles   12 → tarjetas   16 → paneles
  static const double radiusControl = 8;
  static const double radiusCard    = 12;
  static const double radiusPanel   = 16;
}
