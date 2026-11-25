/// Estado de un servicio de mantenimiento.
enum EstadoServicio { pendiente, enProgreso, completado }

/// Modelo de servicio de mantenimiento.
class Servicio {
  final String id;
  final String titulo;
  final String taller;
  final String fecha;
  final int kilometraje;
  final double costoEstimado;
  final EstadoServicio estado;
  final String? diagnostico;

  const Servicio({
    required this.id,
    required this.titulo,
    required this.taller,
    required this.fecha,
    required this.kilometraje,
    required this.costoEstimado,
    required this.estado,
    this.diagnostico,
  });

  static List<Servicio> get demos => const [
        Servicio(
          id: '1',
          titulo: 'Cambio de aceite y filtro',
          taller: 'Mecánica Sanremo',
          fecha: '07 nov 2026',
          kilometraje: 53570,
          costoEstimado: 1250.00,
          estado: EstadoServicio.completado,
        ),
        Servicio(
          id: '2',
          titulo: 'Revisión de frenos',
          taller: 'Mecánica Sanremo',
          fecha: '20 nov 2026',
          kilometraje: 54800,
          costoEstimado: 2800.00,
          estado: EstadoServicio.enProgreso,
        ),
        Servicio(
          id: '3',
          titulo: 'Alineación y balanceo',
          taller: 'Centro Llantero Express',
          fecha: '15 dic 2026',
          kilometraje: 56000,
          costoEstimado: 650.00,
          estado: EstadoServicio.pendiente,
        ),
      ];
}
