/// Modelo de vehículo registrado en el garaje del conductor.
class Vehiculo {
  final String id;
  final String marca;
  final String modelo;
  final int anio;
  final String? apodo;
  final String? placa;
  final int kilometrajeActual;
  final int saludPorcentaje;
  final String? imagenUrl;

  const Vehiculo({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.apodo,
    this.placa,
    required this.kilometrajeActual,
    this.saludPorcentaje = 89,
    this.imagenUrl,
  });

  /// Datos de demostración (Mercedes-Benz 190E del diseño Figma).
  static Vehiculo get demo => const Vehiculo(
        id: '1',
        marca: 'Mercedes-Benz',
        modelo: '190E 2.5-16 Evo II',
        anio: 1990,
        placa: 'TOR · 190',
        kilometrajeActual: 54320,
        saludPorcentaje: 89,
      );
}
