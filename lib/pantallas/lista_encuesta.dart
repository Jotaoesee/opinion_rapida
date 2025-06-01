import 'package:flutter/foundation.dart'; // Importado para usar kDebugMode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opinion_rapida/pantallas/pantalla_votacion.dart'; 

/// [ListaEncuesta] es un widget de tipo [StatefulWidget] que muestra una lista
/// dinámica de encuestas obtenidas desde Firestore.
///
/// Este widget permite a los usuarios buscar y filtrar encuestas por el nombre
/// del creador o por el título de la encuesta. Al seleccionar una encuesta
/// de la lista, navega a la [PantallaVotacion] para que el usuario pueda ver
/// los detalles de la encuesta y emitir su voto.
class ListaEncuesta extends StatefulWidget {
  /// Constructor de [ListaEncuesta].
  ///
  /// La clave [key] es opcional y se utiliza para identificar este widget
  /// de forma única en el árbol de widgets.
  const ListaEncuesta({super.key});

  @override
  /// Crea el estado mutable para este widget.
  ///
  /// Retorna una instancia de [_ListaEncuestaState], que es donde se gestiona
  /// la lógica y el estado de la lista de encuestas.
  // ignore: library_private_types_in_public_api
  _ListaEncuestaState createState() => _ListaEncuestaState();
}

/// [_ListaEncuestaState] maneja el estado y la lógica de la interfaz de usuario
/// para la pantalla de lista de encuestas.
///
/// Contiene los controladores para los campos de texto de los filtros y un
/// método que construye la consulta a Firestore, aplicando los filtros de
/// búsqueda en tiempo real. La interfaz de usuario se actualiza reactivamente
/// a medida que cambian los datos en Firestore o los criterios de búsqueda.
class _ListaEncuestaState extends State<ListaEncuesta> {
  /// Controlador para el campo de texto que permite filtrar las encuestas
  /// por el nombre del creador.
  final TextEditingController _filtroCreadorController = TextEditingController();

  /// Controlador para el campo de texto que permite filtrar las encuestas
  /// por el título de la encuesta.
  final TextEditingController _filtroTituloController = TextEditingController();

  /// Método que genera y retorna un [Stream] de [QuerySnapshot] desde Firestore.
  ///
  /// Este stream proporciona una lista en tiempo real de los documentos de
  /// la colección 'encuestas'. La consulta se construye dinámicamente para
  /// aplicar filtros basados en el texto ingresado en [_filtroCreadorController]
  /// y [_filtroTituloController].
  ///
  /// Los filtros de búsqueda (`isGreaterThanOrEqualTo` y `isLessThanOrEqualTo`
  /// con '\uf8ff') permiten realizar búsquedas de tipo "comienza con" (starts-with)
  /// en los campos 'creador' y 'titulo'.
  Stream<QuerySnapshot> _obtenerEncuestas() {
    // Inicializa la consulta base a la colección 'encuestas' en Firestore.
    Query query = FirebaseFirestore.instance.collection('encuestas');

    // Obtiene el texto del filtro por creador, lo limpia (trim) y lo convierte a minúsculas.
    String filtroCreador = _filtroCreadorController.text.trim().toLowerCase();
    // Si el filtro por creador no está vacío, añade las cláusulas de filtro a la consulta.
    if (filtroCreador.isNotEmpty) {
      query = query
          .where('creador', isGreaterThanOrEqualTo: filtroCreador)
          .where('creador', isLessThanOrEqualTo: '$filtroCreador\uf8ff');
    }

    // Obtiene el texto del filtro por título, lo limpia y lo convierte a minúsculas.
    String filtroTitulo = _filtroTituloController.text.trim().toLowerCase();
    // Si el filtro por título no está vacío, añade las cláusulas de filtro a la consulta.
    if (filtroTitulo.isNotEmpty) {
      query = query
          .where('titulo', isGreaterThanOrEqualTo: filtroTitulo)
          .where('titulo', isLessThanOrEqualTo: '$filtroTitulo\uf8ff');
    }

    // Retorna el stream de snapshots de la consulta. Cualquier cambio en los
    // documentos que cumplen los criterios de la consulta resultará en una
    // actualización de la interfaz de usuario a través del StreamBuilder.
    return query.snapshots();
  }

