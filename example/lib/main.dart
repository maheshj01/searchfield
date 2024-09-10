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
    selected = suggestions[0];
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();
  var suggestions = <String>[];
  int counter = 0;
  var selected = '';
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x, isSelected) => Padding(
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
          child: SearchField<String>(
            maxSuggestionsInViewPort: 10,
            suggestionAction: SuggestionAction.unfocus,
            searchInputDecoration: SearchInputDecoration(
              hintText: 'Search',
              cursorColor: Colors.red,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSuggestionTap: (SearchFieldListItem<String> item) {
              setState(() {
                selected = item.searchKey;
              });
            },
            suggestions: suggestions
                .map(
                  (e) => SearchFieldListItem<String>(e,
                      item: e, child: searchChild(e, e == selected)),
                )
                .toList(),
          ),
        ));
  }
}
