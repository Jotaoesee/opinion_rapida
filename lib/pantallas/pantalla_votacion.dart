import 'package:flutter/foundation.dart'; // Para kDebugMode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para persistencia local

/// [PantallaVotacion] es un widget de tipo [StatefulWidget] que permite a los usuarios
/// ver una encuesta específica y votar en ella.
///
/// Requiere el [encuestaId] para cargar los datos de la encuesta desde Firestore.
/// Gestiona el estado de la votación localmente para evitar votos duplicados.
class PantallaVotacion extends StatefulWidget {
  /// Constructor de [PantallaVotacion].
  ///
  /// [key] es una clave opcional para identificar este widget.
  /// [encuestaId] es el ID único de la encuesta a mostrar y votar.
  const PantallaVotacion({super.key, required this.encuestaId});

  /// El ID del documento de la encuesta en Firestore.
  final String encuestaId;

  @override
  /// Crea el estado mutable para este widget.
  /// Retorna una instancia de [_PantallaVotacionState].
  State<PantallaVotacion> createState() => _PantallaVotacionState();
}

/// [_PantallaVotacionState] maneja el estado y la lógica de la pantalla de votación.
///
/// Gestiona la persistencia de votos usando `SharedPreferences`, la opción
/// seleccionada por el usuario y la interacción con Firestore para actualizar
/// los conteos de votos de la encuesta en tiempo real.
class _PantallaVotacionState extends State<PantallaVotacion> {
  /// Instancia de [SharedPreferences] para almacenar datos localmente.
  late SharedPreferences _prefs;

  /// Lista de votos registrados localmente para esta encuesta. Se usa para
  /// determinar si el usuario ya ha votado en esta encuesta específica.
  List<String> _votosLocales = [];

  /// Almacena el índice de la opción seleccionada por el usuario.
  /// Es nulo si ninguna opción ha sido seleccionada aún.
  int? _opcionSeleccionada;

  /// Bandera booleana que indica si el usuario ya ha emitido un voto
  /// para esta encuesta. Se usa para deshabilitar el botón de votar
  /// y las opciones de radio después de un voto.
  bool votoRealizado = false;

  @override
  /// Se llama una vez cuando el estado se inserta en el árbol de widgets.
  /// Inicializa la carga de votos locales.
  void initState() {
    super.initState();
    _cargarVotosLocales();
  }

