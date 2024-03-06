import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class NetworkSample extends StatefulWidget {
  const NetworkSample({Key? key}) : super(key: key);

  @override
  State<NetworkSample> createState() => _NetworkSampleState();
}

class _NetworkSampleState extends State<NetworkSample> {
  final focus = FocusNode();

  Future<List<String>> getSuggestions() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
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
  }

  var suggestions = <String>[];

  final suggestionDecoration = SuggestionDecoration(
    color: Colors.red,
    border: Border.all(color: Colors.orange),
    borderRadius: BorderRadius.circular(24),
  );
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: TextStyle(fontSize: 24, color: Colors.white)),
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchField(
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
          onTap: () async {
            final result = await getSuggestions();
            setState(() {
              suggestions = result;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'error';
            }
            return null;
          },
          emptyWidget: Container(
              decoration: suggestionDecoration,
              height: 200,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ))),
          key: const Key('searchfield'),
          hint: 'Load suggestions from network',
          itemHeight: 50,
          scrollbarDecoration: ScrollbarDecoration(),
          onTapOutside: (x) {},
          suggestionStyle: const TextStyle(fontSize: 24, color: Colors.white),
          searchInputDecoration: InputDecoration(
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
          suggestionsDecoration: suggestionDecoration,
          suggestions: suggestions
              .map((e) => SearchFieldListItem<String>(e, child: searchChild(e)))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<String> x) {
            focus.unfocus();
          },
        ),
      ],
    );
  }
}