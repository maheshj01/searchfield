import 'package:example/demo.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: DemoApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchFieldSample extends StatefulWidget {
  const SearchFieldSample({Key? key}) : super(key: key);

  @override
  State<SearchFieldSample> createState() => _SearchFieldSampleState();
}

class _SearchFieldSampleState extends State<SearchFieldSample> {
  int suggestionsCount = 12;
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final suggestions =
        List.generate(suggestionsCount, (index) => 'suggestion $index');
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
        body: Center(
          child: SearchField(
            onSearchTextChanged: (query) {
              final filter = suggestions
                  .where((element) =>
                      element.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              return filter
                  .map((e) => SearchFieldListItem<String>(e,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(e,
                            style: TextStyle(fontSize: 24, color: Colors.red)),
                      )))
                  .toList();
            },
            key: const Key('searchfield'),
            hint: 'Search by country name',
            itemHeight: 50,
            suggestionsDecoration: SuggestionDecoration(
                padding: const EdgeInsets.all(4),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            suggestions: suggestions
                .map((e) => SearchFieldListItem<String>(e,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(e,
                          style: TextStyle(fontSize: 24, color: Colors.red)),
                    )))
                .toList(),
            focusNode: focus,
            suggestionState: Suggestion.expand,
            onSuggestionTap: (SearchFieldListItem<String> x) {
              focus.unfocus();
            },
          ),
        ));
  }
}
