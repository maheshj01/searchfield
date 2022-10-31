import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DynamicSample extends StatefulWidget {
  const DynamicSample({Key? key}) : super(key: key);

  @override
  State<DynamicSample> createState() => _DynamicSampleState();
}

class _DynamicSampleState extends State<DynamicSample> {
  List<String> suggestions = [
    'suggestion 1',
    'suggestion 2',
  ];
  int suggestionsCount = 2;
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SearchField(
            suggestions:
                suggestions.map((e) => SearchFieldListItem(e)).toList(),
            // hasOverlay: false,
            maxSuggestionsInViewPort: 6,
          )
        ],
      ),
    );
  }
}
