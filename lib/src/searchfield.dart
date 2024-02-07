import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

enum SuggestionDirection {
  /// show suggestions below the searchfield
  down,

  /// show suggestions above the searchfield
  up,

  /// suggestions will be shown based on the available space
  flex
}

class SearchFieldListItem<T> {
  Key? key;

  /// the text based on which the search happens
  final String searchKey;

  /// Custom Object to be associated with each ListItem
  /// For Suggestions with Custom Objects, pass [item] parameter to [SearchFieldListItem]
  /// see example in [example/lib/country_search.dart](https://github.com/maheshmnj/searchfield/tree/master/example/lib/country_search.dart)
  final T? item;

  /// The widget to be shown in the searchField
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

  /// The widget to be shown in the suggestion list
  /// if not specified, Text widget with default styling will be used
  /// to show a custom widget, use [child] instead
  /// see example in [example/lib/country_search.dart]()
  SearchFieldListItem(this.searchKey, {this.child, this.item, this.key});

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

/// extension to check if a Object is present in List<Object>
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

/// A widget that displays a searchfield and a list of suggestions
/// when the searchfield is brought into focus
/// see [example/lib/country_search.dart]
///
class SearchField<T> extends StatefulWidget {
  final FocusNode? focusNode;

  /// List of suggestions for the searchfield.
  /// each suggestion should have a unique searchKey
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchFieldListItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchFieldListItem<T>> suggestions;

  /// Callback when the suggestion is selected.
  /// The parameters passed to`SearchFieldListItem` in `suggestions` will be returned in the callback.
  final Function(SearchFieldListItem<T>)? onSuggestionTap;

  /// Callback when the searchfield is searched.
  /// The callback should return a list of SearchFieldListItem based on custom logic which will be
  /// shown as suggestions.
  /// If the callback is not specified, the searchfield will show suggestions which contains the
  /// search text.
  final List<SearchFieldListItem<T>>? Function(String)? onSearchTextChanged;

  /// Defines whether to enable the searchfield defaults to `true`
  final bool? enabled;

  /// Defines whether to show the searchfield as readOnly
  final bool readOnly;

  /// Used to enable/disable this form field auto validation and update its error text.

  /// If AutovalidateMode.onUserInteraction, this FormField will only auto-validate after its
  /// content changes. If AutovalidateMode.always, it will auto-validate even without user
  /// interaction. If AutovalidateMode.disabled, auto-validation will be disabled.
  ///
  /// Defaults to AutovalidateMode.disabled.
  final AutovalidateMode? autovalidateMode;

  /// Callback when the Searchfield is submitted
  ///  it returns the text from the searchfield
  final Function(String)? onSubmit;

  /// Hint for the [SearchField].
  final String? hint;

  /// Define a [TextInputAction] that is called when the field is submitted
  final TextInputAction? textInputAction;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final SearchFieldListItem<T>? initialValue;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// Specifies [TextStyle] for suggestions when no child is provided.
  final TextStyle? suggestionStyle;

  /// Specifies [InputDecoration] for search input [TextField].
  ///
  /// When not specified, the default value is [InputDecoration] initialized
  /// with [hint].
  final InputDecoration? searchInputDecoration;

  /// defaults to SuggestionState.expand
  final Suggestion suggestionState;

  /// Specifies the [SuggestionAction] called on suggestion tap.
  final SuggestionAction? suggestionAction;

  /// Specifies [SuggestionDecoration] for suggestion list. The property can be used to add [BoxShadow], [BoxBorder]
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
  final SuggestionDecoration? suggestionsDecoration;

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

  /// Keyboard Type for SearchField
  final TextInputType? inputType;

  /// `validator` for the [SearchField]
  /// to make use of this validator, The
  /// SearchField widget needs to be wrapped in a Form
  /// and pass it a Global key
  /// and write your validation logic in the validator
  /// you can define a global key
  ///
  ///  ```dart
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

  /// suggestion List offset from the searchfield
  /// The top left corner of the searchfield is the origin (0,0)
  final Offset? offset;

  /// An optional method to call with the final value when the form is saved via FormState.save.
  final void Function(String?)? onSaved;

  /// Callback when the searchfield is tapped
  final void Function()? onTap;

  /// Widget to show when the search returns
  /// empty results.
  /// defaults to [SizedBox.shrink]
  final Widget emptyWidget;

  /// Function that implements the comparison criteria to filter out suggestions.
  /// The 2 parameters are the input text and the `suggestionKey` passed to each `SearchFieldListItem`
  /// which should return true or false to filter out the suggestion.
  /// by default the comparator shows the suggestions that contain the input text
  /// in the `suggestionKey`
  ///
  /// @deprecated use [onSearchTextChanged] instead
  final bool Function(String inputText, String suggestionKey)? comparator;

