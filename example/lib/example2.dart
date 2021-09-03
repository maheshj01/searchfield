import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class ExampleDemo extends StatefulWidget {
  @override
  _ExampleDemoState createState() => _ExampleDemoState();
}

class _ExampleDemoState extends State<ExampleDemo> {
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
  final List<String> _statesOfIndia = [
    'Andhra Pradesh',
    'Assam',
    'Arunachal Pradesh',
    'Bihar',
    'Goa',
    'Gujarat',
    'Jammu and Kashmir',
    'Jharkhand',
    'West Bengal',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Orissa',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Tripura',
    'Uttaranchal',
    'Uttar Pradesh',
    'Haryana',
    'Himachal Pradesh',
    'Chhattisgarh'
  ];
  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestions: _suggestions,
              searchInputAction: TextInputAction.next,
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
            child: Form(
              key: _formKey,
              child: SearchField(
                suggestions: _statesOfIndia,
                hint: 'SearchField Sample 2',
                searchStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!_statesOfIndia.contains(x) || x.isEmpty) {
                    return 'Please Enter a valid State';
                  }
                  return null;
                },
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
              suggestionState: SuggestionState.enabled,
              searchInputDecoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: 'SearchField',
                border: OutlineInputBorder(),
              ),
              // hasOverlay: false,
              hint: 'SearchField Sample 4',
              maxSuggestionsInViewPort: 4,
              itemHeight: 45,
              onTap: (x) {
                print(x);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3,
                vertical: 10),
            child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState.validate();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Validate Field 2'),
                )),
          )
        ],
      ),
    );
  }
}
