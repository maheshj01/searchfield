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
                  suggestions: ['ABC', 'DEF']
                      .map((e) => SearchFieldListItem(e, SizedBox()))
                      .toList(),
                  initialValue: SearchFieldListItem('ABCD', SizedBox()))),
          throwsAssertionError);

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF']
            .map((e) => SearchFieldListItem(e, SizedBox()))
            .toList(),
      )));

      final finder = find.byType(SearchField);
      expect(finder, findsOneWidget);
    });
    testWidgets('Searchfield should set initial Value',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF']
            .map((e) => SearchFieldListItem(e, SizedBox()))
            .toList(),
        initialValue: SearchFieldListItem('ABC', SizedBox()),
      )));
      final finder = find.text('ABC');
      expect(finder, findsOneWidget);
      final finder2 = find.text('DEF');
      expect(finder2, findsNothing);
    });

    testWidgets(
        'Searchfield should show searched suggestion and all suggestions on empty searchfield',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      int kOptionsCount = 4;
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map((e) => SearchFieldListItem(e, SizedBox()))
            .toList(),
        controller: controller,
        suggestionState: Suggestion.expand,
      )));
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(textField);
      await tester.enterText(textField, 'A');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      expect(find.text('ABC'), findsOneWidget);
      expect(listFinder.evaluate().length, 1);
      // await tester.enterText(textField, '');
      // await tester.pumpAndSettle();
      // expect(listFinder.evaluate().length, kOptionsCount);
    });

    testWidgets('ListView should be visible when searchfield is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF', 'GHI']
            .map((e) => SearchFieldListItem(e, SizedBox()))
            .toList(),
        suggestionState: Suggestion.expand,
      )));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      await tester.tap(find.byType(TextFormField));

      // enter Text isn't required to view the listview, since `suggestionState: Suggestion.expand`
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