  /// Defines whether to enable autoCorrect defaults to `true`
  final bool autoCorrect;

  /// Defines whether to enable autofocus defaults to `false`
  final bool autofocus;

  /// Callback when a tap is performed outside Searchfield (during the time the field has focus)
  final void Function(PointerDownEvent)? onTapOutside;

  /// input formatter for the searchfield
  final List<TextInputFormatter>? inputFormatters;

  final ScrollbarDecoration? scrollbarDecoration;

  /// suggestion direction defaults to [SuggestionDirection.down]
  final SuggestionDirection suggestionDirection;

  /// text capitalization defaults to [TextCapitalization.none]
  final TextCapitalization textCapitalization;

  SearchField(
      {Key? key,
      required this.suggestions,
      this.autoCorrect = true,
      this.autofocus = false,
      this.autovalidateMode,
      this.controller,
      this.emptyWidget = const SizedBox.shrink(),
      this.enabled,
      this.focusNode,
      this.hint,
      this.initialValue,
      this.inputFormatters,
      this.inputType,
      this.itemHeight = 35.0,
      this.marginColor,
      this.maxSuggestionsInViewPort = 5,
      this.readOnly = false,
      this.onSearchTextChanged,
      this.onSaved,
      this.onTap,
      this.onSubmit,
      this.onTapOutside,
      this.offset,
      this.onSuggestionTap,
      this.searchInputDecoration,
      this.searchStyle,
      this.scrollbarDecoration,
      this.suggestionStyle,
      this.suggestionsDecoration,
      this.suggestionDirection = SuggestionDirection.down,
      this.suggestionState = Suggestion.expand,
      this.suggestionItemDecoration,
      this.suggestionAction,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.validator,
      @Deprecated('use `onSearchTextChanged` instead.') this.comparator})
      : assert(
            (initialValue != null &&
                    suggestions.containsObject(initialValue)) ||
                initialValue == null,
            'Initial value should either be null or should be present in suggestions list.'),
        super(key: key);

  @override
  _SearchFieldState<T> createState() => _SearchFieldState();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  final StreamController<List<SearchFieldListItem<T>?>?> suggestionStream =
      StreamController<List<SearchFieldListItem<T>?>?>.broadcast();
  FocusNode? _focus;
  bool isSuggestionExpanded = false;
  TextEditingController? searchController;
  ScrollbarDecoration? _scrollbarDecoration;
  @override
  void dispose() {
    suggestionStream.close();
    _scrollController.dispose();
    if (widget.controller == null) {
      searchController!.dispose();
    }
    if (widget.focusNode == null) {
      _focus!.dispose();
    }
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
    }
    super.dispose();
  }

