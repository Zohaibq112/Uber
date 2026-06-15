import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const RideNowApp());
    expect(find.text('RideNow'), findsWidgets);
  });
}
