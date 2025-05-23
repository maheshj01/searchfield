import 'package:example/UserSelect.dart';
import 'package:example/network_sample.dart';
import 'package:example/pagination.dart';
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

  final TextEditingController searchController = TextEditingController();
  var suggestions = <String>[];
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: TextStyle(fontSize: 18, color: Colors.black)),
        );
    return Scaffold(
        appBar: AppBar(title: Text('Searchfield Demo')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              suggestionsCount++;
              counter++;
              suggestions.add('suggestion $suggestionsCount');
            });
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              UserSelect(),
              SizedBox(
                height: 550,
              ),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Flutter TextFormField',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'error';
                    }
                    return null;
                  }),
              SizedBox(
                height: 50,
              ),
              UserSelect(),
              SizedBox(
                height: 50,
              ),
              SearchField(
                hint: 'Basic SearchField',
                suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
                    .map(SearchFieldListItem<String>.new)
                    .toList(),
                suggestionState: Suggestion.expand,
              ),
              SizedBox(
                height: 50,
              ),
              Pagination(),
              SizedBox(
                height: 50,
              ),
              NetworkSample(),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 50,
              ),
              SearchField(
                enabled: false,
                hint: 'Disabled SearchField',
                suggestions: ['ABC', 'DEF', 'GHI', 'JKL']
                    .map(SearchFieldListItem<String>.new)
                    .toList(),
                suggestionState: Suggestion.expand,
              ),
              SizedBox(
                height: 50,
              ),
              // NetworkSample(),
              Text(
                'Counter: $counter',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ));
  }
}

class City {
  String name;
  String zip;
  City(this.name, this.zip);
}
