import 'dart:async';
import 'package:flutter/material.dart';

enum Suggestion {
  /// shows suggestions when searchfield is brought into focus
  expand,

  /// keeps the suggestion overlay hidden until
  /// first letter is entered
  hidden,
}

// enum to define the Focus of the searchfield when a suggestion is tapped
enum SuggestionAction {
  /// shift to next focus
  next,

  /// close keyboard and unfocus
  unfocus,
}

class SearchFieldListItem {
  Key? key;

  /// the text based on which the search happens
  final String searchKey;

  /// The widget to be shown in the searchField
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

  SearchFieldListItem(this.searchKey, {this.child, this.key});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchFieldListItem &&
            runtimeType == other.runtimeType &&
            searchKey == other.searchKey;
  }

  @override
  int get hashCode => searchKey.hashCode;
}

extension ListContainsObject<T> on List {
  bool containsObject(T object) {
    for (var item in this) {
      if (object == item) {
        return true;
      }
    }
    return false;
  }
}

class SearchField extends StatefulWidget {
  /// List of suggestions for the searchfield.
  /// each suggestion should have a unique searchKey
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchFieldListItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchFieldListItem> suggestions;

  /// Callback to return the selected suggestion.
  final Function(SearchFieldListItem?)? onTap;

  /// Hint for the [SearchField].
  final String? hint;

  /// Define a [TextInputAction] that is called when the field is submitted
  final TextInputAction? textInputAction;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final SearchFieldListItem? initialValue;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// Specifies [InputDecoration] for search input [TextField].
  ///
  /// When not specified, the default value is [InputDecoration] initialized
  /// with [hint].
  final InputDecoration? searchInputDecoration;

  /// defaults to SuggestionState.expand
  final Suggestion suggestionState;

  /// Specifies the [SuggestionAction] called on suggestion tap.
  final SuggestionAction? suggestionAction;

  /// Specifies [BoxDecoration] for suggestion list. The property can be used to add [BoxShadow], [BoxBorder]
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   color: Theme.of(context).colorScheme.surface,
  ///   boxShadow: [
  ///     BoxShadow(
  ///       color: onSurfaceColor.withOpacity(0.1),
  ///       blurRadius: 8.0, // soften the shadow
  ///       spreadRadius: 2.0, //extend the shadow
  ///       offset: Offset(
  ///         2.0,
  ///         5.0,
  ///       ),
  ///     ),
  ///   ],
  /// )
  /// ```
  final BoxDecoration? suggestionsDecoration;

