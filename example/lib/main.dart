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
    selectedValue = SearchFieldListItem<String>(
      'United States',
      item: 'United States',
    );
    super.initState();
  }

  var suggestions = <String>[];
  late SearchFieldListItem<String> selectedValue;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x, {bool isSelected = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(x,
              style: TextStyle(
                  fontSize: 18, color: isSelected ? Colors.green : null)),
        );
    return Scaffold(
        appBar: AppBar(title: Text('Searchfield Demo')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              SearchField(
                hint: 'Basic SearchField',
                keepSearchOnSelection: true,
                // dynamicHeight: true,
                maxSuggestionBoxHeight: 300,
                onSuggestionTap: (SearchFieldListItem<String> item) {
                  setState(() {
                    selectedValue = item;
                  });
                },
                selectedValue: selectedValue,
                suggestions: suggestions.map(
                  (x) {
                    final t = SearchFieldListItem<String>(
                      x,
                      item: x,
                      child: searchChild(x,
                          isSelected: selectedValue.searchKey == x),
                    );

                    return t;
                  },
                ).toList(),
                suggestionState: Suggestion.expand,
              ),
            ],
          ),
        ));
  }
}
