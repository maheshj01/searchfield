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
}

class SearchFieldListItem<T> {
  Key? key;

  /// the text based on which the search happens
  final String searchKey;

  /// Custom Object to be associated with each ListItem
  /// see example in [example/lib/country_search.dart](https://github.com/maheshmnj/searchfield/tree/master/example/lib/country_search.dart)
  final T? item;

  /// The widget to be shown in the searchField
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

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
  final Function(SearchFieldListItem<T>)? onSuggestionTap;

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

  /// if false the suggestions will be shown below
  /// the searchfield along the Y-axis.
  /// if true the suggestions will be shown floating like the
  /// along the Z-axis
  /// defaults to `true`
  final bool hasOverlay;

  /// suggestion List offset from the searchfield
  /// The top left corner of the searchfield is the origin (0,0)
  final Offset? offset;

  /// Widget to show when the search returns
  /// empty results.
  /// defaults to [SizedBox.shrink]
  final Widget emptyWidget;

  /// Defines whether to enable autoCorrect defaults to `true`
  final bool autoCorrect;

  /// input formatter for the searchfield
  final List<TextInputFormatter>? inputFormatters;

  /// suggestion direction defaults to [SuggestionDirection.up]
  /// if [hasOverlay] is `false` then the direction is ignored
  /// and the suggestions are shown below the searchfield
  /// when suggestionDirection and offset is specified then
  /// suggestionDirection is ignored.
  final SuggestionDirection suggestionDirection;

  SearchField({
    Key? key,
    required this.suggestions,
    this.autoCorrect = true,
    this.controller,
    this.emptyWidget = const SizedBox.shrink(),
    this.focusNode,
    this.hasOverlay = true,
    this.hint,
    this.initialValue,
    this.inputFormatters,
    this.inputType,
    this.itemHeight = 35.0,
    this.marginColor,
    this.maxSuggestionsInViewPort = 5,
    this.onSubmit,
    this.offset,
    this.onSuggestionTap,
    this.searchInputDecoration,
    this.searchStyle,
    this.suggestionStyle,
    this.suggestionsDecoration,
    this.suggestionDirection = SuggestionDirection.down,
    this.suggestionState = Suggestion.expand,
    this.suggestionItemDecoration,
    this.suggestionAction,
    this.textInputAction,
    this.validator,
  })  : assert(
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

  @override
  void dispose() {
    suggestionStream.close();
    if (widget.controller == null) {
      searchController!.dispose();
    }
    if (widget.focusNode == null) {
      _focus!.dispose();
    }
    super.dispose();
  }

  void initialize() {
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
      if (widget.hasOverlay) {
        if (isSuggestionExpanded) {
          if (widget.initialValue == null) {
            if (widget.suggestionState == Suggestion.expand) {
              Future.delayed(Duration(milliseconds: 100), () {
                suggestionStream.sink.add(widget.suggestions);
              });
            }
          }
          Overlay.of(context)!.insert(_overlayEntry);
        } else {
          _overlayEntry.remove();
        }
      } else {
        if (isSuggestionExpanded) {
          if (widget.initialValue == null) {
            if (widget.suggestionState == Suggestion.expand) {
              Future.delayed(Duration(milliseconds: 100), () {
                suggestionStream.sink.add(widget.suggestions);
              });
            } else {
              Future.delayed(Duration(milliseconds: 100), () {
                suggestionStream.sink.add(null);
              });
            }
          }
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            suggestionStream.sink.add(null);
          });
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
  void didUpdateWidget(covariant SearchField<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      searchController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.hasOverlay != widget.hasOverlay) {
      if (widget.hasOverlay) {
        _overlayEntry = _createOverlay();
        _focus!.removeListener(initialize);
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
    if (oldWidget.suggestions != widget.suggestions) {
      suggestionStream.sink.add(widget.suggestions);
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
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
          } else if (snapshot.data!.length == 1) {
            _totalHeight = widget.itemHeight;
          } else {
            _totalHeight = snapshot.data!.length * widget.itemHeight;
          }
          final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
          return AnimatedContainer(
            duration: widget.suggestionDirection == SuggestionDirection.up
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
              reverse: widget.suggestionDirection == SuggestionDirection.up,
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
    if (mounted) {
      final size = MediaQuery.of(context).size;
      final isSpaceAvailable = size.height >
          textFieldOffset.dy + textFieldSize.height + _totalHeight;
      if (widget.suggestionDirection == SuggestionDirection.down) {
        return Offset(0, textFieldSize.height);
      } else if (widget.suggestionDirection == SuggestionDirection.up) {
        // search results should not exceed maxSuggestionsInViewPort
        if (suggestionsCount > widget.maxSuggestionsInViewPort) {
          return Offset(
              0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
        } else {
          return Offset(0, -(widget.itemHeight * suggestionsCount));
        }
      } else {
        if (!_isDirectionCalculated) {
          _isDirectionCalculated = true;
          if (isSpaceAvailable) {
            _offset = Offset(0, textFieldSize.height);
            return _offset;
          } else {
            if (suggestionsCount > widget.maxSuggestionsInViewPort) {
              _offset = Offset(
                  0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
              return _offset;
            } else {
              _offset = Offset(0, -(widget.itemHeight * suggestionsCount));
              return _offset;
            }
          }
        } else {
          return _offset;
        }
      }
    }
    return null;
  }

  OverlayEntry _createOverlay() {
    final textFieldRenderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final textFieldsize = textFieldRenderBox.size;
    final offset = textFieldRenderBox.localToGlobal(Offset.zero);
    Offset yOffset = Offset.zero;
    return OverlayEntry(
        builder: (context) => StreamBuilder<List<SearchFieldListItem?>?>(
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
                    child: Material(child: _suggestionsBuilder())),
              );
            }));
  }

  final LayerLink _layerLink = LayerLink();
  late double _totalHeight;
  GlobalKey key = GlobalKey();
  bool _isDirectionCalculated = false;
  Offset _offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      _totalHeight = widget.suggestions.length * widget.itemHeight;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            key: key,
            autocorrect: widget.autoCorrect,
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
            },
            inputFormatters: widget.inputFormatters,
            controller: widget.controller ?? searchController,
            focusNode: _focus,
            validator: widget.validator,
            style: widget.searchStyle,
            textInputAction: widget.textInputAction,
            keyboardType: widget.inputType,
            decoration:
                widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
                    InputDecoration(hintText: widget.hint),
            onChanged: (query) {
              final searchResult = <SearchFieldListItem<T>>[];
              if (query.isEmpty) {
                _createOverlay();
                suggestionStream.sink.add(widget.suggestions);
                return;
              }
              for (final suggestion in widget.suggestions) {
                if (suggestion.searchKey
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  searchResult.add(suggestion);
                }
              }
              suggestionStream.sink.add(searchResult);
            },
          ),
        ),
        if (!widget.hasOverlay)
          SizedBox(
            height: widget.offset != null ? widget.offset!.dy : 0,
          ),
        if (!widget.hasOverlay) _suggestionsBuilder()
      ],
    );
  }
}
