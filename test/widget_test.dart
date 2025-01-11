import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:opinion_rapida/main.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construye la aplicación y activa un frame.
    await tester
        .pumpWidget(const MiAplicacion()); // Cambia MyApp por MiAplicacion

    // Verifica que el contador comience en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toca el ícono '+' y activa un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador ha incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
