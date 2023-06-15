/*
 * File: searchfield_test.dart
 * Project: None
 * File Created: Thursday, 21st April 2022 7:47:45 am
 * Author: Mahesh Jamdade
 * -----
 * Last Modified: Thursday, 21st April 2022 7:49:41 am
 * Modified By: Mahesh Jamdade
 * -----
 * Copyright 2022 - 2022 Widget Media Labs
 */

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

  group('Suggestions should respect suggestionsAlignment', () {
    testWidgets('suggestions should be aligned to left by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        itemHeight: 100,
        suggestions:
            ['ABC'].map(SearchFieldListItem<String>.new).toList(),
      )));
      final listFinder = find.byType(ListView);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      final suggestionFinder = find.byKey(Key('0-suggestion'));
      final suggestionsRenderBox = tester.renderObject(suggestionFinder) as RenderBox;
      final suggestionOffset = suggestionsRenderBox.localToGlobal(Offset.zero);
      final suggestionPredictedOffset = Offset(0.0,643.0);
      expect(suggestionOffset, equals(suggestionPredictedOffset));
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'ABC');
      await tester.pumpAndSettle();
      expect(listFinder.evaluate().length, 1);
      final suggestionOffsetNew =
          suggestionsRenderBox.localToGlobal(Offset.zero);
      expect(suggestionOffsetNew, equals(suggestionPredictedOffset));

    });
    testWidgets('suggestions should be aligned to right',
        (WidgetTester tester) async {
      await tester.pumpWidget(_boilerplate(
          child: SearchField(
        key: const Key('searchfield'),
        itemHeight: 100,
        suggestions:
            ['ABC'].map(SearchFieldListItem<String>.new).toList(),
        suggestionsAlignment: Alignment.centerRight,
      )));
      final listFinder = find.byType(ListView);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(listFinder, findsNothing);
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(listFinder, findsOneWidget);
      final suggestionFinder = find.byKey(Key('0-suggestion'));
      final suggestionsRenderBox = tester.renderObject(suggestionFinder) as RenderBox;
      final suggestionOffset = suggestionsRenderBox.localToGlobal(Offset.zero);
      expect(suggestionOffset, equals(Offset(758.0, 643.0)));
      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'ABC');
      await tester.pumpAndSettle();
      expect(listFinder.evaluate().length, 1);
      final suggestionOffsetNew =
          suggestionsRenderBox.localToGlobal(Offset.zero);
      expect(suggestionOffsetNew, equals(Offset(758.0, 643.0)));

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
}
