import 'package:flutter_test/flutter_test.dart';
import 'package:print_shield/main.dart';

void main() {
  testWidgets('shows the branded splash screen', (tester) async {
    await tester.pumpWidget(const PrintShieldApp());
    expect(find.text('PrintShield'), findsOneWidget);
  });
}
