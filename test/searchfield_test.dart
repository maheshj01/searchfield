import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchfield/searchfield.dart';

import 'meta_data.dart';

void main() {
  Widget _boilerplate({required Widget child}) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800.0, 600.0)),
          child: Material(
            child: child,
          ),
        ),
      ),
    );
  }

  group('Searchfield sanitary tests: ', () {
    testWidgets(
        'Test assert: Initial value should either be null or should be present in suggestions list.',
        (WidgetTester tester) async {
      await tester.pump();

      expect(
          () => _boilerplate(
              child: SearchField<String>(
                  suggestions: ['ABC', 'DEF']
                      .map<SearchFieldListItem<String>>(SearchFieldListItem.new)
                      .toList(),
                  initialValue: SearchFieldListItem<String>('ABCD'))),
          throwsAssertionError);

      await tester.pumpWidget(_boilerplate(
          child: SearchField<String>(
        key: const Key('searchfield'),
        suggestions:
            ['ABC', 'DEF'].map(SearchFieldListItem<String>.new).toList(),
      )));

      final finder = find.byType(TextFormField);
      expect(finder, findsOneWidget);
    });

    testWidgets('Searchfield should set initial Value',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestionItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            border: Border.all(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 1.0)),
        suggestions:
            ['ABC', 'DEF'].map(SearchFieldListItem<String>.new).toList(),
        initialValue: SearchFieldListItem<String>('ABC'),
      )));
      final finder = find.text('ABC');
      expect(finder, findsOneWidget);
      final finder2 = find.text('DEF');
      expect(finder2, findsNothing);
    });

    testWidgets(
        'Searchfield should show suggestions when `resizeToAvoidBottomInset` false',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SearchField<String>(
                  suggestions: ['ABC', 'DE', 'DFHK']
                      .map<SearchFieldListItem<String>>(
                          (e) => SearchFieldListItem(e, child: Text(e)))
                      .toList()),
            )),
      ));
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
    });

    testWidgets('Searchfield should show searched suggestions',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
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
      // print('text in controller: ${controller.text}');
      // await tester.pumpAndSettle();
      // expect(listFinder.evaluate().length, kOptionsCount);
    });

    testWidgets('Searchfield should show empty widget for no results',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
            .toList(),
        controller: controller,
        emptyWidget: const Text('No results'),
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
      await tester.enterText(textField, 'text not in list');
      await tester.pumpAndSettle();
      expect(listFinder, findsNothing);
      expect(find.text('No results'), findsOneWidget);
    });
  });

  testWidgets(
      'Searchfield Suggestions should default height should be less than 175 when suggestions count < 5',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final kdefaultLengthInViewPort = 5;
    final kdefaultHeight = 35;
    final suggestionListLength = 4;
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
          .map(SearchFieldListItem<String>.new)
          .toList(),
      controller: controller,
      suggestionState: Suggestion.expand,
    )));
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, '');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    final baseSize = tester.getSize(listFinder);
    final resultingHeight = baseSize.height;
    final expectedHeight =
        min(suggestionListLength, kdefaultLengthInViewPort) * kdefaultHeight;
    expect(resultingHeight, equals(expectedHeight));
  });
  testWidgets(
      'Searchfield Suggestions default height should not exceed 175 (35*5) when suggestions count > 5)',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final kdefaultLengthInViewPort = 5;
    final kdefaultHeight = 35;
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: ['ABC', 'DEF', 'GHI', 'JKL', 'MNO', 'PQR']
          .map(SearchFieldListItem<String>.new)
          .toList(),
      controller: controller,
      suggestionState: Suggestion.expand,
    )));
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, '');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    final baseSize = tester.getSize(listFinder);
    final resultingHeight = baseSize.height;
    final expectedHeight = kdefaultLengthInViewPort * kdefaultHeight;
    expect(resultingHeight, equals(expectedHeight));
  });

  /// "TODO: Fix this test"

  // testWidgets(
  //     'SearchField should show generic type search key in searchfield on suggestionTap)',
  //     (WidgetTester tester) async {
  //   final controller = TextEditingController();
  //   final countries = data.map((e) => Country.fromMap(e)).toList();
  //   await tester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions:
  //         countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
  //     controller: controller,
  //     suggestionState: Suggestion.expand,
  //     onSuggestionTap: (SearchFieldListItem<Country> x) {
  //       print(x.searchKey);
  //     },
  //   )));
  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   final tapTarget = find.text(countries[0].name);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await tester.tap(textField);
  //   await tester.enterText(textField, '');
  //   await tester.pumpAndSettle();
  //   expect(listFinder, findsOneWidget);
  //   expect(tapTarget, findsOneWidget);
  //   await tester.tap(tapTarget);
  //   await tester.pumpAndSettle(Duration(seconds: 1));
  //   expect(controller.text, equals(countries[0].name));
  // });

  // testWidgets('FocusNode should work with searchfield',
  //     (WidgetTester tester) async {
  //   final focus = FocusNode();
  //   final countries = data.map((e) => Country.fromMap(e)).toList();
  //   await tester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions:
  //         countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
  //     focusNode: focus,
  //     suggestionState: Suggestion.expand,
  //     onSuggestionTap: (SearchFieldListItem<Country> x) {
  //       focus.unfocus();
  //     },
  //   )));
  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await tester.tap(textField);
  //   expect(focus.hasFocus, true);
  //   await tester.enterText(textField, '');
  //   await tester.pumpAndSettle();
  //   expect(listFinder, findsOneWidget);
  //   final tapTarget = find.text(countries[0].name);
  //   expect(tapTarget, findsOneWidget);
  //   await tester.tap(tapTarget);
  //   await tester.pumpAndSettle();
  //   expect(focus.hasFocus, false);
  // });

  testWidgets('Searchfield should trigger onTap when tapped',
      (widgetTester) async {
    final controller = TextEditingController();
    final countries = data.map(Country.fromMap).toList();
    int tapCount = 0;
    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
      controller: controller,
      suggestions:
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
      suggestionState: Suggestion.expand,
      onTap: () {
        tapCount++;
      },
    )));

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(tapCount, 0);
    await widgetTester.tap(textField);
    await widgetTester.pumpAndSettle();
    expect(tapCount, 1);
  });

  testWidgets('Searchfield should support readOnly mode',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final countries = data.map(Country.fromMap).toList();
    var readOnly = true;
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      readOnly: readOnly,
      controller: controller,
      suggestions:
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
      suggestionState: Suggestion.expand,
    )));

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await tester.tap(textField);
    await tester.enterText(textField, 'test');
    await tester.pumpAndSettle();
    expect(controller.text, '');
    readOnly = false;
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      readOnly: readOnly,
      controller: controller,
      suggestions:
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
      suggestionState: Suggestion.expand,
    )));
    await tester.enterText(find.byType(TextFormField), 'test');
    await tester.pumpAndSettle();
    expect(controller.text, 'test');
  });

  testWidgets('suggestions can be updated in the runtime',
      (WidgetTester tester) async {
    var counter = 3;
    final suggestions = [
      'suggestion 1',
      'suggestion 2',
    ];
    await tester.pumpWidget(_boilerplate(child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SearchField(
              maxSuggestionsInViewPort: counter,
              key: const Key('searchfield'),
              suggestions:
                  suggestions.map(SearchFieldListItem<String>.new).toList(),
              suggestionState: Suggestion.expand,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      counter++;
                      suggestions.add('suggestion $counter');
                    },
                  );
                },
                child: Text('tap me'))
          ],
        );
      },
    )));
    final button = find.byType(ElevatedButton);
    final listView = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(button, findsOneWidget);
    expect(listView, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, '');
    await tester.pumpAndSettle();
    expect(listView, findsWidgets);
    expect(find.text('suggestion $counter'), findsNothing);
    expect(find.text('suggestion ${counter - 1}'), findsOneWidget);
    expect(suggestions.length, equals(2));
    await tester.tap(button);
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(suggestions.length, equals(3));
    expect(find.text('suggestion $counter'), findsOneWidget);
  });

  group('Searchfield should respect SuggestionState: ', () {
    testWidgets('ListView should be visible when searchfield is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions:
            ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
      )));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      await tester.tap(find.byType(TextFormField));

      // potentially a bug: enter Text shouldn;t be required to view the listview, since `suggestionState: Suggestion.expand`
      await tester.enterText(find.byType(TextFormField), '');

      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('ListView should be hidden when searchfield is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions:
            ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.hidden,
      )));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      await tester.tap(find.byType(TextFormField));

      await tester.enterText(find.byType(TextFormField), '');

      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsNothing);
    });
  });
  group('Suggestions should respect Offset', () {
    testWidgets('suggestions should be below textfield by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
        child: SearchField(
          key: const Key('searchfield'),
          itemHeight: 100,
          suggestions: ['ABC', 'DEF', 'GHI']
              .map(SearchFieldListItem<String>.new)
              .toList(),
        ),
      ));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      final suggestionsRenderBox =
          tester.renderObject(find.byType(ListView)) as RenderBox;
      final textFieldRenderBox =
          tester.renderObject(find.byType(TextField)) as RenderBox;
      final offset = suggestionsRenderBox.localToGlobal(Offset.zero);
      final textOffset = textFieldRenderBox.localToGlobal(Offset.zero);
      expect(textOffset, equals(Offset.zero));
      expect(offset, equals(textOffset + offset));
    });
    testWidgets('suggestions should be at custom offset',
        (WidgetTester tester) async {
      final customOffset = Offset(100, 100);
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        offset: customOffset,
        key: const Key('searchfield'),
        suggestions:
            ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
      )));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      final suggestionsRenderBox =
          tester.renderObject(find.byType(ListView)) as RenderBox;
      final textFieldRenderBox =
          tester.renderObject(find.byType(TextField)) as RenderBox;
      final offset = suggestionsRenderBox.localToGlobal(Offset.zero);
      final textOffset = textFieldRenderBox.localToGlobal(Offset.zero);
      expect(textOffset, equals(Offset.zero));
      expect(
          offset,
          equals(
            customOffset,
          ));
    });
  });
  group('Scrollbar should be visible on suggestions', () {
    testWidgets('Scrollbar should be visible by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions:
            ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(RawScrollbar), findsOneWidget);
    });
  });

  group(
      'AnimatedContainer should be render with BoxConstraints height must be include itemHeight, '
      'amount of suggestions and SuggestionDecoration EdgeInsets different cases',
      () {
    testWidgets(
        'AnimatedContainer should be render with BoxConstraints height must be include itemHeight'
        ' and amount of suggestions and without vertical padding without SuggestionDecoration EdgeInsets',
        (WidgetTester tester) async {
      const suggestions = ['ABC', 'DEF', 'GHI'];
      const double itemHeight = 40;
      final animatedContainerHeight = suggestions.length * itemHeight;
      final expectedBoxConstraintsResult = BoxConstraints(
        minHeight: animatedContainerHeight,
        maxHeight: animatedContainerHeight,
      );

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        itemHeight: itemHeight,
        key: const Key('searchfield'),
        suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      final animatedContainer = find.byType(AnimatedContainer);
      final BoxConstraints? animatedContainerConstraints =
          tester.widget<AnimatedContainer>(animatedContainer).constraints;
      expect(find.byType(ListView), findsOneWidget);
      expect(animatedContainer, findsOneWidget);
      expect(animatedContainerConstraints, expectedBoxConstraintsResult);
    });

    testWidgets(
        'AnimatedContainer should be render with BoxConstraints height must be include itemHeight'
        ' and amount of suggestions with EdgeInsets.only without left and right property',
        (WidgetTester tester) async {
      const suggestions = ['ABC', 'DEF', 'GHI'];
      const double itemHeight = 40;
      const suggestionDecorationPadding =
          EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 7);
      final animatedContainerHeight = suggestions.length * itemHeight +
          suggestionDecorationPadding.top +
          suggestionDecorationPadding.bottom;
      final expectedBoxConstraintsResult = BoxConstraints(
        minHeight: animatedContainerHeight,
        maxHeight: animatedContainerHeight,
      );

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        itemHeight: itemHeight,
        key: const Key('searchfield'),
        suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
        suggestionsDecoration: SuggestionDecoration(
          padding: suggestionDecorationPadding,
        ),
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      final animatedContainer = find.byType(AnimatedContainer);
      final BoxConstraints? animatedContainerConstraints =
          tester.widget<AnimatedContainer>(animatedContainer).constraints;
      expect(find.byType(ListView), findsOneWidget);
      expect(animatedContainer, findsOneWidget);
      expect(animatedContainerConstraints, expectedBoxConstraintsResult);
    });

    testWidgets(
        'AnimatedContainer should be render with BoxConstraints height must be include itemHeight'
        ' and amount of suggestions with EdgeInsets.only with all property but left and right should be ignored ',
        (WidgetTester tester) async {
      const suggestions = ['ABC', 'DEF', 'GHI'];
      const double itemHeight = 40;
      const suggestionDecorationPadding =
          EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 7);
      final animatedContainerHeight = suggestions.length * itemHeight +
          suggestionDecorationPadding.top +
          suggestionDecorationPadding.bottom;
      final expectedBoxConstraintsResult = BoxConstraints(
        minHeight: animatedContainerHeight,
        maxHeight: animatedContainerHeight,
      );

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        itemHeight: itemHeight,
        key: const Key('searchfield'),
        suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
        suggestionsDecoration: SuggestionDecoration(
          padding: suggestionDecorationPadding,
        ),
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      final animatedContainer = find.byType(AnimatedContainer);
      final BoxConstraints? animatedContainerConstraints =
          tester.widget<AnimatedContainer>(animatedContainer).constraints;
      expect(find.byType(ListView), findsOneWidget);
      expect(animatedContainer, findsOneWidget);
      expect(animatedContainerConstraints, expectedBoxConstraintsResult);
    });

    testWidgets(
        'AnimatedContainer should be render with BoxConstraints height must be include itemHeight'
        ' and amount of suggestions with EdgeInsets.symmetric with all property but horizontal should be ignored',
        (WidgetTester tester) async {
      const suggestions = ['ABC', 'DEF', 'GHI'];
      const double itemHeight = 40;
      const suggestionDecorationPadding =
          EdgeInsets.symmetric(vertical: 20, horizontal: 20);
      final animatedContainerHeight = suggestions.length * itemHeight +
          suggestionDecorationPadding.top +
          suggestionDecorationPadding.bottom;
      final expectedBoxConstraintsResult = BoxConstraints(
        minHeight: animatedContainerHeight,
        maxHeight: animatedContainerHeight,
      );

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        itemHeight: itemHeight,
        key: const Key('searchfield'),
        suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
        suggestionsDecoration: SuggestionDecoration(
          padding: suggestionDecorationPadding,
        ),
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      final animatedContainer = find.byType(AnimatedContainer);
      final BoxConstraints? animatedContainerConstraints =
          tester.widget<AnimatedContainer>(animatedContainer).constraints;
      expect(find.byType(ListView), findsOneWidget);
      expect(animatedContainer, findsOneWidget);
      expect(animatedContainerConstraints, expectedBoxConstraintsResult);
    });

    testWidgets(
        'AnimatedContainer should be render with BoxConstraints height must be include itemHeight'
        ' and amount of suggestions with EdgeInsets.all ',
        (WidgetTester tester) async {
      const suggestions = ['ABC', 'DEF', 'GHI'];
      const double itemHeight = 40;
      const suggestionDecorationPadding = EdgeInsets.all(20);
      final animatedContainerHeight = suggestions.length * itemHeight +
          suggestionDecorationPadding.top +
          suggestionDecorationPadding.bottom;
      final expectedBoxConstraintsResult = BoxConstraints(
        minHeight: animatedContainerHeight,
        maxHeight: animatedContainerHeight,
      );

      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        itemHeight: itemHeight,
        key: const Key('searchfield'),
        suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
        suggestionState: Suggestion.expand,
        suggestionsDecoration: SuggestionDecoration(
          padding: suggestionDecorationPadding,
        ),
      )));

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      final animatedContainer = find.byType(AnimatedContainer);
      final BoxConstraints? animatedContainerConstraints =
          tester.widget<AnimatedContainer>(animatedContainer).constraints;
      expect(find.byType(ListView), findsOneWidget);
      expect(animatedContainer, findsOneWidget);
      expect(animatedContainerConstraints, expectedBoxConstraintsResult);
    });
  });

  group('Suggestions should respect suggestionDirection', () {
    testWidgets(
        'suggestions should respect suggestionDirection: SuggestionDirection.up',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        itemHeight: 100,
        suggestionDirection: SuggestionDirection.up,
        suggestions:
            ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
      )));
      final listFinder = find.byType(ListView);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      final suggestionsRenderBox = tester.renderObject(listFinder) as RenderBox;
      final textFieldRenderBox =
          tester.renderObject(find.byType(TextField)) as RenderBox;
      final suggestionOffset = suggestionsRenderBox.localToGlobal(Offset.zero);
      final textOffset = textFieldRenderBox.localToGlobal(Offset.zero);
      expect(textOffset, equals(Offset.zero));
      expect(suggestionOffset, equals(Offset(0.0, -300.0)));
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'ABC');
      await tester.pumpAndSettle();
      expect(listFinder.evaluate().length, 1);
      final suggestionOffsetNew =
          suggestionsRenderBox.localToGlobal(Offset.zero);
      expect(suggestionOffsetNew, equals(Offset(0.0, -100.0)));
    });
  });

  testWidgets(
      'suggestions should respect suggestionDirection: SuggestionDirection.down (default)',
      (WidgetTester tester) async {
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      itemHeight: 100,
      suggestions:
          ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
    )));
    final listFinder = find.byType(ListView);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    final suggestionsRenderBox = tester.renderObject(listFinder) as RenderBox;
    final textFieldRenderBox =
        tester.renderObject(find.byType(TextField)) as RenderBox;
    final suggestionOffset = suggestionsRenderBox.localToGlobal(Offset.zero);
    final textOffset = textFieldRenderBox.localToGlobal(Offset.zero);
    final textFieldSize = textFieldRenderBox.size;
    expect(textOffset, equals(Offset.zero));
    expect(suggestionOffset, equals(Offset(0.0, textFieldSize.height)));
    await tester.tap(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), 'ABC');
    await tester.pumpAndSettle();
    expect(listFinder.evaluate().length, 1);
    final suggestionOffsetNew = suggestionsRenderBox.localToGlobal(Offset.zero);
    expect(suggestionOffsetNew, equals(Offset(0.0, textFieldSize.height)));
  });

  testWidgets('enabled parameter should allow user to use the widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      enabled: true,
      suggestions:
          ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
    )));
    final listFinder = find.byType(ListView);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
  });

  testWidgets(
      'enabled parameter set to false should not allow user to use the widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      enabled: false,
      suggestions:
          ['ABC', 'DEF', 'GHI'].map(SearchFieldListItem<String>.new).toList(),
    )));
    final listFinder = find.byType(ListView);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pumpAndSettle();
    expect(listFinder, findsNothing);
  });

  testWidgets(
      'Searchfield should not find suggestion when typed reversed for default',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
          .map(SearchFieldListItem<String>.new)
          .toList(),
      controller: controller,
      suggestionState: Suggestion.expand,
    )));
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, 'AB');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    expect(find.text('ABC'), findsOneWidget);
    expect(listFinder.evaluate().length, 1);
    await tester.enterText(textField, 'BA');
    await tester.pumpAndSettle();
    expect(listFinder, findsNothing);
  });

  testWidgets(
      'Searchfield should find suggestion when typed reversed if we add custom comparator for it',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final suggestions = ['ABC', 'DEF', 'GHI', 'JKL'];
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
      onSearchTextChanged: (query) {
        final reversed = query.split('').reversed.join();
        final filter =
            suggestions.where((element) => element.contains(reversed)).toList();
        return filter.map(SearchFieldListItem<String>.new).toList();
      },
      controller: controller,
      suggestionState: Suggestion.expand,
    )));
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, 'AB');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    expect(find.text('ABC'), findsOneWidget);
    expect(listFinder.evaluate().length, 1);
    await tester.enterText(textField, 'BA');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    expect(find.text('ABC'), findsOneWidget);
    expect(listFinder.evaluate().length, 1);
  });

  testWidgets('Searchfield should allow filtering based on custom logic',
      (tester) async {
    final suggestions = ['ABC', 'ACD', 'DEF', 'GHI', 'JKL'];
    final controller = TextEditingController();
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
      controller: controller,
      onSearchTextChanged: (query) {
        final filter = suggestions
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return filter.map(SearchFieldListItem<String>.new).toList();
      },
      suggestionState: Suggestion.expand,
    )));
    var listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await tester.tap(textField);
    await tester.enterText(textField, 'A');
    await tester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    listFinder = find.byType(ListView);
    expect(find.text('ABC'), findsOneWidget);
    expect(find.text('ACD'), findsOneWidget);
    await tester.enterText(textField, 'HI');
    await tester.pumpAndSettle();
    expect(find.text('GHI'), findsOneWidget);
  });

  testWidgets('Searchfield should set textCapitalization property',
      (WidgetTester tester) async {
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestionItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          border: Border.all(
              color: Colors.transparent, style: BorderStyle.solid, width: 1.0)),
      suggestions:
          ['ABC', 'DEF', 'def'].map(SearchFieldListItem<String>.new).toList(),
      textCapitalization: TextCapitalization.characters,
    )));
    final finder = find.byType(TextField);
    final textField = tester.firstWidget<TextField>(finder);
    expect(finder, findsOneWidget);
    expect(textField.textCapitalization, TextCapitalization.characters);
  });

  testWidgets(
      'Searchfield should set textCapitalization to none when no property assigned',
      (WidgetTester tester) async {
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestionItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          border: Border.all(
              color: Colors.transparent, style: BorderStyle.solid, width: 1.0)),
      suggestions:
          ['ABC', 'DEF', 'def'].map(SearchFieldListItem<String>.new).toList(),
    )));
    final finder = find.byType(TextField);
    final textField = tester.firstWidget<TextField>(finder);
    expect(finder, findsOneWidget);
    expect(textField.textCapitalization, TextCapitalization.none);
  });

  group('Test Searchfield autofocus', () {
    testWidgets('Searchfield should not autofocus by default (hidden keyboard)',
        (widgetTester) async {
      final focus = FocusNode();
      final boilerPlate = _boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        focusNode: focus,
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
            .toList(),
      ));
      await widgetTester.pumpWidget(boilerPlate);
      await widgetTester.pumpAndSettle();
      // keyboard should not be visible
      expect(widgetTester.testTextInput.isVisible, isFalse);
    });
    testWidgets('Searchfield autofocus should launch keyboard',
        (widgetTester) async {
      final autoFocus = true;
      final focus = FocusNode();
      final boilerPlate = _boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        autofocus: autoFocus,
        focusNode: focus,
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
            .toList(),
      ));
      await widgetTester.pumpWidget(boilerPlate);
      await widgetTester.pumpAndSettle();
      // keyboard should not be visible
      expect(widgetTester.testTextInput.isVisible, isTrue);
    });
  });

  testWidgets("Test onTapOutside", (widgetTester) async {
    bool outSideTap = false;
    await widgetTester.pumpWidget(_boilerplate(
      child: Column(
        children: [
          Center(
            child: SearchField(
              key: const Key('searchfield'),
              suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
                  .map(SearchFieldListItem<String>.new)
                  .toList(),
              onTapOutside: (x) {
                outSideTap = true;
              },
              suggestionState: Suggestion.expand,
            ),
          ),
        ],
      ),
    ));
    expect(outSideTap, false);
    //  simulate tap outside searchField
    final textField = find.byType(TextFormField);
    final position = widgetTester.getCenter(textField);
    await widgetTester.tapAt(position - const Offset(0, -100));
    await widgetTester.pumpAndSettle();
    expect(outSideTap, true);
  });

  testWidgets("SearchField should trigger onSaved", (widgetTester) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    await widgetTester.pumpWidget(_boilerplate(
      child: Form(
        key: formKey,
        child: SearchField(
          key: const Key('searchfield'),
          suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
              .map(SearchFieldListItem<String>.new)
              .toList(),
          controller: controller,
          suggestionState: Suggestion.expand,
          onSaved: (value) {
            expect(value, 'ABC');
          },
        ),
      ),
    ));
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await widgetTester.tap(textField);
    await widgetTester.enterText(textField, 'ABC');
    await widgetTester.pumpAndSettle();
    expect(formKey.currentState!.validate(), true);
    formKey.currentState!.save();
  });

  group('Scrollbar should be customizable', () {
    testWidgets('Widget should render with default scrollbar Decoration',
        (widgetTester) async {
      await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
          scrollbarDecoration: ScrollbarDecoration(),
          key: const Key('searchfield'),
          suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
              .map(SearchFieldListItem<String>.new)
              .toList(),
          suggestionState: Suggestion.expand,
        ),
      ));
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await widgetTester.tap(textField);
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(textField, 'A');
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      expect(find.text('ABC'), findsOneWidget);
      expect(listFinder.evaluate().length, 1);
    });

    testWidgets('Scrollbar should allow setting custom properties',
        (widgetTester) async {
      await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
          scrollbarDecoration: ScrollbarDecoration(
              thumbColor: Colors.blue,
              thickness: 10,
              // radius: Radius.circular(10),
              fadeDuration: Duration(seconds: 1),
              pressDuration: Duration(seconds: 1),
              minThumbLength: 10,
              trackColor: Colors.red,
              timeToFade: Duration(seconds: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              trackRadius: Radius.circular(10),
              trackBorderColor: Colors.red,
              trackVisibility: true),
          key: const Key('searchfield'),
          suggestions: [
            'ABC',
            'DEF',
            'GHI',
            'JKL',
            'MNO',
            'PQR',
            'STU',
            'VWX',
            'YZ'
          ].map(SearchFieldListItem<String>.new).toList(),
          suggestionState: Suggestion.expand,
        ),
      ));

      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await widgetTester.tap(textField);
      await widgetTester.enterText(textField, '');
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      final scrollbar = find.byType(RawScrollbar);
      expect(scrollbar, findsOneWidget);
      final scrollbarWidget = widgetTester.widget<RawScrollbar>(scrollbar);
      expect(scrollbarWidget, isNotNull);
      expect(scrollbarWidget.thumbColor, Colors.blue);
      expect(scrollbarWidget.thickness, 10);
      // expect(scrollbarWidget.radius, Radius.circular(10));
      expect(scrollbarWidget.fadeDuration, Duration(seconds: 1));
      expect(scrollbarWidget.pressDuration, Duration(seconds: 1));
      expect(scrollbarWidget.minThumbLength, 10);
      expect(scrollbarWidget.trackColor, Colors.red);
      expect(scrollbarWidget.timeToFade, Duration(seconds: 1));
      expect(scrollbarWidget.shape, isNotNull);
      expect(scrollbarWidget.trackRadius, Radius.circular(10));
      expect(scrollbarWidget.trackBorderColor, Colors.red);
      expect(scrollbarWidget.trackVisibility, true);
    });
  });
}
