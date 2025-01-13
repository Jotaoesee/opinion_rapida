import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opinion_rapida/pantallas/pantalla_votacion.dart';

class ListaEncuesta extends StatelessWidget {
  const ListaEncuesta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        title: const Text(
          'Encuestas Disponibles',
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('encuestas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error al cargar las encuestas.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final encuestas = snapshot.data?.docs ?? [];

            if (encuestas.isEmpty) {
              return const Center(
                child: Text(
                  'No hay encuestas disponibles.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: encuestas.length,
              itemBuilder: (context, index) {
                final encuesta = encuestas[index];
                final String titulo = encuesta['titulo'] ?? 'Sin título';
                final String creador = encuesta['creador'] ?? 'Anónimo';
                final String id = encuesta.id;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    title: Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Creado por: $creador',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.teal,
                    ),
                    onTap: () {
                      // Navegar a la pantalla de votación
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
    );
  }
}
