import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  Widget _boilerplate({required Widget child}) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800.0, 600.0)),
          child: Center(
            key: const Key('centerKey'),
            child: Material(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('Searchfield integration tests', () {
    testWidgets(
        'Test assert: Initial value should either be null or should be present in suggestions list.',
        (WidgetTester tester) async {
      await tester.pump();

      expect(
          () => _boilerplate(
              child: SearchField(
                  suggestions: ['ABC', 'DEF'], initialValue: 'GHI')),
          throwsAssertionError);

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF'],
      )));

      final finder = find.byKey(const Key('searchfield'));
      expect(finder, findsOneWidget);
    });
  });
}
