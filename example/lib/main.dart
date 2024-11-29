// import 'package:example/pagination.dart';
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
  @override
  void initState() {
    suggestions = [
      'United States',
      'Germany',
      'Canada',
      'United Kingdom',
      'France',
      'Italy',
      'Spain',
      'Australia',
      'India',
      'China',
      'Japan',
      'Brazil',
      'South Africa',
      'Mexico',
      'Argentina',
      'Russia',
      'Indonesia',
      'Turkey',
      'Saudi Arabia',
      'Nigeria',
      'Egypt',
    ];
    super.initState();
  }

  var suggestions = <String>[];
  var selectedValue = null;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x, {bool isSelected = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(x,
              style: TextStyle(
                  fontSize: 18,
                  color: isSelected ? Colors.green : Colors.black)),
        );
    return Scaffold(
        appBar: AppBar(title: Text('Searchfield Demo')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
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
                selectedValue: selectedValue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || !suggestions.contains(value.trim())) {
                    return 'Enter a valid country name';
                  }
                  return null;
                },
                onSubmit: (x) {},
                autofocus: false,
                key: const Key('searchfield'),
                hint: 'Search by country name',
                itemHeight: 50,
                scrollbarDecoration: ScrollbarDecoration(
                  thickness: 12,
                  radius: Radius.circular(6),
                  trackColor: Colors.grey,
                  trackBorderColor: Colors.red,
                  thumbColor: Colors.orange,
                ),
                suggestionStyle:
                    const TextStyle(fontSize: 18, color: Colors.black),
                suggestionItemDecoration: BoxDecoration(
                  // color: Colors.grey[100],
                  // borderRadius: BorderRadius.circular(10),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                searchInputDecoration: SearchInputDecoration(
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
                suggestionsDecoration: SuggestionDecoration(
                    // border: Border.all(color: Colors.orange),
                    elevation: 8.0,
                    selectionColor: Colors.grey.shade100,
                    hoverColor: Colors.purple.shade100,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xfffc466b),
                        Color.fromARGB(255, 103, 128, 255)
                      ],
                      stops: [0.25, 0.75],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )),
                suggestions: suggestions
                    .map((e) =>
                        SearchFieldListItem<String>(e, child: searchChild(e)))
                    .toList(),
                suggestionState: Suggestion.expand,
                onSuggestionTap: (SearchFieldListItem<String> x) {
                  setState(() {
                    selectedValue = x;
                  });
                },
              ),
              SizedBox(height: 20),
              SearchField(
                hint: 'Basic SearchField',
                dynamicHeight: true,
                maxSuggestionBoxHeight: 300,
                onSuggestionTap: (SearchFieldListItem<String> item) {
                  setState(() {
                    selectedValue = item;
                  });
                },
                selectedValue: selectedValue,
                suggestions:
                    suggestions.map(SearchFieldListItem<String>.new).toList(),
                suggestionState: Suggestion.expand,
              ),
            ],
          ),
        ));
  }
}
