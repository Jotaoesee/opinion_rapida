import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearEncuesta extends StatefulWidget {
  const CrearEncuesta({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrearEncuestaState createState() => _CrearEncuestaState();
}

class _CrearEncuestaState extends State<CrearEncuesta> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _opcionesController = TextEditingController();

  void _crearEncuesta() async {
    final titulo = _tituloController.text;
    final opciones = _opcionesController.text
        .split(',')
        .map((opcion) => opcion.trim())
        .toList();

    if (titulo.isNotEmpty && opciones.isNotEmpty) {
      await FirebaseFirestore.instance.collection('encuestas').add({
        'titulo': titulo,
        'opciones': opciones,
        'votos': {for (var opcion in opciones) opcion: 0},
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Regresar al listado de encuestas
    } else {
      // Mostrar un error si los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, ingresa un título y opciones válidas')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        title: const Text(
          'Crear Encuesta',
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
                // Campo de texto para el título de la encuesta
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la encuesta',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de texto para las opciones de la encuesta
                TextField(
                  controller: _opcionesController,
                  decoration: const InputDecoration(
                    labelText: 'Opciones separadas por coma',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                  onPressed: _crearEncuesta,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
