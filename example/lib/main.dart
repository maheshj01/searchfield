import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter SearchField Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _suggestions = [
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

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                suggestions: _suggestions,
                controller: _searchController,
                hint: 'SearchField Sample 1',
                initialValue: _suggestions[2],
                maxSuggestionsInViewPort: 3,
                itemHeight: 45,
                onTap: (x) {
                  print('selected =$x ${_searchController.text}');
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                suggestions: _suggestions,
                hint: 'SearchField Sample 2',
                searchStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
                searchInputDecoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                maxSuggestionsInViewPort: 6,
                itemHeight: 50,
                onTap: (x) {
                  print(x);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                maxSuggestionsInViewPort: 5,
                itemHeight: 40,
                hint: 'SearchField Sample 3',
                suggestionsDecoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                suggestionItemDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff9D50BB).withOpacity(0.5),
                      Color(0xff6E48AA).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                searchInputDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  border: OutlineInputBorder(),
                ),
                marginColor: Colors.white,
                suggestions: _suggestions,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                suggestionStyle: TextStyle(color: Colors.green),
                suggestionItemDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  gradient: LinearGradient(colors: [
                    Color(0xff70e1f5),
                    Color(0xffffd194),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                suggestions: _suggestions,
                searchInputDecoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'SearchField',
                  border: OutlineInputBorder(),
                ),
                hint: 'SearchField Sample 4',
                maxSuggestionsInViewPort: 4,
                itemHeight: 45,
                onTap: (x) {
                  print(x);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
