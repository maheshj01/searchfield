import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchfield/src/decoration.dart';
import 'package:searchfield/src/key_intents.dart';
import 'package:searchfield/src/listview.dart';

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
  /// duration of the suggestion list animation
  final Duration animationDuration;

  /// focus node for the searchfield
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

  /// Defines character limit for searchfield
  final int? maxLength;

  /// Defines mechanisms for enforcing maximum length limits
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// If buildCounter returns null, then no counter and no Semantics widget will
  /// be created at all.
  final InputCounterWidgetBuilder? buildCounter;

  /// Used to enable/disable this form field auto validation and update its error text.

  /// If AutovalidateMode.onUserInteraction, this FormField will only auto-validate after its
  /// content changes. If AutovalidateMode.always, it will auto-validate even without user
  /// interaction. If AutovalidateMode.disabled, auto-validation will be disabled.
  ///
  /// Defaults to AutovalidateMode.disabled.
  final AutovalidateMode? autovalidateMode;

  /// Callback when the Searchfield is submitted by pressing
  /// the enter key on the keyboard
  /// This callback returns the text from the searchfield
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

  /// Specifies [TextStyle] for suggestions when no child is provided
  /// in [SearchFieldListItem].
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

  /// Callback when the suggestions are scrolled
  /// The callback returns the `current scroll position` in pixels and the `maximum scroll extent`
  /// of the suggestions list. The callback can be used to implement feature like
  /// lazy loading of suggestions.
  /// see example in [example/lib/pagination](https://github.com/maheshmnj/searchfield/blob/master/example/lib/pagination.dart) to see it in action
  final void Function(double, double)? onScroll;

  /// Callback when the searchfield is tapped
  /// or brought into focus
  final void Function()? onTap;

  // boolean to hide/show empty widget
  // defaults to false
  final bool showEmpty;

  /// Widget to show when the search returns
  /// empty results or when showEmpty: true.
  /// defaults to [SizedBox.shrink]
  final Widget emptyWidget;

  /// Defines whether to enable autoCorrect defaults to `true`
  final bool autoCorrect;

  /// alignment of the text in the searchfield
  /// defaults to [TextAlign.start]
  final TextAlign textAlign;

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

  SearchField({
    Key? key,
    required this.suggestions,
    this.animationDuration = const Duration(milliseconds: 300),
    this.autoCorrect = true,
    this.autofocus = false,
    this.autovalidateMode,
    this.controller,
    this.emptyWidget = const SizedBox(),
    this.enabled,
    this.focusNode,
    this.hint,
    this.initialValue,
    this.inputFormatters,
    this.inputType,
    this.itemHeight = 35.0,
    this.marginColor,
    this.maxSuggestionsInViewPort = 5,
    this.maxLength,
    this.maxLengthEnforcement,
    this.buildCounter,
    this.readOnly = false,
    this.onSearchTextChanged,
    this.onSaved,
    this.onScroll,
    this.onTap,
    this.onSubmit,
    this.onTapOutside,
    this.offset,
    this.onSuggestionTap,
    this.searchInputDecoration,
    this.searchStyle,
    this.scrollbarDecoration,
    this.showEmpty = false,
    this.suggestionStyle,
    this.suggestionsDecoration,
    this.suggestionDirection = SuggestionDirection.down,
    this.suggestionState = Suggestion.expand,
    this.suggestionItemDecoration,
    this.suggestionAction,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
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
  FocusNode? _searchFocus;
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
      _searchFocus!.dispose();
    }
    removeOverlay();
    super.dispose();
  }

  void removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      isSuggestionsShown = false;
      _overlayEntry?.remove();
    }
  }

  void initialize() {
    if (widget.scrollbarDecoration == null) {
      _scrollbarDecoration = ScrollbarDecoration();
    } else {
      _scrollbarDecoration = widget.scrollbarDecoration;
    }
    if (widget.focusNode != null) {
      _searchFocus = widget.focusNode;
    } else {
      _searchFocus = FocusNode();
    }
    _searchFocus!.addListener(() {
      // When focus shifts to ListView prevent suggestions from rebuilding
      // when user navigates through suggestions using keyboard
      if (_searchFocus!.hasFocus) {
        _overlayEntry ??= _createOverlay();
        if (widget.suggestionState == Suggestion.expand) {
          isSuggestionsShown = true;
          Future.delayed(Duration(milliseconds: 100), () {
            suggestionStream.sink.add(widget.suggestions);
          });
        }
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        removeOverlay();
        if (searchController!.text.isEmpty) {
          selected = null;
        }
        suggestionStream.sink.add(null);
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

  int? selected = null;
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    length = widget.suggestions.length;
    _previousAction =
        KCallbackAction<PreviousIntent>(onInvoke: handlePreviousKeyPress);
    _nextAction = KCallbackAction<NextIntent>(onInvoke: handleNextKeyPress);
    _selectAction =
        KCallbackAction<SelectionIntent<T>>(onInvoke: handleSelectKeyPress);
    _unFocusAction =
        KCallbackAction<UnFocusIntent>(onInvoke: handleUnFocusKeyPress);
    _scrollController = ScrollController();
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
          selected = widget.suggestions
              .indexWhere((element) => element == widget.initialValue);
          searchController!.text = widget.initialValue!.searchKey;
          suggestionStream.sink.add([widget.initialValue]);
        }
      }
    });
  }

  void handlePreviousKeyPress(PreviousIntent intent) {
    if (intent.scrollToTop == true) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      selected = 0;
      _overlayEntry!.markNeedsBuild();
      return;
    }
    if (selected == null) {
      if (intent.isTabKey) {
        _searchFocus!.previousFocus();
      }
      return;
    }
    if (selected! > 0) {
      selected = selected! - 1;
    } else {
      selected = length - 1;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
    _overlayEntry!.markNeedsBuild();
  }

  void handleNextKeyPress(NextIntent intent) {
    if (intent.scrollToBottom == true) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      selected = length - 1;
      _overlayEntry!.markNeedsBuild();
      return;
    }
    if (selected == null) {
      // focus to next focus node
      if (intent.isTabKey && !isSuggestionsShown) {
        _searchFocus!.nextFocus();
        return;
      }
      selected = 0;
      _overlayEntry!.markNeedsBuild();
      return;
    }
    selected = (selected! + 1) % length;
    if (selected == 0) {
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
    _overlayEntry!.markNeedsBuild();
  }

  // This is not invoked since enter key is reserved
  // for onSubmitted callback of the textfield
  void handleSelectKeyPress(SelectionIntent<T> intent) {
    if (selected == null) return;
    _searchFocus!.unfocus();
    if (intent.selectedItem != null) {
      onSuggestionTapped(intent.selectedItem!);
    } else {
      onSuggestionTapped(widget.suggestions[selected!]);
    }
  }

  void handleUnFocusKeyPress(UnFocusIntent intent) {
    _searchFocus!.unfocus();
    selected = null;
    _overlayEntry!.markNeedsBuild();
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
      length = widget.suggestions.length;
      suggestionStream.sink.add(widget.suggestions);
    }
    if (oldWidget.scrollbarDecoration != widget.scrollbarDecoration) {
      if (widget.scrollbarDecoration == null) {
        _scrollbarDecoration = ScrollbarDecoration();
      } else {
        _scrollbarDecoration = widget.scrollbarDecoration;
      }
    }
    if (oldWidget.initialValue != widget.initialValue) {
      selected = widget.suggestions
          .indexWhere((element) => element == widget.initialValue);
    }

    super.didUpdateWidget(oldWidget);
  }

  void onSuggestionTapped(SearchFieldListItem<T> item) {
    {
      searchController!.text = item.searchKey;
      searchController!.selection = TextSelection.fromPosition(
        TextPosition(
          offset: searchController!.text.length,
        ),
      );

      // suggestion action to switch focus to next focus node
      if (widget.suggestionAction != null) {
        if (widget.suggestionAction == SuggestionAction.next) {
          _searchFocus!.nextFocus();
        } else if (widget.suggestionAction == SuggestionAction.unfocus) {
          _searchFocus!.unfocus();
        }
      }

      // hide the suggestions
      suggestionStream.sink.add(null);
      if (widget.onSuggestionTap != null) {
        widget.onSuggestionTap!(item);
      }
    }
  }

  int? selectedIndex;
  bool isSuggestionsShown = false;

  /// length of the suggestions
  int length = 0;
  double scrolloffset = 0.0;
  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchFieldListItem<T>?>?>(
      stream: suggestionStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SearchFieldListItem<T>?>?> snapshot) {
        bool isEmpty = false;
        if (snapshot.data == null || !_searchFocus!.hasFocus) {
          isSuggestionsShown = false;
          return SizedBox();
        } else if (snapshot.data!.isEmpty || widget.showEmpty) {
          isEmpty = true;
          _totalHeight = 0;
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
        }
        if (isEmpty) {
          selected = null;
        }
        isSuggestionsShown = true;
        final listView = AnimatedContainer(
          duration: _suggestionDirection == SuggestionDirection.up
              ? Duration.zero
              : widget.animationDuration,
          height: _totalHeight,
          alignment: Alignment.centerLeft,
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
            interactive: _scrollbarDecoration!.interactive,
            scrollbarOrientation: _scrollbarDecoration!.orientation,
            crossAxisMargin: _scrollbarDecoration!.crossAxisMargin!,
            child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SFListview<T>(
                  suggestionStyle: widget.suggestionStyle,
                  scrollController: _scrollController,
                  selected: selected,
                  suggestionDirection: _suggestionDirection,
                  onScroll: widget.onScroll,
                  onTapOutside: (x) {
                    if (widget.onTapOutside != null) {
                      widget.onTapOutside!(x);
                    }
                  },
                  onSuggestionTapped: onSuggestionTapped,
                  suggestionItemDecoration: widget.suggestionItemDecoration,
                  suggestionsDecoration: widget.suggestionsDecoration,
                  marginColor: widget.marginColor,
                  list: snapshot.data! as List<SearchFieldListItem<T>>,
                )),
          ),
        );
        return TextFieldTapRegion(
          onTapOutside: (x) {
            isSuggestionInFocus = false;
            if (!_searchFocus!.hasFocus) {
              removeOverlay();
            }
          },
          onTapInside: (x) {
            isSuggestionInFocus = true;
          },
          child: IndexedStack(
            index: isEmpty ? 0 : 1,
            children: [widget.emptyWidget, listView],
          ),
        );
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
              width: widget.suggestionsDecoration?.width ?? textFieldsize.width,
              child: CompositedTransformFollower(
                offset: widget.offset ?? yOffset,
                link: _layerLink,
                child: Material(
                  borderRadius: widget.suggestionsDecoration?.borderRadius ??
                      BorderRadius.zero,
                  shadowColor: widget.suggestionsDecoration?.shadowColor,
                  elevation: widget.suggestionsDecoration?.elevation ??
                      kDefaultElevation,
                  child: _suggestionsBuilder(),
                ),
              ),
            );
          });
    });
  }

  late Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    NextIntent: _nextAction,
    PreviousIntent: _previousAction,
    SelectionIntent: _selectAction,
    UnFocusIntent: _unFocusAction,
  };

  late SuggestionDirection _suggestionDirection;
  final LayerLink _layerLink = LayerLink();

  /// Defines if user is interacting with suggestions
  /// This is used to decide if user has focus on Searchfield
  /// by pairing it with `_searchFocus.hasFocus`
  bool isSuggestionInFocus = false;

  /// height of suggestions overlay
  late double _totalHeight;
  GlobalKey key = GlobalKey();
  late final ScrollController _scrollController;
  late final KCallbackAction<PreviousIntent> _previousAction;
  late final KCallbackAction<NextIntent> _nextAction;
  late final KCallbackAction<SelectionIntent<T>> _selectAction;
  late final KCallbackAction<UnFocusIntent> _unFocusAction;
  final lastSearchResult = <SearchFieldListItem<T>>[];
  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      _totalHeight = widget.suggestions.length * widget.itemHeight;
    }
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          // LogicalKeySet(LogicalKeyboardKey.tab): const NextIntent(true),
          LogicalKeySet(LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.altLeft):
              const PreviousIntent(false, scrollToTop: true),
          LogicalKeySet(
                  LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.altLeft):
              const NextIntent(false, scrollToBottom: true),
          LogicalKeySet(LogicalKeyboardKey.tab, LogicalKeyboardKey.shiftLeft):
              const PreviousIntent(true),
          LogicalKeySet(LogicalKeyboardKey.escape): const UnFocusIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const NextIntent(false),
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              const PreviousIntent(false),
          LogicalKeySet(LogicalKeyboardKey.enter):
              SelectionIntent<T>(widget.initialValue),
        },
        child: Actions(
          actions: actions,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: TextFormField(
              key: key,
              enabled: widget.enabled,
              textAlign: widget.textAlign,
              autofocus: widget.autofocus,
              autocorrect: widget.autoCorrect,
              readOnly: widget.readOnly,
              autovalidateMode: widget.autovalidateMode,
              onFieldSubmitted: (x) {
                if (selected != null) {
                  if (lastSearchResult.isNotEmpty) {
                    handleSelectKeyPress(
                        SelectionIntent(lastSearchResult[selected!]));
                  } else {
                    handleSelectKeyPress(
                        SelectionIntent(widget.suggestions[selected!]));
                  }
                }
                if (widget.onSubmit != null) widget.onSubmit!(x);
              },
              onTap: () {
                widget.onTap?.call();
              },
              onSaved: (x) {
                if (widget.onSaved != null) widget.onSaved!(x);
              },
              maxLength: widget.maxLength,
              maxLengthEnforcement: widget.maxLengthEnforcement,
              buildCounter: widget.buildCounter,
              inputFormatters: widget.inputFormatters,
              controller: searchController,
              focusNode: _searchFocus,
              validator: widget.validator,
              style: widget.searchStyle,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              keyboardType: widget.inputType,
              decoration: widget.searchInputDecoration
                      ?.copyWith(hintText: widget.hint) ??
                  InputDecoration(hintText: widget.hint),
              onChanged: (query) {
                var searchResult = <SearchFieldListItem<T>>[];
                if (widget.onSearchTextChanged != null) {
                  searchResult = widget.onSearchTextChanged!(query) ?? [];
                } else {
                  if (query.isEmpty) {
                    lastSearchResult.clear();
                    lastSearchResult.addAll(searchResult);
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
                }
                lastSearchResult.clear();
                lastSearchResult.addAll(searchResult);
                suggestionStream.sink.add(searchResult);
              },
            ),
          ),
        ));
  }
}
