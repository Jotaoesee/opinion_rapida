import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InicioEncuesta extends StatelessWidget {
  const InicioEncuesta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuestas en Tiempo Real'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('encuestas').snapshots(),
        builder: (contexto, instantanea) {
          if (instantanea.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!instantanea.hasData || instantanea.data!.docs.isEmpty) {
            return const Center(
              child: Text('No hay encuestas disponibles'),
            );
          }
          final encuestas = instantanea.data!.docs;
          return ListView.builder(
            itemCount: encuestas.length,
            itemBuilder: (contexto, indice) {
              final encuesta = encuestas[indice];
              return ListTile(
                title: Text(encuesta['titulo'] ?? 'Sin título'),
                onTap: () {
                  // Aquí puedes navegar a una pantalla de votación si lo deseas
                },
              );
            },
          );
        },
      ),
    );
  }
}
