import 'package:flutter_test/flutter_test.dart';
import 'package:smartskin_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartSkinApp());
    expect(find.text('SmartSkin Analyzer'), findsOneWidget);
  });
}
