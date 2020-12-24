import 'dart:async';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  /// data source to search from
  final List<String> suggestions;

  /// callback when a sugestion is tapped it also returns the tapped value.
  final Function(String) onTap;

  /// hint for the search field
  final String hint;

  /// The initial value to be set in searchfield
  /// when its rendered, if not specified it will be empty
  final String initialValue;

  /// textStyle for the search Input
  final TextStyle searchStyle;

  /// textStyle for the SuggestionItem
  final TextStyle suggestionStyle;

  /// decoration for the search Input similar to built in textfield widget.
  final InputDecoration searchInputDecoration;

  /// decoration for suggestions List with ability to add box shadow background color and much more.
  final BoxDecoration suggestionsDecoration;

  /// decoration for suggestionItem with ability to add color and gradient in the background.

  final BoxDecoration suggestionItemDecoration;

  /// Suggestion Item height
  /// defaults to 35.0
  final double itemHeight;

  /// Color for the margin between the suggestions
  final Color marginColor;

  /// The max number of suggestions that
  /// can be shown in a viewport
  final double maxSuggestionsInViewPort;

  final TextEditingController controller;

  SearchField(
      {Key key,
      @required this.suggestions,
      this.initialValue,
      this.hint,
      this.searchStyle,
      this.marginColor,
      this.controller,
      this.itemHeight = 35.0,
      this.suggestionsDecoration,
      this.suggestionStyle,
      this.searchInputDecoration,
      this.suggestionItemDecoration,
      this.maxSuggestionsInViewPort = 5,
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
    sourceController = widget.controller ?? TextEditingController();
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
  void didUpdateWidget(covariant SearchField oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      sourceController = widget.controller ?? TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double height;
    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      height = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      height = widget.suggestions.length * widget.itemHeight;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller ?? sourceController,
          focusNode: _focus,
          style: widget.searchStyle,
          decoration:
              widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
                  InputDecoration(hintText: widget.hint),
          onChanged: (item) {
            List<String> searchResult = [];
            if (item.isEmpty) {
              sourceStream.sink.add(widget.suggestions);
              return;
            }
            widget.suggestions.forEach((suggestion) {
              if (suggestion.toLowerCase().contains(item.toLowerCase())) {
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
                if (snapshot.data.length > widget.maxSuggestionsInViewPort) {
                  height = widget.itemHeight * widget.maxSuggestionsInViewPort;
                } else if (snapshot.data.length == 1) {
                  height = widget.itemHeight;
                } else {
                  height = snapshot.data.length * widget.itemHeight;
                }
                return Container(
                    height: height,
                    alignment: Alignment.centerLeft,
                    decoration: widget.suggestionsDecoration ??
                        BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
                                  height: widget.itemHeight,
                                  padding: EdgeInsets.symmetric(horizontal: 5) +
                                      EdgeInsets.only(left: 8),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: widget.suggestionItemDecoration
                                          ?.copyWith(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: widget
                                                              .marginColor ??
                                                          Colors.black
                                                              .withOpacity(
                                                                  0.1)))) ??
                                      BoxDecoration(
                                          border: index ==
                                                  snapshot.data.length - 1
                                              ? null
                                              : Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          widget.marginColor ??
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.1)))),
                                  child: Text(
                                    snapshot.data[index],
                                    style: widget.suggestionStyle,
                                  ),
                                ),
                              )),
                    ));
              }
            })
      ],
    );
  }
}
