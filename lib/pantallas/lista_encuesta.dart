import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opinion_rapida/pantallas/pantalla_votacion.dart';

class ListaEncuesta extends StatefulWidget {
  const ListaEncuesta({super.key});

  @override
  _ListaEncuestaState createState() => _ListaEncuestaState();
}

class _ListaEncuestaState extends State<ListaEncuesta> {
  final TextEditingController _filtroCreadorController =
      TextEditingController();
  final TextEditingController _filtroTituloController = TextEditingController();

  Stream<QuerySnapshot> _obtenerEncuestas() {
    Query query = FirebaseFirestore.instance.collection('encuestas');

    String filtroCreador = _filtroCreadorController.text.trim().toLowerCase();
    if (filtroCreador.isNotEmpty) {
      query = query
          .where('creador', isGreaterThanOrEqualTo: filtroCreador)
          .where('creador', isLessThanOrEqualTo: '$filtroCreador\uf8ff');
    }

    String filtroTitulo = _filtroTituloController.text.trim().toLowerCase();
    if (filtroTitulo.isNotEmpty) {
      query = query
          .where('titulo', isGreaterThanOrEqualTo: filtroTitulo)
          .where('titulo', isLessThanOrEqualTo: '$filtroTitulo\uf8ff');
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Encuestas Disponibles'),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _filtroCreadorController,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por nombre del creador',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Refresca la vista al cambiar el filtro
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _filtroTituloController,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por título',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Refresca la vista al cambiar el filtro
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _obtenerEncuestas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Error al cargar las encuestas: ${snapshot.error}');
                    return const Center(
                        child: Text('Error al cargar las encuestas.'));
                  }

                  final encuestas = snapshot.data?.docs ?? [];

                  if (encuestas.isEmpty) {
                    return const Center(
                        child: Text('No hay encuestas disponibles.'));
                  }

                  return ListView.builder(
                    itemCount: encuestas.length,
                    itemBuilder: (context, index) {
                      final encuesta = encuestas[index];
                      final String titulo = encuesta['titulo'] ?? 'Sin título';
                      final String creador =
                          encuesta['creador'] ?? 'Desconocido';
                      final String id = encuesta.id;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.teal, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(titulo,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text('Creada por: $creador',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Colors.teal),
                          onTap: () {
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