  /// Carga los votos previamente registrados localmente para esta encuesta
  /// utilizando [SharedPreferences].
  ///
  /// Actualiza [_votosLocales] y [votoRealizado] en base a los datos guardados.
  Future<void> _cargarVotosLocales() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Intenta obtener la lista de votos guardada para la encuesta actual.
      _votosLocales = _prefs.getStringList(widget.encuestaId) ?? [];
      // Si la lista de votos para esta encuesta no está vacía, significa
      // que el usuario ya ha votado.
      votoRealizado = _votosLocales.isNotEmpty;
    });
  }

  /// Guarda el índice de la opción votada localmente en [SharedPreferences].
  ///
  /// Esto asegura que el usuario no pueda votar múltiples veces en la misma encuesta
  /// desde el mismo dispositivo, incluso si la aplicación se cierra y se vuelve a abrir.
  ///
  /// [indice] El índice de la opción por la que se votó.
  Future<void> _guardarVotoLocal(int indice) async {
    // Si la opción no ha sido registrada localmente, la añade.
    // Aunque votoRealizado ya debería prevenir esto, es una doble verificación.
    if (!_votosLocales.contains(indice.toString())) {
      _votosLocales.add(indice.toString());
      await _prefs.setStringList(widget.encuestaId, _votosLocales);
    }
    setState(() {
      _opcionSeleccionada = indice; // Almacena la opción seleccionada.
      votoRealizado = true; // Marca que el voto ya ha sido registrado.
    });
  }

  /// Guarda el voto seleccionado por el usuario en Firestore.
  ///
  /// Utiliza una transacción de Firestore para asegurar que la actualización
  /// del conteo de votos sea atómica y segura, evitando condiciones de carrera.
  /// También registra el voto localmente después de una actualización exitosa en Firestore.
  Future<void> _guardarVotoFirebase() async {
    // Verifica que se haya seleccionado una opción y que el voto no haya sido registrado localmente.
    if (_opcionSeleccionada != null && !votoRealizado) {
      try {
        // Obtiene una referencia al documento de la encuesta en Firestore.
        final encuestaRef = FirebaseFirestore.instance
            .collection('encuestas')
            .doc(widget.encuestaId);

        // Ejecuta una transacción para actualizar el conteo de votos de forma segura.
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(encuestaRef);

          // Lanza una excepción si la encuesta no existe.
          if (!snapshot.exists) {
            throw Exception('La encuesta no existe.');
          }

          // Obtiene los datos actuales de la encuesta.
          final datosEncuesta = snapshot.data() as Map<String, dynamic>;
          // Crea una copia modificable de la lista de votos actual.
          final List<dynamic> votosActuales = List.from(datosEncuesta['votos'] ?? []);

          // Asegura que la lista de votos tenga suficiente espacio para la opción seleccionada.
          // Esto maneja el caso de que el campo 'votos' en Firestore no esté inicializado
          // con el tamaño correcto o que una opción no tuviera un contador preexistente.
          if (_opcionSeleccionada! >= votosActuales.length) {
            votosActuales.addAll(List.filled(
                _opcionSeleccionada! - votosActuales.length + 1, 0));
          }

          // Incrementa el contador de votos para la opción seleccionada.
          votosActuales[_opcionSeleccionada!] += 1;

          // Actualiza el documento de la encuesta en la transacción.
          transaction.update(encuestaRef, {'votos': votosActuales});
        });

        // Si la transacción en Firebase es exitosa, guarda el voto localmente.
        await _guardarVotoLocal(_opcionSeleccionada!);

        // Muestra un mensaje de éxito si el widget sigue montado.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voto registrado correctamente')));
        }
      } catch (e) {
        // Imprime el error en modo depuración.
        if (kDebugMode) {
          print('Error al votar: $e');
        }
        // Muestra un mensaje de error si el widget sigue montado.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al registrar el voto')));
        }
      }
    } else {
      // Muestra un mensaje si no se ha seleccionado una opción o ya se votó.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Selecciona una opción antes de votar o ya votaste.')));
      }
    }
  }

  /// Construye la interfaz de usuario para la pantalla de votación.
  ///
  /// Muestra el título de la encuesta y una lista de opciones con sus
  /// respectivos conteos de votos y porcentajes. Permite al usuario
  /// seleccionar una opción y votar. Una vez que se vota, los botones
  /// de opción se deshabilitan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar.
        title: const Text('Votación', // Título de la pantalla.
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true, // Centra el título.
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300], // Gradiente de fondo.
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // [StreamBuilder] para obtener los datos de la encuesta en tiempo real desde Firestore.
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('encuestas')
              .doc(widget.encuestaId)
              .snapshots(), // Escucha los cambios en el documento de la encuesta.
          builder: (contexto, instantanea) {
            // Muestra un indicador de carga mientras se esperan los datos.
            if (instantanea.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Maneja errores si ocurren al cargar los datos.
            if (instantanea.hasError) {
              if (kDebugMode) {
                print('Error en StreamBuilder: ${instantanea.error}');
              }
              return const Center(child: Text('Error al cargar la encuesta.'));
            }

            // Obtiene los datos de la encuesta o nulo si no existen.
            final encuesta = instantanea.data?.data() as Map<String, dynamic>?;

            // Muestra un mensaje si la encuesta no se encuentra.
            if (encuesta == null) {
              return const Center(child: Text('Encuesta no encontrada.'));
            }

            // Extrae las opciones de la encuesta, asegurando que sea una lista de Strings.
            final opciones = encuesta.containsKey('opciones')
                ? List<String>.from(encuesta['opciones'] ?? [])
                : <String>[];

            // Extrae el conteo de votos, asegurando que sea una lista.
            final List<dynamic> votos = encuesta.containsKey('votos')
                ? List.from(encuesta['votos'] ?? [])
                : <dynamic>[];

            // Calcula el total de votos para todas las opciones.
            final totalVotos = votos.fold<int>(
                0, // Valor inicial del acumulador.
                (previousValue, element) =>
                    previousValue + (element is int ? element : 0)); // Suma los votos de cada opción.

            return Column(
              children: [
                // Título de la encuesta.
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(encuesta['titulo'] ?? 'Sin título',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                // Lista expandida de opciones de votación.
                Expanded(
                  child: ListView.builder(
                    itemCount: opciones.length, // Número de opciones.
                    itemBuilder: (contexto, indice) {
                      final opcion = opciones[indice]; // Opción actual.

                      // Obtiene la cantidad de votos para la opción actual, o 0 si no existe.
                      final cantidadVotos =
                          indice < votos.length ? votos[indice] as int : 0;

                      // Calcula el porcentaje de votos para la opción.
                      final porcentaje = totalVotos > 0
                          ? (cantidadVotos / totalVotos) * 100
                          : 0.0;

                      // [Card] que contiene el [RadioListTile] para cada opción.
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0), // Margen de la tarjeta.
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)), // Bordes redondeados.
                        elevation: 5, // Sombra de la tarjeta.
                        child: RadioListTile<int>(
                          title: Text(opcion), // Texto de la opción.
                          subtitle: Text(
                              'Votos: $cantidadVotos (${porcentaje.toStringAsFixed(2)}%)'), // Votos y porcentaje.
                          value: indice, // Valor de la opción (su índice).
                          groupValue: _opcionSeleccionada, // La opción seleccionada actualmente.
                          // Callback cuando cambia la selección. Se deshabilita si ya se votó.
                          onChanged: votoRealizado
                              ? null // Deshabilita los RadioListTile si ya se votó.
                              : (int? value) {
                                  setState(() {
                                    _opcionSeleccionada = value; // Actualiza la opción seleccionada.
                                  });
                                },
                        ),
                      );
                    },
                  ),
                ),
                // Botón para guardar el voto.
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter, // Alinea el botón al centro inferior.
                    child: SizedBox(
                      width: double.infinity, // El botón ocupa todo el ancho disponible.
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle), // Icono de verificación.
                        label: const Text('Guardar Voto'), // Texto del botón.
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255), // Fondo blanco.
                          padding: const EdgeInsets.symmetric(vertical: 15.0), // Relleno vertical.
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Texto y icono negros.
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Bordes redondeados.
                            side:
                                const BorderSide(color: Colors.teal, width: 2), // Borde teal.
                          ),
                          textStyle: const TextStyle(fontSize: 18), // Estilo del texto.
                          elevation: 5, // Sombra del botón.
                        ),
                        // El botón está deshabilitado si ya se votó (`votoRealizado` es true).
                        onPressed: votoRealizado ? null : _guardarVotoFirebase,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}