  void initialize() {
    if (widget.scrollbarDecoration == null) {
      _scrollbarDecoration = ScrollbarDecoration();
    } else {
      _scrollbarDecoration = widget.scrollbarDecoration;
    }

    if (widget.focusNode != null) {
      _focus = widget.focusNode;
    } else {
      _focus = FocusNode();
    }
    _focus!.addListener(() {
      if (mounted) {
        setState(() {
          isSuggestionExpanded = _focus!.hasFocus;
        });
      }
      if (isSuggestionExpanded) {
        _overlayEntry = _createOverlay();
        if (widget.initialValue == null) {
          if (widget.suggestionState == Suggestion.expand) {
            Future.delayed(Duration(milliseconds: 100), () {
              suggestionStream.sink.add(widget.suggestions);
            });
          }
        }
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry?.remove();
        }
      }
    });
  }

  /// With SuggestionDirection.flex, the widget will automatically decide the direction of the
  /// suggestion list based on the space available in the viewport. If the suggestions have enough
  /// space below the searchfield, the list will be shown below the searchfield, else it will be
  /// shown above the searchfield.
  SuggestionDirection getDirection() {
    if (_suggestionDirection == SuggestionDirection.flex) {
      final size = MediaQuery.of(context).size;
      final textFieldRenderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final textFieldSize = textFieldRenderBox.size;
      final offset = textFieldRenderBox.localToGlobal(Offset.zero);
      final isSpaceAvailable =
          size.height > offset.dy + textFieldSize.height + _totalHeight;
      if (isSpaceAvailable) {
        return SuggestionDirection.down;
      } else {
        return SuggestionDirection.up;
      }
    }
    return _suggestionDirection;
  }

  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
    _suggestionDirection = widget.suggestionDirection;
    initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayEntry = _createOverlay();
        if (widget.initialValue == null ||
            widget.initialValue!.searchKey.isEmpty) {
          suggestionStream.sink.add(null);
        } else {
          searchController!.text = widget.initialValue!.searchKey;
          suggestionStream.sink.add([widget.initialValue]);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    // update overlay dimensions on mediaQuery change
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SearchField<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      searchController = widget.controller ?? TextEditingController();
    }
    if (_suggestionDirection != oldWidget.suggestionDirection) {
      _suggestionDirection = widget.suggestionDirection;
    }
    if (oldWidget.suggestions != widget.suggestions) {
      suggestionStream.sink.add(widget.suggestions);
    }
    if (oldWidget.scrollbarDecoration != widget.scrollbarDecoration) {
      if (widget.scrollbarDecoration == null) {
        _scrollbarDecoration = ScrollbarDecoration();
      } else {
        _scrollbarDecoration = widget.scrollbarDecoration;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchFieldListItem<T>?>?>(
      stream: suggestionStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SearchFieldListItem<T>?>?> snapshot) {
        if (snapshot.data == null || !isSuggestionExpanded) {
          return SizedBox();
        } else if (snapshot.data!.isEmpty) {
          return widget.emptyWidget;
        } else {
          final paddingHeight = widget.suggestionsDecoration != null
              ? widget.suggestionsDecoration!.padding.vertical
              : 0;
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort +
                paddingHeight;
          } else if (snapshot.data!.length == 1) {
            _totalHeight = widget.itemHeight + paddingHeight;
          } else {
            _totalHeight =
                snapshot.data!.length * widget.itemHeight + paddingHeight;
          }
          final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

          final Widget listView = ListView.builder(
            reverse: _suggestionDirection == SuggestionDirection.up,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            physics: snapshot.data!.length == 1
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemBuilder: (context, index) => TextFieldTapRegion(
                child: InkWell(
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
                    _focus!.nextFocus();
                  } else if (widget.suggestionAction ==
                      SuggestionAction.unfocus) {
                    _focus!.unfocus();
                  }
                }

                // hide the suggestions
                suggestionStream.sink.add(null);
                if (widget.onSuggestionTap != null) {
                  widget.onSuggestionTap!(snapshot.data![index]!);
                }
              },
              child: Container(
                height: widget.itemHeight,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: widget.suggestionItemDecoration?.copyWith(
                      border: widget.suggestionItemDecoration?.border ??
                          Border(
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
                      style: widget.suggestionStyle,
                    ),
              ),
            )),
          );

          return AnimatedContainer(
            duration: _suggestionDirection == SuggestionDirection.up
                ? Duration.zero
                : Duration(milliseconds: 300),
            height: _totalHeight,
            alignment: Alignment.centerLeft,
            decoration: widget.suggestionsDecoration ??
                BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                        color: onSurfaceColor.withOpacity(0.1),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          2.0,
                          5.0,
                        )),
                  ],
                ),
            child: RawScrollbar(
              thumbVisibility: _scrollbarDecoration!.thumbVisibility,
              controller: _scrollController,
              padding: EdgeInsets.zero,
              shape: _scrollbarDecoration!.shape,
              fadeDuration: _scrollbarDecoration!.fadeDuration,
              radius: _scrollbarDecoration!.radius,
              thickness: _scrollbarDecoration!.thickness,
              thumbColor: _scrollbarDecoration!.thumbColor,
              minThumbLength: _scrollbarDecoration!.minThumbLength,
              trackRadius: _scrollbarDecoration!.trackRadius,
              trackVisibility: _scrollbarDecoration!.trackVisibility,
              timeToFade: _scrollbarDecoration!.timeToFade,
              pressDuration: _scrollbarDecoration!.pressDuration,
              trackBorderColor: _scrollbarDecoration!.trackBorderColor,
              trackColor: _scrollbarDecoration!.trackColor,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: listView,
              ),
            ),
          );
        }
      },
    );
  }

  /// Decides whether to show the suggestions
  /// on top or bottom of Searchfield
  /// User can have more control by manually specifying the offset
  Offset? getYOffset(
      Offset textFieldOffset, Size textFieldSize, int suggestionsCount) {
    final direction = getDirection();
    if (mounted) {
      if (direction == SuggestionDirection.down) {
        return Offset(0, textFieldSize.height);
      } else if (direction == SuggestionDirection.up) {
        // search results should not exceed maxSuggestionsInViewPort
        if (suggestionsCount > widget.maxSuggestionsInViewPort) {
          return Offset(
              0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
        } else {
          return Offset(0, -(widget.itemHeight * suggestionsCount));
        }
      }
    }
    return null;
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(builder: (context) {
      final textFieldRenderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final textFieldsize = textFieldRenderBox.size;
      final offset = textFieldRenderBox.localToGlobal(Offset.zero);
      var yOffset = Offset.zero;
      return StreamBuilder<List<SearchFieldListItem?>?>(
          stream: suggestionStream.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<SearchFieldListItem?>?> snapshot) {
            late var count = widget.maxSuggestionsInViewPort;
            if (snapshot.data != null) {
              count = snapshot.data!.length;
            }
            yOffset = getYOffset(offset, textFieldsize, count) ?? Offset.zero;
            return Positioned(
              left: offset.dx,
              width: textFieldsize.width,
              child: CompositedTransformFollower(
                  offset: widget.offset ?? yOffset,
                  link: _layerLink,
                  child: ClipRRect(
                    borderRadius: widget.suggestionsDecoration?.borderRadius ??
                        BorderRadius.zero,
                    child: Material(
                      child: _suggestionsBuilder(),
                    ),
                  )),
            );
          });
    });
  }

  late SuggestionDirection _suggestionDirection;
  final LayerLink _layerLink = LayerLink();

  /// height of suggestions overlay
  late double _totalHeight;
  GlobalKey key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      _totalHeight = widget.suggestions.length * widget.itemHeight;
    }
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        key: key,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        onTapOutside: widget.onTapOutside,
        autocorrect: widget.autoCorrect,
        readOnly: widget.readOnly,
        autovalidateMode: widget.autovalidateMode,
        onFieldSubmitted: (x) {
          if (widget.onSubmit != null) widget.onSubmit!(x);
        },
        onTap: () {
          /// only call if SuggestionState = [Suggestion.expand]
          if (!isSuggestionExpanded &&
              widget.suggestionState == Suggestion.expand) {
            suggestionStream.sink.add(widget.suggestions);
            if (mounted) {
              setState(() {
                isSuggestionExpanded = true;
              });
            }
          }
          if (widget.onTap != null) widget.onTap!();
        },
        onSaved: (x) {
          if (widget.onSaved != null) widget.onSaved!(x);
        },
        inputFormatters: widget.inputFormatters,
        controller: widget.controller ?? searchController,
        focusNode: _focus,
        validator: widget.validator,
        style: widget.searchStyle,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.inputType,
        decoration:
            widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
                InputDecoration(hintText: widget.hint),
        onChanged: (query) {
          var searchResult = <SearchFieldListItem<T>>[];
          if (widget.onSearchTextChanged != null) {
            searchResult = widget.onSearchTextChanged!(query) ?? [];
          } else {
            if (query.isEmpty) {
              _createOverlay();
              suggestionStream.sink.add(widget.suggestions);
              return;
            }
            for (final suggestion in widget.suggestions) {
              if (widget.comparator != null) {
                if (widget.comparator!(query, suggestion.searchKey)) {
                  searchResult.add(suggestion);
                }
              } else if (suggestion.searchKey
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                searchResult.add(suggestion);
              }
            }
          }
          suggestionStream.sink.add(searchResult);
        },
      ),
    );
  }
}

