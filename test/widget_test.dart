import 'package:flutter_test/flutter_test.dart';

import 'package:emergency_front_end/app.dart';

void main() {
  testWidgets('shows KhmerSOS splash screen on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmergencyApp());

    expect(find.text('KhmerSOS'), findsOneWidget);
    expect(find.text('Emergency help in your hand'), findsOneWidget);
  });
}