  /// Specifies [BoxDecoration] for items in suggestion list. The property can be used to add [BoxShadow],
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   border: Border(
  ///     bottom: BorderSide(
  ///       color: widget.marginColor ??
  ///         onSurfaceColor.withOpacity(0.1),
  ///     ),
  ///   ),
  /// )
  /// ```
  final BoxDecoration? suggestionItemDecoration;

  /// Specifies height for each suggestion item in the list.
  ///
  /// When not specified, the default value is `35.0`.
  final double itemHeight;

  /// Specifies the color of margin between items in suggestions list.
  ///
  /// When not specified, the default value is `Theme.of(context).colorScheme.onSurface.withOpacity(0.1)`.
  final Color? marginColor;

  /// Specifies the number of suggestions that can be shown in viewport.
  ///
  /// When not specified, the default value is `5`.
  /// if the number of suggestions is less than 5, then [maxSuggestionsInViewPort]
  /// will be the length of [suggestions]
  final int maxSuggestionsInViewPort;

  /// Specifies the `TextEditingController` for [SearchField].
  final TextEditingController? controller;

  /// `validator` for the [SearchField]
  /// to make use of this validator, The
  /// SearchField widget needs to be wrapped in a Form
  /// and pass it a Global key
  /// and write your validation logic in the validator
  /// you can define a global key
  ///
  ///  ```
  ///  Form(
  ///   key: _formKey,
  ///   child: SearchField(
  ///     suggestions: _statesOfIndia,
  ///     validator: (state) {
  ///       if (!_statesOfIndia.contains(state) || state.isEmpty) {
  ///         return 'Please Enter a valid State';
  ///       }
  ///       return null;
  ///     },
  ///   )
  /// ```
  /// You can then validate the form by calling
  /// the validate function of the form
  ///
  /// `_formKey.currentState.validate();`
  ///
  ///
  ///
  final String? Function(String?)? validator;

  /// if false the suggestions will be shown below
  /// the searchfield along the Y-axis.
  /// if true the suggestions will be shown floating like the
  /// along the Z-axis
  /// defaults to ```true```
  final bool hasOverlay;

  SearchField({
    Key? key,
    required this.suggestions,
    this.initialValue,
    this.hint,
    this.hasOverlay = true,
    this.searchStyle,
    this.marginColor,
    this.controller,
    this.validator,
    this.suggestionState = Suggestion.expand,
    this.itemHeight = 35.0,
    this.suggestionsDecoration,
    this.searchInputDecoration,
    this.suggestionItemDecoration,
    this.maxSuggestionsInViewPort = 5,
    this.onTap,
    this.textInputAction,
    this.suggestionAction,
  })  : assert(
            (initialValue != null &&
                    suggestions.containsObject(initialValue)) ||
                initialValue == null,
            'Initial value should either be null or should be present in suggestions list.'),
        super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final StreamController<List<SearchFieldListItem?>?> suggestionStream =
      StreamController<List<SearchFieldListItem?>?>.broadcast();
  final FocusNode _focus = FocusNode();
  bool isSuggestionExpanded = false;
  TextEditingController? searchController;

  @override
  void dispose() {
    _focus.dispose();
    suggestionStream.close();
    searchController!.dispose();
    super.dispose();
  }

  void initialize() {
    _focus.addListener(() {
      if (mounted) {
        setState(() {
          isSuggestionExpanded = _focus.hasFocus;
        });
      }
      if (widget.hasOverlay) {
        if (isSuggestionExpanded) {
          if (widget.initialValue == null) {
            if (widget.suggestionState == Suggestion.expand) {
              Future.delayed(Duration(milliseconds: 100), () {
                suggestionStream.sink.add(widget.suggestions);
              });
            }
          }
          _overlayEntry = _createOverlay();
          Overlay.of(context)!.insert(_overlayEntry);
        } else {
          _overlayEntry.remove();
        }
      } else if (isSuggestionExpanded) {
        if (widget.initialValue == null) {
          if (widget.suggestionState == Suggestion.expand) {
            Future.delayed(Duration(milliseconds: 100), () {
              suggestionStream.sink.add(widget.suggestions);
            });
          }
        }
      }
    });
  }

  late OverlayEntry _overlayEntry;
  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
    initialize();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.initialValue == null ||
          widget.initialValue!.searchKey.isEmpty) {
        suggestionStream.sink.add(null);
      } else {
        searchController!.text = widget.initialValue!.searchKey;
        suggestionStream.sink.add([widget.initialValue]);
      }
      suggestionStream.sink.add(widget.suggestions);
    });
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    if (oldWidget.controller != widget.controller) {
      searchController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.hasOverlay != widget.hasOverlay) {
      if (widget.hasOverlay) {
        initialize();
      } else {
        if (_overlayEntry.mounted) {
          _overlayEntry.remove();
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _suggestionsBuilder() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return StreamBuilder<List<SearchFieldListItem?>?>(
      stream: suggestionStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SearchFieldListItem?>?> snapshot) {
        if (snapshot.data == null ||
            snapshot.data!.isEmpty ||
            !isSuggestionExpanded) {
          return SizedBox();
        } else {
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            height = widget.itemHeight * widget.maxSuggestionsInViewPort;
          } else if (snapshot.data!.length == 1) {
            height = widget.itemHeight;
          } else {
            height = snapshot.data!.length * widget.itemHeight;
          }
          return AnimatedContainer(
            duration: isUp ? Duration.zero : Duration(milliseconds: 300),
            height: height,
            alignment: Alignment.centerLeft,
            decoration: widget.suggestionsDecoration ??
                BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: onSurfaceColor.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: widget.hasOverlay
                          ? Offset(
                              2.0,
                              5.0,
                            )
                          : Offset(1.0, 0.5),
                    ),
                  ],
                ),
            child: ListView.builder(
              reverse: isUp,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.length,
              physics: snapshot.data!.length == 1
                  ? NeverScrollableScrollPhysics()
                  : ScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  searchController!.text = snapshot.data![index]!.searchKey;
                  searchController!.selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: searchController!.text.length,
                    ),
                  );

                  // suggestion action to switch focus to next focus node
                  if (widget.suggestionAction != null) {
                    if (widget.suggestionAction == SuggestionAction.next) {
                      _focus.nextFocus();
                    } else if (widget.suggestionAction ==
                        SuggestionAction.unfocus) {
                      _focus.unfocus();
                    }
                  }

                  // hide the suggestions
                  suggestionStream.sink.add(null);
                  if (widget.onTap != null) {
                    widget.onTap!(snapshot.data![index] as SearchFieldListItem);
                  }
                },
                child: Container(
                    height: widget.itemHeight,
                    padding: EdgeInsets.symmetric(horizontal: 5) +
                        EdgeInsets.only(left: 8),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: widget.suggestionItemDecoration?.copyWith(
                          border: Border(
                            bottom: BorderSide(
                              color: widget.marginColor ??
                                  onSurfaceColor.withOpacity(0.1),
                            ),
                          ),
                        ) ??
                        BoxDecoration(
                          border: index == snapshot.data!.length - 1
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                    color: widget.marginColor ??
                                        onSurfaceColor.withOpacity(0.1),
                                  ),
                                ),
                        ),
                    child: snapshot.data![index]!.child ??
                        Text(
                          snapshot.data![index]!.searchKey,
                        )),
              ),
            ),
          );
        }
      },
    );
  }

  Offset getYOffset(Offset widgetOffset, int resultCount) {
    final size = MediaQuery.of(context).size;
    final position = widgetOffset.dy;
    if ((position + height) < (size.height - widget.itemHeight * 2)) {
      return Offset(0, widget.itemHeight + 10.0);
    } else {
      if (resultCount > widget.maxSuggestionsInViewPort) {
        isUp = false;
        return Offset(
            0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
      } else {
        isUp = true;
        return Offset(0, -(widget.itemHeight * resultCount));
      }
    }
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => StreamBuilder<List<SearchFieldListItem?>?>(
            stream: suggestionStream.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchFieldListItem?>?> snapshot) {
              late var count = widget.maxSuggestionsInViewPort;
              if (snapshot.data != null) {
                count = snapshot.data!.length;
              }
              return Positioned(
                left: offset.dx,
                width: size.width,
                child: CompositedTransformFollower(
                    offset: getYOffset(offset, count),
                    link: _layerLink,
                    child: Material(child: _suggestionsBuilder())),
              );
            }));
  }

  final LayerLink _layerLink = LayerLink();
  late double height;
  bool isUp = false;
  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      height = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      height = widget.suggestions.length * widget.itemHeight;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            onTap: () {
              /// only call that if [SuggestionState.onTap] is selected
              if (!isSuggestionExpanded &&
                  widget.suggestionState == Suggestion.expand) {
                if (mounted) {
                  setState(() {
                    isSuggestionExpanded = true;
                  });
                }
                Future.delayed(Duration(milliseconds: 100), () {
                  suggestionStream.sink.add(widget.suggestions);
                });
              }
            },
            controller: widget.controller ?? searchController,
            focusNode: _focus,
            validator: widget.validator,
            style: widget.searchStyle,
            textInputAction: widget.textInputAction,
            decoration:
                widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
                    InputDecoration(hintText: widget.hint),
            onChanged: (item) {
              final searchResult = <SearchFieldListItem>[];
              if (item.isEmpty) {
                suggestionStream.sink.add(widget.suggestions);
                return;
              }
              for (final suggestion in widget.suggestions) {
                if (suggestion.searchKey
                    .toLowerCase()
                    .contains(item.toLowerCase())) {
                  searchResult.add(suggestion);
                }
              }
              suggestionStream.sink.add(searchResult);
            },
          ),
        ),
        if (!widget.hasOverlay)
          SizedBox(
            height: 2,
          ),
        if (!widget.hasOverlay) _suggestionsBuilder()
      ],
    );
  }
}