  /// Construye la interfaz de usuario para la pantalla de lista de encuestas.
  ///
  /// La interfaz incluye:
  /// - Un [AppBar] en la parte superior.
  /// - Campos de texto para aplicar filtros de búsqueda.
  /// - Un [StreamBuilder] que escucha los cambios en las encuestas de Firestore
  ///   y construye una lista de widgets dinámicamente.
  /// Cada encuesta se presenta como un [ListTile] dentro de un [Container]
  /// con un estilo visual distintivo.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [AppBar] que define la barra superior de la pantalla.
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo temático.
        title: const Text('Encuestas Disponibles', // Título de la pantalla.
            style: TextStyle(color: Colors.white)), // Asegura que el texto sea blanco.
        centerTitle: true, // Centra el título en el AppBar.
      ),
      // [body] de la pantalla, envuelto en un [Container] con un gradiente de fondo.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300], // Degradado de colores.
            begin: Alignment.topLeft, // Punto de inicio del gradiente.
            end: Alignment.bottomRight, // Punto final del gradiente.
          ),
        ),
        // [Column] que organiza verticalmente los elementos de la interfaz.
        child: Column(
          children: [
            // Sección de filtros de búsqueda, con un padding alrededor.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Campo de texto para el filtro por nombre del creador.
                  TextField(
                    controller: _filtroCreadorController, // Enlaza con el controlador.
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por nombre del creador', // Etiqueta del campo.
                      filled: true, // Indica que el campo debe tener un color de relleno.
                      fillColor: Colors.white, // Color de relleno del campo.
                      border: OutlineInputBorder(), // Estilo de borde del campo.
                      prefixIcon: Icon(Icons.person, color: Colors.teal), // Icono de persona.
                    ),
                    onChanged: (value) {
                      // Llama a setState para reconstruir el widget y aplicar el nuevo filtro
                      // cada vez que el texto del campo de búsqueda cambia.
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10), // Espacio vertical entre los campos de filtro.
                  // Campo de texto para el filtro por título de la encuesta.
                  TextField(
                    controller: _filtroTituloController, // Enlaza con el controlador.
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por título', // Etiqueta del campo.
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title, color: Colors.teal), // Icono de título.
                    ),
                    onChanged: (value) {
                      // Llama a setState para reconstruir el widget y aplicar el nuevo filtro.
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            // [Expanded] para que la lista de encuestas ocupe todo el espacio restante.
            Expanded(
              child: StreamBuilder(
                // [StreamBuilder] para construir la UI de forma reactiva a partir de los datos de Firestore.
                stream: _obtenerEncuestas(), // El stream que proporciona los datos de la consulta.
                builder: (context, snapshot) {
                  // Muestra un indicador de progreso circular mientras se esperan los datos iniciales.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Maneja y muestra cualquier error que ocurra durante la carga de datos.
                  if (snapshot.hasError) {
                    // Imprime el error en la consola solo en modo de depuración.
                    if (kDebugMode) {
                      print('Error al cargar las encuestas: ${snapshot.error}');
                    }
                    return const Center(
                        child: Text('Error al cargar las encuestas.'));
                  }

                  // Obtiene la lista de documentos de encuestas o una lista vacía si no hay datos.
                  final encuestas = snapshot.data?.docs ?? [];

                  // Muestra un mensaje si no se encuentran encuestas (después de aplicar filtros).
                  if (encuestas.isEmpty) {
                    return const Center(
                        child: Text('No hay encuestas disponibles.'));
                  }

                  // Construye una lista desplazable de elementos de encuesta.
                  return ListView.builder(
                    itemCount: encuestas.length, // El número de encuestas a mostrar.
                    itemBuilder: (context, index) {
                      final encuesta = encuestas[index]; // El documento de la encuesta actual.
                      // Extrae el título y el creador, proporcionando valores por defecto si son nulos.
                      final String titulo = encuesta['titulo'] ?? 'Sin título';
                      final String creador = encuesta['creador'] ?? 'Desconocido';
                      final String id = encuesta.id; // El ID único del documento de la encuesta en Firestore.

                      // Retorna un [Container] con estilo que envuelve cada [ListTile] de encuesta.
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16), // Margen alrededor de cada tarjeta de encuesta.
                        decoration: BoxDecoration(
                          color: Colors.white, // Color de fondo de la tarjeta.
                          borderRadius: BorderRadius.circular(8.0), // Bordes redondeados.
                          border: Border.all(color: Colors.teal, width: 2), // Borde de color teal.
                          boxShadow: [
                            // Sombra para dar un efecto de elevación.
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Color y opacidad de la sombra.
                              blurRadius: 4, // Radio de desenfoque de la sombra.
                              offset: const Offset(2, 2), // Desplazamiento de la sombra (X, Y).
                            ),
                          ],
                        ),
                        // [ListTile] que muestra la información de la encuesta y permite la interacción.
                        child: ListTile(
                          title: Text(
                            titulo, // Título de la encuesta.
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Creada por: $creador', // Nombre del creador de la encuesta.
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          trailing: const Icon(Icons.arrow_forward, // Icono de flecha hacia adelante.
                              color: Colors.teal), // Color del icono.
                          onTap: () {
                            // Navega a la [PantallaVotacion] cuando se toca un elemento de la lista.
                            // Pasa el ID de la encuesta seleccionada a la nueva pantalla.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PantallaVotacion(encuestaId: id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}