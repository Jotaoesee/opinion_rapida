import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [CrearEncuesta] es un widget de tipo [StatefulWidget] que permite a los usuarios
/// crear nuevas encuestas.
///
/// Contiene campos de entrada para el nombre del creador, el título de la encuesta
/// y las opciones de la encuesta, que se guardan en Firebase Firestore.
class CrearEncuesta extends StatefulWidget {
  /// Constructor de [CrearEncuesta].
  /// Recibe una clave opcional [key] para identificar este widget.
  const CrearEncuesta({super.key});

  @override
  // ignore: library_private_types_in_public_api
  /// Crea el estado mutable para este widget.
  /// Retorna una instancia de [_CrearEncuestaState].
  _CrearEncuestaState createState() => _CrearEncuestaState();
}

/// [_CrearEncuestaState] maneja el estado y la lógica para crear una nueva encuesta.
///
/// Gestiona los controladores de texto, el estado de carga y la interacción
/// con Firestore para guardar los datos de la encuesta.
class _CrearEncuestaState extends State<CrearEncuesta> {
  /// Controlador para el campo de texto del nombre del creador de la encuesta.
  final TextEditingController _nombreController = TextEditingController();

  /// Controlador para el campo de texto del título de la encuesta.
  final TextEditingController _tituloController = TextEditingController();

  /// Controlador para el campo de texto de las opciones de la encuesta,
  /// donde las opciones se esperan separadas por comas.
  final TextEditingController _opcionesController = TextEditingController();

  /// Indicador booleano que controla si una operación de carga (ej. guardar en Firestore)
  /// está en progreso. Se usa para mostrar un [CircularProgressIndicator] y deshabilitar el botón.
  bool _isLoading = false;

  /// Método asíncrono para crear y guardar una nueva encuesta en Firestore.
  ///
  /// Recoge los valores de los campos de texto, realiza validaciones (campos vacíos,
  /// número de opciones), muestra un indicador de carga y, si todo es válido,
  /// sube los datos a la colección 'encuestas' en Firestore.
  /// Finalmente, navega de regreso a la pantalla anterior si la creación es exitosa.
  void _crearEncuesta() async {
    final nombre = _nombreController.text; // Obtiene el nombre del creador.
    final titulo = _tituloController.text; // Obtiene el título de la encuesta.
    // Procesa las opciones: divide por comas, elimina espacios y filtra opciones vacías.
    final opciones = _opcionesController.text
        .split(',')
        .map((opcion) => opcion.trim())
        .where((opcion) => opcion.isNotEmpty)
        .toList();

    // Validación: Asegura que los campos de nombre y título no estén vacíos.
    if (nombre.isEmpty || titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return; // Sale de la función si la validación falla.
    }

    // Validación: Asegura que se proporcionen exactamente 4 opciones.
    if (opciones.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, proporciona exactamente 4 opciones.'),
        ),
      );
      return; // Sale de la función si la validación falla.
    }

    // Muestra el indicador de carga y deshabilita el botón.
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtiene una referencia a la colección 'encuestas' y crea un nuevo documento
      // con un ID generado automáticamente por Firestore.
      final encuestaRef =
          FirebaseFirestore.instance.collection('encuestas').doc();

      // Agrega los datos de la encuesta al documento de Firestore.
      await encuestaRef.set({
        'creador': nombre, // Guarda el nombre del creador.
        'titulo': titulo, // Guarda el título de la encuesta.
        'opciones': opciones, // Guarda las opciones como una lista de strings.
        'votos': List.filled(opciones.length,
            0), // Inicializa una lista de votos a 0 para cada opción.
      });

      // Comprueba si el widget aún está montado antes de realizar operaciones de UI.
      if (context.mounted) {
        // Regresa a la pantalla anterior (generalmente el listado de encuestas)
        // después de una creación exitosa.
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      // Captura y muestra cualquier error que ocurra durante la operación de Firebase.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la encuesta: $e')),
      );
    } finally {
      // Oculta el indicador de carga, independientemente del éxito o error.
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Construye la interfaz de usuario para la pantalla de creación de encuestas.
  ///
  /// Contiene un [AppBar], un [Container] con un gradiente de fondo,
  /// campos de texto para la entrada de datos y un botón para crear la encuesta.
  /// Muestra un indicador de carga si [_isLoading] es verdadero.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar.
        title: const Text(
          'Crear Encuesta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Centra el título en el AppBar.
      ),
      body: Container(
        decoration: BoxDecoration(
          // Define un gradiente de color para el fondo del cuerpo de la pantalla.
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300], // Colores del gradiente.
            begin: Alignment.topLeft, // Punto de inicio del gradiente.
            end: Alignment.bottomRight, // Punto final del gradiente.
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Relleno alrededor del contenido.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente.
              crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos horizontalmente.
              children: [
                // Campo de texto para que el usuario introduzca su nombre.
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Tu nombre', // Etiqueta del campo.
                    labelStyle: TextStyle(color: Colors.black), // Estilo de la etiqueta.
                    filled: true, // El campo tiene un color de relleno.
                    fillColor: Colors.white, // Color de relleno.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)), // Bordes redondeados.
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio vertical.
                // Campo de texto para que el usuario introduzca el título de la encuesta.
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la encuesta', // Etiqueta del campo.
                    labelStyle: TextStyle(color: Colors.black), // Estilo de la etiqueta.
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio vertical.
                // Campo de texto para que el usuario introduzca las opciones de la encuesta,
                // esperando que estén separadas por comas.
                TextField(
                  controller: _opcionesController,
                  decoration: const InputDecoration(
                    labelText: 'Opciones separadas por coma (4 opciones)', // Etiqueta con instrucciones.
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio vertical.
                // Botón para iniciar el proceso de creación de la encuesta.
                // Está deshabilitado si _isLoading es verdadero.
                ElevatedButton.icon(
                  icon: const Icon(Icons.add), // Icono de añadir.
                  label: const Text('Crear Encuesta'), // Texto del botón.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Color de fondo del botón.
                    foregroundColor: Colors.black, // Color del texto e icono.
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Relleno interno.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados.
                      side: const BorderSide(color: Colors.teal, width: 2), // Borde de color teal.
                    ),
                    textStyle: const TextStyle(fontSize: 18), // Estilo del texto.
                    elevation: 5, // Sombra del botón.
                  ),
                  onPressed: _isLoading
                      ? null // Si está cargando, el botón está deshabilitado.
                      : _crearEncuesta, // Llama a _crearEncuesta al presionar.
                ),
                // Muestra un indicador de progreso circular si _isLoading es verdadero.
                if (_isLoading)
                  const Center(
                      child: CircularProgressIndicator()), // Indicador de carga.
              ],
            ),
          ),
        ),
      ),
    );
  }
}