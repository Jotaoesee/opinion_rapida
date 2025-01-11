import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaVotacion extends StatelessWidget {
  final String encuestaId;

  // Constructor
  const PantallaVotacion({super.key, required this.encuestaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votación'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('encuestas')
            .doc(encuestaId)
            .snapshots(), // Usamos snapshots para actualizaciones en tiempo real
        builder: (contexto, instantanea) {
          if (instantanea.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (instantanea.hasError) {
            return const Center(child: Text('Error al cargar la encuesta.'));
          }

          final encuesta = instantanea.data?.data() as Map<String, dynamic>?;

          if (encuesta == null) {
            return const Center(child: Text('Encuesta no encontrada.'));
          }

          final opciones = List<String>.from(encuesta['opciones'] ?? []);
          final Map<String, int> votos =
              Map<String, int>.from(encuesta['votos'] ?? {});

          // Calcular los votos totales para calcular los porcentajes
          // ignore: avoid_types_as_parameter_names
          final totalVotos = votos.values.fold(0, (sum, votos) => sum + votos);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  encuesta['titulo'] ?? 'Sin título',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: opciones.length,
                  itemBuilder: (contexto, indice) {
                    final opcion = opciones[indice];
                    final cantidadVotos = votos[opcion] ?? 0;

                    // Calcular el porcentaje
                    final porcentaje = totalVotos > 0
                        ? (cantidadVotos / totalVotos) * 100
                        : 0.0;

                    return ListTile(
                      title: Text(opcion),
                      subtitle: Text(
                          'Votos: $cantidadVotos (${porcentaje.toStringAsFixed(2)}%)'),
                      onTap: () async {
                        // Incrementa el voto para la opción seleccionada
                        final encuestaRef = FirebaseFirestore.instance
                            .collection('encuestas')
                            .doc(encuestaId);

                        await encuestaRef.update({
                          'votos.$opcion': FieldValue.increment(1),
                        });

                        // Regresar a la pantalla anterior
                        // ignore: use_build_context_synchronously
                        Navigator.pop(contexto);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
