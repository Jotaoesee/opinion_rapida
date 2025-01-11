import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:opinion_rapida/pantallas/inicio_encuestas.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Encuestas y Votaciones',
      home: InicioEncuesta(), // Página de inicio
    );
  }
}