class SuggestionDecoration extends BoxDecoration {
  /// padding around the suggestion list
  @override
  final EdgeInsetsGeometry padding;

  SuggestionDecoration({
    this.padding = EdgeInsets.zero,
    Color? color,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BoxShape shape = BoxShape.rectangle,
  }) : super(
            color: color,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
            gradient: gradient,
            shape: shape);
}

class ScrollbarDecoration {
  /// The [OutlinedBorder] of the scrollbar's thumb.
  ///
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  /// it's simplest to just specify [radius]. By default, the scrollbar thumb's
  /// shape is a simple rectangle.
  OutlinedBorder? shape;

  /// The [Radius] of the scrollbar's thumb.
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  Radius? radius;

  /// The thickness of the scrollbar's thumb.
  double? thickness;

  /// Mustn't be null and the value has to be greater or equal to `minOverscrollLength`, which in
  /// turn is >= 0. Defaults to 18.0.
  double minThumbLength;

  /// The [Color] of the scrollbar's thumb.
  Color? thumbColor;

  /// The [Color] of the scrollbar's track.
  bool? trackVisibility;

  /// The [Radius] of the scrollbar's track.
  Radius? trackRadius;

  /// The [Color] of the scrollbar's track.
  Color? trackColor;

  /// The [Color] of the scrollbar's track border.
  Color? trackBorderColor;

  /// The [Duration] of the fade animation.
  Duration fadeDuration;

  /// Defines whether to show the scrollbar always or only when scrolling.
  /// defaults to `true`
  final bool? thumbVisibility;

  /// The [Duration] of time until the fade animation begins.
  /// Cannot be null, defaults to a [Duration] of 600 milliseconds.
  Duration timeToFade;

  /// The [Duration] of time that a LongPress will trigger the drag gesture of the scrollbar thumb.
  /// Cannot be null, defaults to [Duration.zero].
  Duration pressDuration;

  ScrollbarDecoration({
    this.minThumbLength = 18.0,
    this.thumbVisibility = true,
    this.radius,
    this.thickness,
    this.thumbColor,
    this.shape,
    this.trackVisibility,
    this.trackRadius,
    this.trackColor,
    this.trackBorderColor,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.pressDuration = const Duration(milliseconds: 100),
  });
}
