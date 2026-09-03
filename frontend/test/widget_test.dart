import 'package:flutter_test/flutter_test.dart';

import 'package:hotel_pet_frontend/main.dart';

void main() {
  testWidgets('Exibe a tela inicial com o título do app', (tester) async {
    await tester.pumpWidget(const HotelPetApp());
    await tester.pump();

    expect(find.text('Hotel Pet - Animais Hospedados'), findsOneWidget);
  });
}
