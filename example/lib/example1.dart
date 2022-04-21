import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Example1 extends StatefulWidget {
  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
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
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestionState: Suggestion.expand,
              suggestionAction: SuggestionAction.next,
              suggestions:
                  _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              textInputAction: TextInputAction.next,
              controller: _searchController,
              hint: 'SearchField Example 1',
              // initialValue: SearchFieldListItem(_suggestions[2], SizedBox()),
              maxSuggestionsInViewPort: 3,
              itemHeight: 45,
              onSuggestionTap: (x) {},
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
                suggestions:
                    _statesOfIndia.map((e) => SearchFieldListItem(e)).toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'SearchField Example 2',
                hasOverlay: false,
                searchStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!_statesOfIndia.contains(x) || x!.isEmpty) {
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
                onSuggestionTap: (x) {},
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
              hint: 'SearchField Example 3',
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
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: Colors.transparent,
                      style: BorderStyle.solid,
                      width: 1.0)),
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
              marginColor: Colors.grey.shade300,
              suggestions: _suggestions
                  .map((e) => SearchFieldListItem(e, child: e.toTitle()))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestionItemDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                gradient: LinearGradient(colors: [
                  Color(0xff70e1f5),
                  Color(0xffffd194),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              suggestions:
                  _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              suggestionState: Suggestion.hidden,
              searchInputDecoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: 'SearchField',
                border: OutlineInputBorder(),
              ),
              // hasOverlay: false,
              hint: 'SearchField example 4',
              maxSuggestionsInViewPort: 4,
              itemHeight: 45,
              onSuggestionTap: (x) {},
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3,
                vertical: 10),
            child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
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

extension FurdleTitle on String {
  Widget toTitle({double boxSize = 25}) {
    return Material(
      color: Colors.transparent,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (int i = 0; i < length; i++)
          Container(
              height: boxSize,
              width: boxSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ) +
                  EdgeInsets.only(bottom: i.isOdd ? 8 : 0),
              child: Text(
                this[i].toUpperCase(),
                style: const TextStyle(
                    height: 1.1,
                    letterSpacing: 2,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              decoration: this[i] == ' '
                  ? null
                  : BoxDecoration(boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 1)),
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(2, -1)),
                    ], color: Colors.blueAccent))
      ]),
    );
  }
}
