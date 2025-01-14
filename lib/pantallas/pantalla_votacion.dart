import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaVotacion extends StatefulWidget {
  const PantallaVotacion({super.key, required this.encuestaId});

  final String encuestaId;

  @override
  State<PantallaVotacion> createState() => _PantallaVotacionState();
}

class _PantallaVotacionState extends State<PantallaVotacion> {
  late SharedPreferences _prefs;
  List<String> _votosLocales = [];
  int? _opcionSeleccionada; // Guarda la opción seleccionada
  bool votoRealizado = false; // Para saber si ya se votó

  @override
  void initState() {
    super.initState();
    _cargarVotosLocales();
  }

  Future<void> _cargarVotosLocales() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _votosLocales = _prefs.getStringList(widget.encuestaId) ?? [];
      // Verifica si ya se ha votado anteriormente
      votoRealizado = _votosLocales.contains(widget.encuestaId);
    });
  }

  Future<void> _guardarVotoLocal(int indice) async {
    _votosLocales.add(indice.toString());
    await _prefs.setStringList(widget.encuestaId, _votosLocales);
    setState(() {
      _opcionSeleccionada = indice; // Almacena la opción seleccionada
      votoRealizado = true; // Marca que el voto ya ha sido registrado
    });
  }

  Future<void> _guardarVotoFirebase() async {
    if (_opcionSeleccionada != null &&
        !_votosLocales.contains(_opcionSeleccionada.toString())) {
      try {
        final encuestaRef = FirebaseFirestore.instance
            .collection('encuestas')
            .doc(widget.encuestaId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(encuestaRef);

          if (!snapshot.exists) {
            throw Exception('La encuesta no existe.');
          }

          final datosEncuesta = snapshot.data() as Map<String, dynamic>;
          final List<dynamic> votosActuales =
              List.from(datosEncuesta['votos'] ?? []);

          if (_opcionSeleccionada! >= votosActuales.length) {
            votosActuales.addAll(List.filled(
                _opcionSeleccionada! - votosActuales.length + 1, 0));
          }

          votosActuales[_opcionSeleccionada!] += 1;

          transaction.update(encuestaRef, {'votos': votosActuales});
        });

        await _guardarVotoLocal(_opcionSeleccionada!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voto registrado correctamente')));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al votar: $e');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al registrar el voto')));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Selecciona una opción antes de votar')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Votación',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('encuestas')
              .doc(widget.encuestaId)
              .snapshots(),
          builder: (contexto, instantanea) {
            if (instantanea.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (instantanea.hasError) {
              if (kDebugMode) {
                print('Error en StreamBuilder: ${instantanea.error}');
              }
              return const Center(child: Text('Error al cargar la encuesta.'));
            }

            final encuesta = instantanea.data?.data() as Map<String, dynamic>?;

            if (encuesta == null) {
              return const Center(child: Text('Encuesta no encontrada.'));
            }

            final opciones = encuesta.containsKey('opciones')
                ? List<String>.from(encuesta['opciones'] ?? [])
                : <String>[];

            final List<dynamic> votos = encuesta.containsKey('votos')
                ? List.from(encuesta['votos'] ?? [])
                : <dynamic>[];

            final totalVotos = votos.fold<int>(
                0,
                (previousValue, element) =>
                    previousValue + (element is int ? element : 0));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(encuesta['titulo'] ?? 'Sin título',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: opciones.length,
                    itemBuilder: (contexto, indice) {
                      final opcion = opciones[indice];

                      final cantidadVotos =
                          indice < votos.length ? votos[indice] as int : 0;

                      final porcentaje = totalVotos > 0
                          ? (cantidadVotos / totalVotos) * 100
                          : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        elevation: 5,
                        child: RadioListTile<int>(
                          title: Text(opcion),
                          subtitle: Text(
                              'Votos: $cantidadVotos (${porcentaje.toStringAsFixed(2)}%)'),
                          value: indice,
                          groupValue: _opcionSeleccionada,
                          onChanged: votoRealizado
                              ? null
                              : (int? value) {
                                  setState(() {
                                    _opcionSeleccionada = value;
                                  });
                                },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity, // El botón ocupará todo el ancho
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Guardar Voto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.teal, width: 2),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                          elevation: 5,
                        ),
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
