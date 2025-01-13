import 'package:flutter/material.dart';
import 'package:opinion_rapida/pantallas/crear_encuesta.dart';
import 'package:opinion_rapida/pantallas/lista_encuesta.dart';

class InicioEncuesta extends StatelessWidget {
  const InicioEncuesta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        title: const Text(
          'Encuestas en Tiempo Real',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Centrar el título
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Botón para crear encuesta
                ElevatedButton.icon(
                  icon: const Icon(Icons.add), // Ícono de "agregar"
                  label: const Text('Crear Encuesta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                          color: Colors.teal, width: 2), // Borde
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    elevation: 5, // Sombra al botón
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CrearEncuesta(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Botón para ver listado de encuestas
                ElevatedButton.icon(
                  icon: const Icon(Icons.list), // Ícono de "lista"
                  label: const Text('Ver Encuestas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                          color: Colors.teal, width: 2), // Borde
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListaEncuesta(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
