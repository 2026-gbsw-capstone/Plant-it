import 'package:flutter_test/flutter_test.dart';
import 'package:plant_it_fe/main.dart';

void main() {
  testWidgets('renders splash screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('식물이 죽으면\n너도 죽으세여 :)'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
