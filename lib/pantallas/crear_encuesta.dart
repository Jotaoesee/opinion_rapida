import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearEncuesta extends StatefulWidget {
  const CrearEncuesta({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrearEncuestaState createState() => _CrearEncuestaState();
}

class _CrearEncuestaState extends State<CrearEncuesta> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _opcionesController = TextEditingController();
  bool _isLoading = false; // Indicador de carga

  void _crearEncuesta() async {
    final nombre = _nombreController.text;
    final titulo = _tituloController.text;
    final opciones = _opcionesController.text
        .split(',')
        .map((opcion) => opcion.trim())
        .where((opcion) => opcion.isNotEmpty)
        .toList();

    if (nombre.isEmpty || titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    if (opciones.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, proporciona exactamente 4 opciones.'),
        ),
      );
      return;
    }

    // Mostrar indicador de carga mientras se crea la encuesta
    setState(() {
      _isLoading = true;
    });

    try {
      // Paso 1: Obtener una referencia al documento que se creará
      final encuestaRef =
          FirebaseFirestore.instance.collection('encuestas').doc();

      // Agregar encuesta a Firestore
      await encuestaRef.set({
        'creador': nombre,
        'titulo': titulo,
        'opciones': opciones, // Se guarda como una lista en Firestore
        'votos':
            List.filled(opciones.length, 0), // Lista de votos inicializados a 0
      });

      if (context.mounted) {
        // Regresar al listado de encuestas después de crearla
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      // Mostrar mensaje de error si ocurre algún problema con Firebase
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la encuesta: $e')),
      );
    } finally {
      // Ocultar indicador de carga
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Crear Encuesta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
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
                // Campo de texto para el nombre del creador
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Tu nombre',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                    labelText: 'Opciones separadas por coma (4 opciones)',
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
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Encuesta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.teal, width: 2),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    elevation: 5,
                  ),
                  onPressed: _isLoading
                      ? null
                      : _crearEncuesta, // Desactivar botón si está cargando
                ),
                if (_isLoading)
                  const Center(
                      child:
                          CircularProgressIndicator()), // Mostrar indicador de carga
              ],
            ),
          ),
        ),
      ),
    );
  }
}
