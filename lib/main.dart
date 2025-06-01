import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:opinion_rapida/pantallas/inicio_encuesta.dart';
import 'firebase_options.dart';

/// Función principal que inicia la aplicación Flutter.
///
/// Este es el punto de entrada de la aplicación. Es una función `async`
/// porque necesita realizar operaciones asíncronas para inicializar Firebase.
void main() async {
  /// Asegura que los bindings de Flutter estén inicializados antes
  /// de usar cualquier método de Flutter o plugins. Esto es crucial
  /// antes de llamar a [Firebase.initializeApp].
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializa Firebase para la plataforma actual.
  ///
  /// Utiliza las opciones por defecto generadas por `flutterfire configure`,
  /// que se encuentran en [DefaultFirebaseOptions.currentPlatform].
  /// Esta operación es asíncrona, por lo que se usa `await`.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Ejecuta la aplicación Flutter.
  ///
  /// [runApp] toma el widget raíz de la aplicación, en este caso, [MiAplicacion],
  /// y lo muestra en la pantalla.
  runApp(const MiAplicacion());
}

/// [MiAplicacion] es el widget raíz de la aplicación de encuestas y votaciones.
///
/// Es un [StatelessWidget] ya que su configuración principal (tema y página inicial)
/// no cambia durante la vida de la aplicación.
class MiAplicacion extends StatelessWidget {
  /// Constructor de [MiAplicacion].
  ///
  /// Recibe una clave opcional [key] para identificar este widget.
  const MiAplicacion({super.key});

  /// Construye la interfaz de usuario principal de la aplicación.
  ///
  /// Retorna un [MaterialApp], que proporciona la estructura de una aplicación
  /// que sigue las directrices de Material Design.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      /// Título de la aplicación que aparece en la barra de título del sistema
      /// (por ejemplo, en la lista de aplicaciones recientes o en la pestaña del navegador para la web).
      title: 'Encuestas y Votaciones',

      /// Define la primera pantalla que se muestra cuando la aplicación se inicia.
      /// En este caso, es la página [InicioEncuesta].
      home: InicioEncuesta(), // Página de inicio de la aplicación de encuestas.
    );
  }
}