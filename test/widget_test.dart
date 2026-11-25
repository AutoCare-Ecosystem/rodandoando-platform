import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodandoando_platform/main.dart';
import 'package:rodandoando_platform/widgets/common/brand_logo.dart';

void main() {
  testWidgets('App arranca, mueve foco con Enter y navega a registro', (WidgetTester tester) async {
    await tester.pumpWidget(const RodandoAndoApp());
    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    // Verifica que Enter mueve el foco del correo a la contraseña
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.tap(fields.at(0));
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    final passEditable = tester.widget<EditableText>(find.descendant(of: fields.at(1), matching: find.byType(EditableText)));
    expect(passEditable.focusNode.hasFocus, isTrue);

    // Navega a la pantalla de registro
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();
    expect(find.text('Crear cuenta'), findsNWidgets(2)); // título + botón
  });
}
