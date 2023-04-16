import 'package:example/country_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DynamicSample extends StatefulWidget {
  const DynamicSample({Key? key}) : super(key: key);

  @override
  State<DynamicSample> createState() => _DynamicSampleState();
}

class _DynamicSampleState extends State<DynamicSample> {
  List<String> suggestions =
      // random suggestions
      [
    'United States',
    'Germany',
    'Washington',
    'Paris',
    'Jakarta',
    'Australia',
    'India',
    'Czech Republic',
    'Lorem Ipsum',
  ];
  int suggestionsCount = 2;
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final countries = data.map((e) => Country.fromMap(e)).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Dynamic sample Demo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              suggestionsCount++;
              suggestions.add('suggestion $suggestionsCount');
            });
          },
          child: Icon(Icons.add),
        ),
        body: SearchField(
          key: const Key('searchfield'),
          suggestions: countries
              .map((e) => SearchFieldListItem<Country>(e.name))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<Country> x) {
            focus.unfocus();
          },
        ));
  }
}
