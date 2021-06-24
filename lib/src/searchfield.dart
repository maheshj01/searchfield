import 'dart:async';
import 'package:flutter/material.dart';

class SearchField<T extends Object> extends StatefulWidget {
  /// Hint for the [SearchField].
  final String? hint;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final T? initialValue;

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

  /// The builder for each list Item
  Widget Function(BuildContext, int) listItemBuilder;

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

  /// Specifies the function which returns the resulting list
  /// based on some logic
  final List<T> Function(String) optionsBuilder;

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
    required this.optionsBuilder,
    required this.listItemBuilder,
    this.controller,
    this.initialValue,
    this.hint,
    this.hasOverlay = true,
    this.searchStyle,
    this.marginColor,
    this.validator,
    this.itemHeight = 35.0,
    this.suggestionsDecoration,
    this.suggestionStyle,
    this.searchInputDecoration,
    this.suggestionItemDecoration,
    this.maxSuggestionsInViewPort = 5,
  })  : assert((initialValue != null) || initialValue == null,
            'Initial Value should either be null or should be of type T'),
        super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState<T extends Object> extends State<SearchField<T>> {
  final StreamController<List<T?>?> sourceStream =
      StreamController<List<T>?>.broadcast();
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
      if (widget.initialValue == null) {
        sourceStream.sink.add(null);
      } else {
        // sourceController!.text = widget.initialValue!;
        sourceStream.sink.add([widget.initialValue]);
      }
    });
  }

  @override
  void didUpdateWidget(covariant SearchField<T> oldWidget) {
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

  // Widget listItemBuilder() {
  //   final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
  //   return StreamBuilder<List<T?>?>(
  //     stream: sourceStream.stream,
  //     builder: (BuildContext context, AsyncSnapshot<List<T?>?> snapshot) {
  //       if (snapshot.data == null || snapshot.data!.isEmpty || !sourceFocused) {
  //         return Container();
  //       } else {
  //         if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
  //           height = widget.itemHeight * widget.maxSuggestionsInViewPort;
  //         } else if (snapshot.data!.length == 1) {
  //           height = widget.itemHeight;
  //         } else {
  //           height = snapshot.data!.length * widget.itemHeight;
  //         }
  //         return AnimatedContainer(
  //           duration: isUp ? Duration.zero : Duration(milliseconds: 300),
  //           height: height,
  //           alignment: Alignment.centerLeft,
  //           decoration: widget.suggestionsDecoration ??
  //               BoxDecoration(
  //                 color: Theme.of(context).colorScheme.surface,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: onSurfaceColor.withOpacity(0.1),
  //                     blurRadius: 8.0, // soften the shadow
  //                     spreadRadius: 2.0, // extend the shadow
  //                     offset: widget.hasOverlay
  //                         ? Offset(
  //                             2.0,
  //                             5.0,
  //                           )
  //                         : Offset(1.0, 0.5),
  //                   ),
  //                 ],
  //               ),
  //           child: ListView.builder(
  //             reverse: isUp,
  //             itemCount: snapshot.data!.length,
  //             physics: snapshot.data!.length == 1
  //                 ? NeverScrollableScrollPhysics()
  //                 : ScrollPhysics(),
  //             itemBuilder: (context, index) =>
  //                 widget.listItemBuilder(context, index),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

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
        builder: (context) => StreamBuilder<List<T?>?>(
            stream: sourceStream.stream,
            builder: (BuildContext context, AsyncSnapshot<List<T?>?> snapshot) {
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
                    child: Material(child: widget.listItemBuilder(context,))),
              );
            }));
  }

  final LayerLink _layerLink = LayerLink();
  bool isUp = false;
  @override
  Widget build(BuildContext context) {
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
              final result = widget.optionsBuilder(item);
              sourceStream.sink.add(result);
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
