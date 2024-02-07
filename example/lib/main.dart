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
      home: SearchFieldSample(),
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
  void initState() {
    suggestions = [
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
    super.initState();
  }

  var suggestions = <String>[];
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: TextStyle(fontSize: 24, color: Colors.white)),
        );
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextFormField(
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     decoration: InputDecoration(
              //       labelText: 'Flutter TextFormField',
              //     ),
              //     validator: (value) {
              //       if (value == null || value.length < 4) {
              //         return 'error';
              //       }
              //       return null;
              //     }),
              // SizedBox(
              //   height: 50,
              // ),
              // NetworkSample(),
              SizedBox(
                height: 50,
              ),
              SearchField(
                suggestionDirection: SuggestionDirection.flex,
                onSearchTextChanged: (query) {
                  final filter = suggestions
                      .where((element) =>
                          element.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                  return filter
                      .map((e) =>
                          SearchFieldListItem<String>(e, child: searchChild(e)))
                      .toList();
                },
                onTap: () {},
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || !suggestions.contains(value.trim())) {
                    return 'Enter a valid country name';
                  }
                  return null;
                },
                key: const Key('searchfield'),
                hint: 'Search by country name',
                itemHeight: 50,
                scrollbarDecoration: ScrollbarDecoration(),
                //   thumbVisibility: true,
                //   thumbColor: Colors.red,
                //   fadeDuration: const Duration(milliseconds: 3000),
                //   trackColor: Colors.blue,
                //   trackRadius: const Radius.circular(10),
                // ),
                onTapOutside: (x) {
                  focus.unfocus();
                },
                suggestionStyle:
                    const TextStyle(fontSize: 18, color: Colors.white),
                searchStyle: TextStyle(fontSize: 18, color: Colors.black),
                searchInputDecoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.orange,
                      style: BorderStyle.solid,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
                suggestionsDecoration: SuggestionDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(24),
                ),
                suggestions: suggestions
                    .map((e) =>
                        SearchFieldListItem<String>(e, child: searchChild(e)))
                    .toList(),
                focusNode: focus,
                suggestionState: Suggestion.expand,
                onSuggestionTap: (SearchFieldListItem<String> x) {
                  focus.unfocus();
                },
              ),
            ],
          ),
        ));
  }
}
