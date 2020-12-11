import 'dart:async';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  /// data source to search from
  final List<String> suggestions;

  /// callback when a sugestion is tapped
  /// it also returned the tapped value
  final Function(String) onTap;

  /// hint for the search field
  final String hint;

  /// The initial value to be set in searchfield
  /// when its rendered, if not specified it will be empty
  final String initialValue;

  SearchField(
      {Key key,
      @required this.suggestions,
      this.initialValue,
      this.hint,
      this.onTap})
      : assert(suggestions != null, 'Suggestions cannot be Empty'),
        assert(
            (initialValue != null && suggestions.contains(initialValue)) ||
                initialValue == null,
            'Initial Value should either be null or should be present in suggestions list.'),
        super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final sourceStream = StreamController<List<String>>.broadcast();
  FocusNode _focus = FocusNode();
  bool sourceFocused = false;
  TextEditingController sourceController;
  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    sourceStream.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sourceController = TextEditingController();
    _focus.addListener(() {
      setState(() {
        sourceFocused = _focus.hasFocus;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue == null || widget.initialValue.isEmpty) {
        sourceStream.sink.add(widget.suggestions);
      } else {
        sourceController.text = widget.initialValue;
        sourceStream.sink.add([widget.initialValue]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double height;
    double heightFactor = 35.0;
    if (widget.suggestions.length > 5) {
      height = heightFactor * 5;
    } else {
      height = widget.suggestions.length * heightFactor;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: sourceController,
          focusNode: _focus,
          onChanged: (item) {
            List<String> searchResult = [];
            if (item.isEmpty) {
              sourceStream.sink.add(widget.suggestions);
              return;
            }
            widget.suggestions.forEach((suggestion) {
              if (suggestion.toLowerCase().contains(item.toLowerCase())) {
                print('$suggestion  <=> query=$item');
                searchResult.add(suggestion);
              }
            });
            sourceStream.sink.add(searchResult);
          },
        ),
        SizedBox(
          height: 2,
        ),
        StreamBuilder<List<String>>(
            stream: sourceStream.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.data == null ||
                  snapshot.data.isEmpty ||
                  !sourceFocused) {
                return Container();
              } else {
                if (snapshot.data.length > 5) {
                  height = heightFactor * 5;
                } else if (snapshot.data.length == 1) {
                  height = 45;
                } else {
                  height = snapshot.data.length * heightFactor;
                }
                return Container(
                    height: height,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            2.0,
                            5.0,
                          ),
                        ),
                      ],
                    ),
                    child: ListView(
                      physics: snapshot.data.length == 1
                          ? NeverScrollableScrollPhysics()
                          : ScrollPhysics(),
                      children: List.generate(
                          snapshot.data.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  sourceController.text = snapshot.data[index];
                                  sourceController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                              sourceController.text.length));
                                  // hide the suggestions
                                  sourceStream.sink.add(null);
                                  if (widget.onTap != null) {
                                    widget.onTap(snapshot.data[index]);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 16) +
                                      EdgeInsets.only(left: 8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: index == snapshot.data.length - 1
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.1)))),
                                  child: Text(snapshot.data[index]),
                                ),
                              )),
                    ));
              }
            })
      ],
    );
  }
}
