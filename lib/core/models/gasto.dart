/// Categorías de gasto del vehículo.
enum CategoriaGasto { combustible, mantenimiento, otros }

/// Modelo de gasto registrado.
class Gasto {
  final String id;
  final String concepto;
  final String fecha;
  final double monto;
  final CategoriaGasto categoria;

  const Gasto({
    required this.id,
    required this.concepto,
    required this.fecha,
    required this.monto,
    required this.categoria,
  });

  static List<Gasto> get demos => const [
        Gasto(id: '1', concepto: 'Carga de combustible', fecha: '09 nov 2026', monto: 2250.00, categoria: CategoriaGasto.combustible),
        Gasto(id: '2', concepto: 'Cambio de aceite y filtro', fecha: '07 nov 2026', monto: 1250.00, categoria: CategoriaGasto.mantenimiento),
        Gasto(id: '3', concepto: 'Limpieza y cuidado', fecha: '03 nov 2026', monto: 350.00, categoria: CategoriaGasto.otros),
      ];
}
