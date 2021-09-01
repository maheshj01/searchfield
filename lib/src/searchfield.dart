import 'dart:async';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  /// Data source to perform search.
  final List<String> suggestions;
  
  /// Specifies whether the [suggestions] should be shown directly on focus,
  /// or on input callback.
  final bool? showSuggestionsOnFocus;

  /// Callback to return the selected suggestion.
  final Function(String?)? onTap;

  /// Hint for the [SearchField].
  final String? hint;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final String? initialValue;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// Specifies [TextStyle] for suggestions.
  final TextStyle? suggestionStyle;

  /// Specifies [InputDecoration] for search input [TextField].
  ///
  /// When not specified, the default value is [InputDecoration] initialized
  /// with [hint].
  final InputDecoration? searchInputDecoration;

  /// Specifies [BoxDecoration] for suggestion list. The property can be used to add [BoxShadow],
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
  final BoxDecoration? suggestionItemDecoration;

  /// Specifies height for item suggestion.
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
    this.itemHeight = 35.0,
    this.suggestionsDecoration,
    this.suggestionStyle,
    this.searchInputDecoration,
    this.suggestionItemDecoration,
    this.maxSuggestionsInViewPort = 5,
    this.onTap,
    this.showSuggestionsOnFocus,
  })  : assert(
            (initialValue != null && suggestions.contains(initialValue)) ||
                initialValue == null,
            'Initial Value should either be null or should be present in suggestions list.'),
        super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final StreamController<List<String?>?> sourceStream =
      StreamController<List<String>?>.broadcast();
  final FocusNode _focus = FocusNode();
  bool sourceFocused = false;
  TextEditingController? sourceController;

  @override
  void dispose() {
    _focus.dispose();
    sourceStream.close();
    super.dispose();
  }

  void initialize() {
    _focus.addListener(() {
      setState(() {
        sourceFocused = _focus.hasFocus;
      });
      if (widget.hasOverlay) {
        if (sourceFocused) {
          _overlayEntry = _createOverlay();
          Overlay.of(context)!.insert(_overlayEntry);
        } else {
          _overlayEntry.remove();
        }
      }
    });
  }

  late OverlayEntry _overlayEntry;
  @override
  void initState() {
    super.initState();
    sourceController = widget.controller ?? TextEditingController();
    initialize();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.initialValue == null || widget.initialValue!.isEmpty) {
        sourceStream.sink.add(null);
      } else {
        sourceController!.text = widget.initialValue!;
        sourceStream.sink.add([widget.initialValue]);
      }
      if(widget.showSuggestionsOnFocus != null && widget.showSuggestionsOnFocus!) sourceStream.sink.add(widget.suggestions);
    });
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      sourceController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.hasOverlay != widget.hasOverlay) {
      if (widget.hasOverlay) {
        initialize();
      } else {
        if (_overlayEntry.mounted) {
          _overlayEntry.remove();
        }
      }
      setState(() {});
    }
  }

  Widget _suggestionsBuilder() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return StreamBuilder<List<String?>?>(
      stream: sourceStream.stream,
      builder: (BuildContext context, AsyncSnapshot<List<String?>?> snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty || !sourceFocused) {
          return Container();
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
                      blurRadius: 8.0, // soften the shadow
                      spreadRadius: 2.0, // extend the shadow
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
              itemCount: snapshot.data!.length,
              physics: snapshot.data!.length == 1
                  ? NeverScrollableScrollPhysics()
                  : ScrollPhysics(),
              itemBuilder: (_focus, index) => GestureDetector(
                onTap: () {
                  sourceController!.text = snapshot.data![index]!;
                  sourceController!.selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: sourceController!.text.length,
                    ),
                  );
                  // hide the suggestions
                  sourceStream.sink.add(null);
                  if (widget.onTap != null) {
                    widget.onTap!(snapshot.data![index]);
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
                  child: Text(
                    snapshot.data![index]!,
                    style: widget.suggestionStyle,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Offset getYOffset(Offset widgetOffset, int resultCount) {
    final size = MediaQuery.of(context).size;
    double position = widgetOffset.dy;
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
        builder: (context) => StreamBuilder<List<String?>?>(
            stream: sourceStream.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<String?>?> snapshot) {
              late int count = widget.maxSuggestionsInViewPort;
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
            controller: widget.controller ?? sourceController,
            focusNode: _focus,
            validator: widget.validator,
            style: widget.searchStyle,
            decoration:
                widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
                    InputDecoration(hintText: widget.hint),
            onChanged: (item) {
              final searchResult = <String>[];
              if (item.isEmpty) {
                sourceStream.sink.add(widget.suggestions);
                return;
              }
              for (final suggestion in widget.suggestions) {
                if (suggestion.toLowerCase().contains(item.toLowerCase())) {
                  searchResult.add(suggestion);
                }
              }
              sourceStream.sink.add(searchResult);
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
