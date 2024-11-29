import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  selectedValue: SearchFieldListItem<String>('ABCD'))),
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
        selectedValue: SearchFieldListItem<String>('ABC'),
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

    testWidgets('searchfield should show tapped suggestion',
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
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      final tapTarget = find.text('ABC');
      await tester.ensureVisible(tapTarget);
      expect(tapTarget, findsOneWidget);
      await tester.tap(tapTarget);
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.text('ABC'), findsOneWidget);
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

  // testWidgets('onSubmit should not set value in input on empty results',
  //     (WidgetTester tester) async {
  //   final controller = TextEditingController();
  //   final emptyWidget = const Text('No results');
  //   await tester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
  //         .map(SearchFieldListItem<String>.new)
  //         .toList(),
  //     emptyWidget: emptyWidget,
  //     controller: controller,
  //     suggestionState: Suggestion.expand,
  //   )));
  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await tester.tap(textField);
  //   await tester.enterText(textField, 'not present');
  //   await tester.pumpAndSettle();
  //   expect(find.text('No results'), findsOneWidget);
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.pumpAndSettle();
  //   expect(controller.text, 'not present');
  // });
  // testWidgets('Searchfield should invoke onSuggestionTap',
  //     (widgetTester) async {
  //   final controller = TextEditingController();
  //   final suggestions = ['ABC', 'DEF', 'GHI', 'JKL']
  //       .map(SearchFieldListItem<String>.new)
  //       .toList();
  //   int count = 0;
  //   String? tappedSuggestion;
  //   await widgetTester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions: suggestions,
  //     controller: controller,
  //     onSuggestionTap: (suggestion) {
  //       tappedSuggestion = suggestion.searchKey;
  //     },
  //     suggestionState: Suggestion.expand,
  //   )));
  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await widgetTester.tap(textField);
  //   await widgetTester.enterText(textField, 'A');
  //   await widgetTester.pumpAndSettle();
  //   expect(listFinder, findsOneWidget);
  //   final tapTarget = find.text('ABC');
  //   await widgetTester.ensureVisible(tapTarget);
  //   expect(tapTarget, findsOneWidget);
  //   await widgetTester.tap(tapTarget);
  // await widgetTester.pumpAndSettle(Duration(seconds: 2));
  // expect(count, 1);
  //   expect(tappedSuggestion, 'ABC');
  // });

  testWidgets('searchfield should respect showEmpty parameter',
      (widgetTester) async {
    final controller = TextEditingController();
    final suggestions = ['ABC', 'DEF', 'GHI', 'JKL']
        .map(SearchFieldListItem<String>.new)
        .toList();
    final emptyWidget = const Text('No results');
    bool showEmpty = false;
    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: suggestions,
      controller: controller,
      showEmpty: showEmpty,
      emptyWidget: emptyWidget,
      suggestionState: Suggestion.expand,
    )));

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await widgetTester.tap(textField);
    await widgetTester.enterText(textField, 'A');
    await widgetTester.pumpAndSettle();
    expect(find.text('ABC'), findsOneWidget);
    expect(find.text('No results'), findsNothing);
    showEmpty = true;
    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: suggestions,
      controller: controller,
      showEmpty: showEmpty,
      emptyWidget: emptyWidget,
      suggestionState: Suggestion.expand,
    )));

    await widgetTester.enterText(textField, 'text not in list');
    await widgetTester.pumpAndSettle();
    expect(find.text('No results'), findsOneWidget);
  });

  testWidgets(
      'Searchfield Suggestions should default height should be less than 175 when suggestions count < 5',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final kdefaultLengthInViewPort = 5;
    final kdefaultHeight = 51;
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
      'Searchfield Suggestions default height should not exceed 255 (51*5) when suggestions count > 5)',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final kdefaultLengthInViewPort = 5;
    final kdefaultHeight = 51;
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

  testWidgets(
      'SearchField should show generic type search key in searchfield on suggestionTap)',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final countries = data.map(Country.fromMap).toList();
    await tester.pumpWidget(_boilerplate(
        child: SearchField(
      key: const Key('searchfield'),
      suggestions: countries
          .map((e) => SearchFieldListItem<Country>(e.name, key: Key(e.name)))
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
    final tapTarget = find.byKey(Key(countries[0].name));
    expect(tapTarget, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(find.text(countries[0].name), findsOneWidget);
  });

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
    await tester.tap(textField);
    await tester.enterText(textField, '');
    await tester.pumpAndSettle();
    expect(listView, findsWidgets);
    expect(find.text('suggestion $counter'), findsOneWidget);
  });

  testWidgets('Searchfield suggestions should respect width',
      (widgetTester) async {
    final controller = TextEditingController();
    final countries = data.map(Country.fromMap).toList();
    final width = 200.0;
    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
      controller: controller,
      suggestions:
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
      suggestionState: Suggestion.expand,
      suggestionsDecoration: SuggestionDecoration(
        width: width,
      ),
    )));

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await widgetTester.tap(textField);
    await widgetTester.pumpAndSettle();
    final positioned = find.byType(Positioned);
    expect(positioned, findsOneWidget);
    final positionedRenderBox =
        widgetTester.renderObject(positioned) as RenderBox;
    expect(positionedRenderBox.size.width, equals(width));
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
      'Searchfield should find suggestion when typed reversed if we add custom search logic',
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
      searchInputDecoration: SearchInputDecoration(
        textCapitalization: TextCapitalization.characters,
      ),
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

  group('Test Searchfield focus', () {
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

    testWidgets('Searchfield should respect FocusNode',
        (WidgetTester tester) async {
      final focus = FocusNode();
      final boilerPlate = _boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        focusNode: focus,
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
            .toList(),
      ));
      await tester.pumpWidget(boilerPlate);
      await tester.pumpAndSettle();
      // keyboard should not be visible
      expect(tester.testTextInput.isVisible, isFalse);
      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isTrue);

      focus.unfocus();
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isFalse);

      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isTrue);

      focus.unfocus();
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isFalse);
    });
  });

  group('Searchfield should respect Suggestion Action', () {
    testWidgets(
        'Searcfield should loose focus when suggestion is selected by default',
        (WidgetTester tester) async {
      final inputFocus = FocusNode();
      final searchFocus = FocusNode();
      SearchFieldListItem<String>? selectedValue = null;
      final boilerPlate = _boilerplate(
          child: Column(
        children: [
          SearchField(
            focusNode: searchFocus, 
            key: const Key('searchfield'),
            suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
                .map(SearchFieldListItem<String>.new)
                .toList(),
            selectedValue: selectedValue,
            onSuggestionTap: (SearchFieldListItem<String> x) {
              selectedValue = x;
            },
          ),
          TextField(
            focusNode: inputFocus,
          )
        ],
      ));
      await tester.pumpWidget(boilerPlate);
      await tester.pumpAndSettle();
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      // tap 2nd item
      final secondItem = find.text('DEF').first;
      expect(secondItem, findsOneWidget);
      await tester.tap(secondItem);
      await tester.pumpAndSettle();
      expect(selectedValue!.searchKey, equals('DEF'));

      // check if focus is switched to next field
      expect(inputFocus.hasFocus, isFalse);
      expect(searchFocus.hasFocus, isFalse);
      // show suggestions
    });
    testWidgets(
        'SuggestionAction.next should move focus to next field on selection',
        (WidgetTester tester) async {
      final inputFocus = FocusNode();
      final searchFocus = FocusNode();
      SearchFieldListItem<String>? selectedValue = null;
      final boilerPlate = _boilerplate(
          child: Column(
        children: [
          SearchField(
            focusNode: searchFocus, 
            suggestionAction: SuggestionAction.next,
            key: const Key('searchfield'),
            suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
                .map(SearchFieldListItem<String>.new)
                .toList(),
            selectedValue: selectedValue,
            onSuggestionTap: (SearchFieldListItem<String> x) {
              selectedValue = x;
            },
          ),
          TextField(
            focusNode: inputFocus,
          )
        ],
      ));
      await tester.pumpWidget(boilerPlate);
      await tester.pumpAndSettle();
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(textField);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      // tap 2nd item
      final secondItem = find.text('DEF').first;
      expect(secondItem, findsOneWidget);
      await tester.tap(secondItem);
      await tester.pumpAndSettle();
      expect(selectedValue!.searchKey, equals('DEF'));

      // check if focus is switched to next field
      expect(inputFocus.hasFocus, isTrue);
      expect(searchFocus.hasFocus, isFalse);
    });

    testWidgets('Tap Outside should remove focus by default',
        (WidgetTester tester) async {
      var outSideTap = false;
      final focus = FocusNode();
      final boilerPlate = _boilerplate(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: SearchField(
              focusNode: focus,
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
      ));
      await tester.pumpWidget(boilerPlate);
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(textField);
      expect(focus.hasFocus, isTrue);
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
      expect(outSideTap, true);
      expect(focus.hasFocus, isFalse);
    });
  });

  testWidgets("Test onTapOutside", (widgetTester) async {
    bool outSideTap = false;
    await widgetTester.pumpWidget(_boilerplate(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
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
    final listFinder = find.byType(ListView);
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    expect(listFinder, findsNothing);
    await widgetTester.tap(textField);
    await widgetTester.enterText(textField, '');
    await widgetTester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    await widgetTester.tapAt(Offset.zero);
    // await gesture.up();
    await widgetTester.pumpAndSettle();
    expect(outSideTap, true);
  });

  testWidgets('Searchfield should respect textAlign', (widgetTester) async {
    await widgetTester.pumpWidget(_boilerplate(
      child: SearchField(
        key: const Key('searchfield'),
        suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
            .map(SearchFieldListItem<String>.new)
            .toList(),
        textAlign: TextAlign.center,
      ),
    ));
    final finder = find.byType(TextField);
    final textField = widgetTester.firstWidget<TextField>(finder);
    expect(finder, findsOneWidget);
    expect(textField.textAlign, TextAlign.center);
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

  group('Searchfield should accept key events', () {
    testWidgets('pressing esc key should hide the suggestions',
        (widgetTester) async {
      final controller = TextEditingController();
      final countries = data.map(Country.fromMap).toList();
      final suggestions =
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList();
      await widgetTester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: suggestions,
        controller: controller,
        suggestionState: Suggestion.expand,
      )));
      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await widgetTester.tap(textField);
      await widgetTester.enterText(textField, '');
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsNothing);
      await simulateKeyDownEvent(LogicalKeyboardKey.escape);
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsNothing);
    });

    testWidgets('First option should always be selected on Search',
        (widgetTester) async {
      final controller = TextEditingController();
      final countries = data.map(Country.fromMap).toList();
      final suggestions =
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList();
      await widgetTester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: suggestions,
        controller: controller,
        suggestionState: Suggestion.expand,
      )));

      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await widgetTester.tap(textField);
      await widgetTester.enterText(textField, '');
      await widgetTester.pumpAndSettle();
      // execute search for `ang`
      final String query = 'ang';
      final searchResult = <SearchFieldListItem<Country>>[];
      await widgetTester.enterText(textField, query);
      await widgetTester.pumpAndSettle();
      for (final suggestion in suggestions) {
        if (suggestion.searchKey.toLowerCase().contains(query.toLowerCase())) {
          searchResult.add(suggestion);
        }
      }
      await simulateKeyDownEvent(LogicalKeyboardKey.enter);
      await widgetTester.pumpAndSettle();
      expect(searchResult[0].searchKey, 'Angola');
    });

    testWidgets(
        'pressing enter should input the selected suggestion in the searchfield',
        (widgetTester) async {
      final controller = TextEditingController();
      final countries = data.map(Country.fromMap).toList();
      final suggestions =
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList();
      await widgetTester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        suggestions: suggestions,
        controller: controller,
        suggestionState: Suggestion.expand,
      )));

      final listFinder = find.byType(ListView);
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(listFinder, findsNothing);
      await widgetTester.tap(textField);
      await widgetTester.enterText(textField, '');
      await widgetTester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyUpEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyUpEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyUpEvent(LogicalKeyboardKey.arrowDown);
      await simulateKeyDownEvent(LogicalKeyboardKey.enter);
      await simulateKeyUpEvent(LogicalKeyboardKey.enter);
      await widgetTester.pumpAndSettle();
      expect(find.text(countries[2].name), findsOneWidget);
    });
  });

  testWidgets('scrollbar should be scrollable', (widgetTester) async {
    await widgetTester.pumpWidget(_boilerplate(
      child: SearchField(
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
    await widgetTester.enterText(textField, '');
    await widgetTester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    final scrollbar = find.byType(RawScrollbar);
    expect(scrollbar, findsOneWidget);
    final scrollbarWidget = widgetTester.widget<RawScrollbar>(scrollbar);
    expect(scrollbarWidget, isNotNull);
    await widgetTester.drag(scrollbar, const Offset(0, 100.0));
    await widgetTester.pumpAndSettle();
    expect(listFinder, findsOneWidget);
    //
    // expect(scrollbarWidget.controller!.offset, 100.0);
  });

  testWidgets('Searchfield should limit the character count',
      (widgetTester) async {
    final controller = TextEditingController();
    final countries = data.map(Country.fromMap).toList();
    final maxLength = 3;
    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField(
      controller: controller,
      suggestions:
          countries.map((e) => SearchFieldListItem<Country>(e.name)).toList(),
      suggestionState: Suggestion.expand,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    )));

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await widgetTester.tap(textField);
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(textField, 'abc');
    expect(find.text('abc'), findsOneWidget);
    expect(find.text('abcd'), findsNothing);
  });

  // testWidgets(
  //     'Selecting suggestion with keyboard should return the searchKey in `onSuggestionTapped`',
  //     (widgetTester) async {
  //   final controller = TextEditingController();
  //   final countries = data.map(Country.fromMap).toList();
  //   final suggestions =
  //       countries.map((e) => SearchFieldListItem<Country>(e.name)).toList();
  //   String? searchKey;
  //   await widgetTester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions: suggestions,
  //     controller: controller,
  //     suggestionState: Suggestion.expand,
  //     onSuggestionTap: (tapped) {
  //       print(tapped.searchKey);
  //       searchKey = tapped.searchKey;
  //     },
  //   )));

  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await widgetTester.tap(textField);
  //   await widgetTester.enterText(textField, '');
  //   await widgetTester.pumpAndSettle();
  //   expect(listFinder, findsOneWidget);
  //   await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
  //   await simulateKeyDownEvent(LogicalKeyboardKey.enter);
  //   await widgetTester.pumpAndSettle();
  //   expect(searchKey, countries[0]);
  // });

  // testWidgets('searched suggestions can be selected by pressing enter',
  //     (widgetTester) async {
  //   final controller = TextEditingController();
  //   final suggestions = ['ABC', 'DEF', 'GHI', 'JKL']
  //       .map(SearchFieldListItem<String>.new)
  //       .toList();
  //   await widgetTester.pumpWidget(_boilerplate(
  //       child: SearchField(
  //     key: const Key('searchfield'),
  //     suggestions: suggestions,
  //     controller: controller,
  //     suggestionState: Suggestion.expand,
  //   )));
  //   final listFinder = find.byType(ListView);
  //   final textField = find.byType(TextFormField);
  //   expect(textField, findsOneWidget);
  //   expect(listFinder, findsNothing);
  //   await widgetTester.tap(textField);
  //   expect(find.text('DEF'), findsNothing);
  //   await widgetTester.enterText(textField, 'd');
  //   await widgetTester.pumpAndSettle();
  //   expect(listFinder, findsOneWidget);
  //   await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
  //   await simulateKeyDownEvent(LogicalKeyboardKey.enter);
  //   await widgetTester.pumpAndSettle();
  //   final target = find.text('DEF');
  //   expect(target, findsOneWidget);
  //   final target2 = find.text('GHI');
  //   expect(target2, findsNothing);
  // });

// Drag is always 0 looks related to https://github.com/flutter/flutter/issues/100758
//   testWidgets('Fire onScroll when suggestions are scrolled',
//       (widgetTester) async {
//     final suggestions = List.generate(500, (index) => index.toString())
//         .map((e) => SearchFieldListItem<String>(e))
//         .toList();

//     double scrollOffset = 0.0;
//     await widgetTester.pumpWidget(_boilerplate(
//         child: SearchField(
//       key: const Key('searchfield'),
//       suggestions: suggestions,
//       suggestionState: Suggestion.expand,
//       onScroll: (offset, maxOffset) {
//         print(offset);
//         scrollOffset = offset;
//       },
//     )));

//     final listFinder = find.byType(ListView);
//     final textField = find.byType(TextFormField);
//     expect(textField, findsOneWidget);
//     expect(listFinder, findsNothing);
//     await widgetTester.tap(textField);
//     await widgetTester.enterText(textField, '');
//     await widgetTester.pumpAndSettle();
//     expect(listFinder, findsOneWidget);
//     await widgetTester.drag(listFinder, const Offset(0, -100));
//     await widgetTester.pumpAndSettle(Duration(seconds: 1));
//     expect(scrollOffset, 100.0);
//   });

  testWidgets('Searchfield properties can be set', (widgetTester) async {
    final suggestions = List.generate(100, (index) => index.toString())
        .map(SearchFieldListItem<String>.new)
        .toList();

    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField<String>(
      key: const Key('searchfield'),
      contextMenuBuilder: (context, suggestion) {
        return PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Copy'),
              ),
              PopupMenuItem(
                child: Text('Paste'),
              ),
            ];
          },
        );
      },
      suggestions: suggestions,
      animationDuration: Duration(seconds: 1),
      autovalidateMode: AutovalidateMode.always,
      readOnly: false,
      suggestionState: Suggestion.expand,
      autoCorrect: false,
      autofocus: true,
      dynamicHeight: true,
      selectedValue: SearchFieldListItem<String>('0'),
      emptyWidget: Text("Empty"),
      marginColor: Colors.red,
      textInputAction: TextInputAction.done,
      onSearchTextChanged: (query) {
        return suggestions
            .where((element) => element.searchKey.contains(query))
            .toList();
      },
      offset: Offset(50, 51),
      onSuggestionTap: (tapped) {
        print(tapped.searchKey);
      },
      inputType: TextInputType.text,
      hint: 'Search',
      itemHeight: 51,
      maxSuggestionBoxHeight: 100,
      showEmpty: false,
      textAlign: TextAlign.center,
      suggestionStyle: TextStyle(color: Colors.red),
      suggestionDirection: SuggestionDirection.up,
    )));

    await widgetTester.pumpAndSettle(const Duration(seconds: 5));
    final searchFieldFinder = find.byKey(const Key('searchfield'));

    expect(searchFieldFinder, findsOneWidget);

    // Find the TextField within SearchField
    final textFieldFinder = find.descendant(
      of: searchFieldFinder,
      matching: find.byType(TextField),
    );
    expect(textFieldFinder, findsOneWidget);

    final TextField textField = widgetTester.widget<TextField>(textFieldFinder);

    final SearchField<String> searchField =
        widgetTester.widget<SearchField<String>>(searchFieldFinder);

    expect(textField.autofocus, searchField.autofocus);
    expect(searchField.autovalidateMode, AutovalidateMode.always);
    expect(searchField.animationDuration, Duration(seconds: 1));
    expect(searchField.autoCorrect, false);
    expect(searchField.dynamicHeight, true);
    expect(searchField.selectedValue, SearchFieldListItem<String>('0'));
    expect(searchField.emptyWidget, isA<Text>());
    expect(searchField.marginColor, Colors.red);
    expect(searchField.textInputAction, TextInputAction.done);
    expect(searchField.offset, Offset(50, 51));
    expect(searchField.inputType, TextInputType.text);
    expect(searchField.hint, 'Search');
    expect(searchField.itemHeight, 51);
    expect(searchField.maxSuggestionBoxHeight, 100);
    expect(searchField.showEmpty, false);
    expect(searchField.textAlign, TextAlign.center);
    expect(searchField.suggestionStyle, isA<TextStyle>());
    expect(searchField.suggestionStyle!.color, Colors.red);
    expect(searchField.suggestionDirection, SuggestionDirection.up);
    expect(searchField.contextMenuBuilder, isNotNull);
  });

  testWidgets('SearchInputdecoration values can be set', (widgetTester) async {
    final suggestions = List.generate(500, (index) => index.toString())
        .map(SearchFieldListItem<String>.new)
        .toList();

    final searchInputDecoration = SearchInputDecoration(
      hintText: 'Search',
      labelText: 'Search',
      errorText: 'Error',
      helperText: 'Helper',
      prefixText: 'Prefix',
      suffixText: 'Suffix',
      counterText: 'Counter',
      iconColor: Colors.red,
      cursorColor: Colors.red,
      suffixIconColor: Colors.red,
      prefixIconColor: Colors.red,
      errorStyle: TextStyle(color: Colors.red),
      labelStyle: TextStyle(color: Colors.red),
      helperStyle: TextStyle(color: Colors.red),
      counterStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(color: Colors.red),
      prefixStyle: TextStyle(color: Colors.red),
      suffixStyle: TextStyle(color: Colors.red),
      icon: Icon(Icons.search),
      searchStyle: TextStyle(color: Colors.red),
      // prefixIcon: Icon(Icons.search),
      // suffixIcon: Icon(Icons.close),
      // label: Text('Label'),
      // error: Text('Error'),
      // helper: Text('Helper'),
      // prefix: Container(),
      // counter: Container(),
      // suffix: Container(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.all(10),
      // errorMaxLines: 2,
      // helperMaxLines: 2,
      // hintMaxLines: 2,
      fillColor: Colors.red,
      filled: true,
      focusColor: Colors.red,
      hoverColor: Colors.red,
      alignLabelWithHint: true,
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 100,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      isCollapsed: true,
      isDense: true,
      cursorWidth: 2,
      cursorHeight: 2,
      cursorRadius: Radius.circular(10),
      cursorOpacityAnimates: true,
      cursorErrorColor: Colors.red,
      textCapitalization: TextCapitalization.characters,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelStyle: TextStyle(color: Colors.red),
      hintFadeDuration: Duration(seconds: 1),
      // hintTextDirection: TextDirection.ltr,
      keyboardAppearance: Brightness.dark,
      prefixIconConstraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 100,
      ),
      suffixIconConstraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 100,
      ),
      semanticCounterText: 'Counter',
    );

    await widgetTester.pumpWidget(_boilerplate(
        child: SearchField<String>(
      key: const Key('searchfield'),
      suggestions: suggestions,
      searchInputDecoration: searchInputDecoration,
      suggestionState: Suggestion.expand,
    )));

    // Find the SearchField widget
    final searchFieldFinder = find.byKey(const Key('searchfield'));
    expect(searchFieldFinder, findsOneWidget);

    // Find the TextField within SearchField
    final textFieldFinder = find.descendant(
      of: searchFieldFinder,
      matching: find.byType(TextField),
    );
    expect(textFieldFinder, findsOneWidget);

    // Get the InputDecoration from the TextField
    final TextField textField = widgetTester.widget<TextField>(textFieldFinder);
    final InputDecoration? decoration = textField.decoration;

    // Verify InputDecoration properties
    expect(decoration, isNotNull);
    // expect(decoration!.hintText, 'Search');
    // expect(decoration.labelText, 'Search');
    // expect(decoration!.prefixIcon, isA<Icon>());
    // expect(decoration.suffixIcon, isA<Icon>());
    // expect(decoration.counter, isA<Container>());
    // expect(decoration.errorMaxLines, 2);
    expect(decoration!.border, isA<OutlineInputBorder>());
    expect(decoration.focusedBorder, isA<OutlineInputBorder>());
    expect(decoration.enabledBorder, isA<OutlineInputBorder>());
    expect(decoration.errorBorder, isA<OutlineInputBorder>());
    expect(decoration.focusedErrorBorder, isA<OutlineInputBorder>());
    expect(decoration.disabledBorder, isA<OutlineInputBorder>());
    expect(decoration.contentPadding, EdgeInsets.all(10));
    expect(decoration.counterText, 'Counter');
    expect(decoration.counterStyle, isA<TextStyle>());
    expect(decoration.counterStyle!.color, Colors.red);
    expect(decoration.errorStyle, isA<TextStyle>());
    expect(decoration.errorStyle!.color, Colors.red);
    expect(decoration.fillColor, Colors.red);
    expect(decoration.filled, true);
    expect(decoration.focusColor, Colors.red);
    expect(decoration.hoverColor, Colors.red);
    expect(decoration.labelStyle, isA<TextStyle>());
    expect(decoration.labelStyle!.color, Colors.red);
    expect(decoration.alignLabelWithHint, true);
    expect(decoration.constraints, isA<BoxConstraints>());
    expect(decoration.constraints!.minHeight,
        searchInputDecoration.constraints!.minHeight);
    expect(decoration.constraints!.maxHeight,
        searchInputDecoration.constraints!.minHeight);
    expect(decoration.floatingLabelBehavior,
        searchInputDecoration.floatingLabelBehavior);
    expect(decoration.isCollapsed, searchInputDecoration.isCollapsed);
    expect(decoration.isDense, searchInputDecoration.isDense);
    // expect(decoration.prefix, isA<Container>());
    // expect(decoration.suffix, isA<Container>());
    expect(textField.cursorColor, searchInputDecoration.cursorColor);
    expect(textField.cursorWidth, searchInputDecoration.cursorWidth);
    expect(textField.cursorHeight, searchInputDecoration.cursorHeight);
    expect(textField.cursorRadius, searchInputDecoration.cursorRadius);
    expect(textField.cursorOpacityAnimates,
        searchInputDecoration.cursorOpacityAnimates);
    expect(textField.cursorErrorColor, searchInputDecoration.cursorErrorColor);

    // You can add more specific tests for border radius if needed
    final OutlineInputBorder border = decoration.border as OutlineInputBorder;
    expect(border.borderRadius, BorderRadius.circular(10));
  });
}
