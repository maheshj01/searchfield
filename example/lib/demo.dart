import 'package:example/extensions.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final List<String> _suggestions = [
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
              // selectedValue: SearchFieldListItem(_suggestions[2], SizedBox()),
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
                suggestions: _statesOfIndia
                    .map((e) => SearchFieldListItem(e,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )))
                    .toList(),
                onSaved: (x) {},
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'SearchField Example 2',
                validator: (x) {
                  if (!_statesOfIndia.contains(x) || x!.isEmpty) {
                    return 'Please Enter a valid State';
                  }
                  return null;
                },
                searchInputDecoration: SearchInputDecoration(
                  searchStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withValues(alpha: 0.8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.8),
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
              suggestionsDecoration: SuggestionDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
              ),
              selectedValue: SearchFieldListItem(
                _suggestions[2],
                child: Container(
                  color: Colors.red,
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    _suggestions[2],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              suggestionItemDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: Colors.transparent,
                      style: BorderStyle.solid,
                      width: 1.0)),
              searchInputDecoration: SearchInputDecoration(
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.2),
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
          SizedBox(
            height: 250,
            width: 200,
            child: SearchField<String>(
              itemHeight: 50.0,
              // offset: Offset(100, 0),
              suggestions: [
                for (int i = 0; i < 10; i++)
                  {
                    'item': 'item$i',
                    'value': 'value$i',
                  },
              ]
                  .map(
                    (e) => SearchFieldListItem<String>(
                      e['item'] ?? '',
                      item: e['item'],
                      child: Container(
                        color: Colors.red,
                        width: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 300),
                        child: Text(e['value'] ?? ''),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              scrollbarDecoration: ScrollbarDecoration(thumbVisibility: false),
              suggestionItemDecoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                gradient: LinearGradient(colors: [
                  Color(0xff70e1f5),
                  Color(0xffffd194),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              suggestions:
                  _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              suggestionState: Suggestion.hidden,
              searchInputDecoration: SearchInputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: 'SearchField',
                border: OutlineInputBorder(),
              ),
              hint: 'SearchField example 4',
              maxSuggestionsInViewPort: 6,
              suggestionDirection: SuggestionDirection.up,
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
                  _formKey.currentState!.save();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Validate Field 2'),
                )),
          ),
        ],
      ),
    );
  }
}
