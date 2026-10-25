import 'package:flutter_test/flutter_test.dart';

import 'package:menu_radar/main.dart';

void main() {
  testWidgets('La app arranca y muestra la barra de navegación', (tester) async {
    await tester.pumpWidget(const MenuRadarApp());

    expect(find.text('Radar'), findsWidgets);
    expect(find.text('Comunidad'), findsWidgets);
  });
}
