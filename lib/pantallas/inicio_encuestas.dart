import 'package:flutter/material.dart';
import 'package:opinion_rapida/pantallas/pantalla_votacion.dart';

class InicioEncuesta extends StatelessWidget {
  const InicioEncuesta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuestas en Tiempo Real'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Puedes añadir el botón para navegar a la pantalla de votación
            ElevatedButton(
              onPressed: () {
                // Crear un ID ficticio para la encuesta, puedes cambiarlo según sea necesario
                String encuestaId = 'encuesta_prueba_id_123';

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaVotacion(
                      encuestaId: encuestaId, // Pasamos el ID ficticio
                    ),
                  ),
                );
              },
              child: const Text('Ir a Votación'),
            ),
          ],
        ),
      ),
    );
  }
}
