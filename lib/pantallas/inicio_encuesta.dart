import 'package:flutter/material.dart';
import 'package:opinion_rapida/pantallas/crear_encuesta.dart';
import 'package:opinion_rapida/pantallas/lista_encuesta.dart';

/// [InicioEncuesta] es el widget de la pantalla de inicio de la aplicación
/// de encuestas y votaciones.
///
/// Es un [StatelessWidget] ya que su contenido visual (los botones para
/// crear o ver encuestas) no cambia en función de ningún estado interno.
class InicioEncuesta extends StatelessWidget {
  /// Constructor de [InicioEncuesta].
  /// Recibe una clave opcional [key] para identificar este widget.
  const InicioEncuesta({super.key});

  /// Construye la interfaz de usuario para la pantalla de inicio.
  ///
  /// Presenta un [AppBar] con el título de la aplicación y un cuerpo con
  /// un gradiente de fondo, que contiene dos botones principales:
  /// uno para navegar a la pantalla de creación de encuestas y otro
  /// para navegar a la pantalla de lista de encuestas.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [AppBar] que muestra el título de la aplicación.
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar.
        title: const Text(
          'Encuestas en Tiempo Real', // Título de la aplicación.
          style: TextStyle(
            fontWeight: FontWeight.bold, // Texto en negrita.
            fontSize: 22, // Tamaño de fuente del título.
          ),
        ),
        centerTitle: true, // Centra el título horizontalmente en el AppBar.
      ),
      // [body] de la pantalla, que contiene el contenido principal.
      body: Container(
        // Decoración del contenedor con un gradiente lineal para el fondo.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300], // Colores del gradiente, de un teal claro a uno más oscuro.
            begin: Alignment.topLeft, // El gradiente comienza en la esquina superior izquierda.
            end: Alignment.bottomRight, // El gradiente termina en la esquina inferior derecha.
          ),
        ),
        // [Center] widget para centrar el contenido de la columna.
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Relleno de 20.0 en todos los lados.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los hijos verticalmente.
              crossAxisAlignment: CrossAxisAlignment.stretch, // Hace que los hijos se estiren horizontalmente.
              children: [
                // Botón para navegar a la pantalla [CrearEncuesta].
                ElevatedButton.icon(
                  icon: const Icon(Icons.add), // Ícono de "agregar".
                  label: const Text('Crear Encuesta'), // Texto del botón.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fondo blanco.
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Texto y icono negros.
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Relleno vertical.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes ligeramente redondeados.
                      side: const BorderSide(
                          color: Colors.teal, width: 2), // Borde de color teal con un ancho de 2.
                    ),
                    textStyle: const TextStyle(fontSize: 18), // Tamaño de fuente del texto del botón.
                    elevation: 5, // Sombra para dar un efecto de elevación al botón.
                  ),
                  onPressed: () {
                    // Navega a la pantalla [CrearEncuesta] cuando se presiona el botón.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CrearEncuesta(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // Espacio vertical entre los botones.

                // Botón para navegar a la pantalla [ListaEncuesta].
                ElevatedButton.icon(
                  icon: const Icon(Icons.list), // Ícono de "lista".
                  label: const Text('Ver Encuestas'), // Texto del botón.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fondo blanco.
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Relleno vertical.
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Texto y icono negros.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes ligeramente redondeados.
                      side: const BorderSide(
                          color: Colors.teal, width: 2), // Borde de color teal con un ancho de 2.
                    ),
                    textStyle: const TextStyle(fontSize: 18), // Tamaño de fuente del texto del botón.
                    elevation: 5, // Sombra para dar un efecto de elevación al botón.
                  ),
                  onPressed: () {
                    // Navega a la pantalla [ListaEncuesta] cuando se presiona el botón.
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