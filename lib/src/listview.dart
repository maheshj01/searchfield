import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:searchfield/searchfield.dart';

class SFListview<T> extends StatefulWidget {
  final ScrollController? scrollController;
  final SuggestionDirection suggestionDirection;
  final int? selected;

  /// height limit for the box (dynamic height)
  final double? maxHeight;
  final bool dynamicHeight;

  final Function(PointerDownEvent)? onTapOutside;
  final List<SearchFieldListItem<T>> list;
  final SuggestionDecoration? suggestionsDecoration;
  final Function(SearchFieldListItem<T> item, int index) onSuggestionTapped;
  final BoxDecoration? suggestionItemDecoration;
  final Color? marginColor;
  final double itemHeight;
  final int maxSuggestionsInViewPort;
  final TextStyle? suggestionStyle;
  final Function(double, double)? onScroll;
  SFListview(
      {super.key,
      this.maxHeight,
      required this.scrollController,
      required this.selected,
      required this.list,
      required this.itemHeight,
      required this.onTapOutside,
      required this.suggestionsDecoration,
      required this.suggestionItemDecoration,
      required this.maxSuggestionsInViewPort,
      required this.onSuggestionTapped,
      this.onScroll,
      this.suggestionStyle,
      this.marginColor,
      this.suggestionDirection = SuggestionDirection.down,
      required this.dynamicHeight});

  @override
  State<SFListview<T>> createState() => _SFListviewState<T>();
}

class _SFListviewState<T> extends State<SFListview<T>> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    listenToScrollEvents();
    if (widget.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollController.hasClients) {
          // if selected item is in last maxSuggestionsInViewPort items
          if (widget.selected! > (widget.maxSuggestionsInViewPort ~/ 2)) {
            if ((widget.list.length - widget.selected!) <
                widget.maxSuggestionsInViewPort) {
              // scroll to bottom
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
                // duration: Duration(milliseconds: 300),
                // curve: Curves.fastOutSlowIn
              );
            } else {
              // scroll to keep the selected item in center of the list viewport
              _scrollController.jumpTo(
                (widget.selected! - widget.maxSuggestionsInViewPort / 2) *
                    widget.itemHeight,
                // duration: Duration(milliseconds: 300),
                // curve: Curves.fastOutSlowIn
              );
            }
          }
        }
      });
    }
  }

  void listenToScrollEvents() {
    if (widget.onScroll != null) {
      _scrollController.addListener(() {
        widget.onScroll!(_scrollController.position.pixels,
            _scrollController.position.maxScrollExtent);
      });
    } else {
      _scrollController.removeListener(() {});
    }
  }

  @override
  void didUpdateWidget(covariant SFListview<T> oldWidget) {
    if (oldWidget.onScroll != widget.onScroll) {
      listenToScrollEvents();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    BoxDecoration _getDecoration(int index) {
      return widget.suggestionItemDecoration?.copyWith(
            color: widget.selected == index
                ? widget.suggestionsDecoration?.selectionColor ??
                    Theme.of(context).highlightColor
                : null,
            border: widget.suggestionItemDecoration?.border ??
                Border(
                  bottom: BorderSide(
                    color:
                        widget.marginColor ?? onSurfaceColor.withOpacity(0.1),
                  ),
                ),
          ) ??
          BoxDecoration(
            color: widget.selected == index
                ? widget.suggestionsDecoration?.selectionColor ??
                    Theme.of(context).highlightColor
                : null,
            border: index == widget.list.length - 1
                ? null
                : Border(
                    bottom: BorderSide(
                      color:
                          widget.marginColor ?? onSurfaceColor.withOpacity(0.1),
                    ),
                  ),
          );
    }

    return ClipRRect(
      borderRadius: widget.suggestionsDecoration?.borderRadius ??
          kDefaultShapeBorder.borderRadius,
      child: Container(
        decoration: widget.suggestionsDecoration ??
            SuggestionDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: onSurfaceColor.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: onSurfaceColor.withOpacity(0.1),
                  blurRadius: 8.0, // soften the shadow
                  spreadRadius: 2.0, //extend the shadow
                  offset: Offset(
                    2.0,
                    5.0,
                  ),
                ),
              ],
            ),
        child: LimitedBox(
          maxHeight: widget.maxHeight ?? double.infinity,
          child: ListView.builder(
              shrinkWrap: widget.maxHeight != null,
              reverse: widget.suggestionDirection == SuggestionDirection.up,
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemCount: widget.list.length,
              physics: widget.list.length == 1
                  ? NeverScrollableScrollPhysics()
                  : ScrollPhysics(),
              itemBuilder: (context, index) {
                return KeepAliveListItem(child: Builder(
                  builder: (context) {
                    if (widget.selected == index) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((Duration timeStamp) {
                        if (mounted) {
                          try {
                            Scrollable.ensureVisible(context,
                                alignment: 0.1,
                                duration: Duration(milliseconds: 300));
                          } catch (e) {
                            log('Error scrolling to selected item: $e');
                          }
                        }
                      });
                    }

                    final child = TextFieldTapRegion(
                        onTapOutside: (x) {
                          widget.onTapOutside!(x);
                        },
                        child: Material(
                            color: widget.suggestionsDecoration == null
                                ? Theme.of(context).colorScheme.surface
                                : Colors.transparent,
                            child: InkWell(
                              hoverColor:
                                  widget.suggestionsDecoration?.hoverColor ??
                                      Theme.of(context).hoverColor,
                              onTap: () => widget.onSuggestionTapped(
                                  widget.list[index], index),
                              child: Container(
                                height: widget.dynamicHeight
                                    ? null
                                    : widget.itemHeight,
                                key: widget.list[index].key,
                                width: double.infinity,
                                decoration: _getDecoration(index),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: widget.list[index].child ??
                                          Text(
                                            widget.list[index].searchKey,
                                            style: widget.suggestionStyle,
                                          ),
                                    )),
                              ),
                            )));
                    return child;
                  },
                ));
              }),
        ),
      ),
    );
  }
}

class KeepAliveListItem extends StatefulWidget {
  final Widget child;

  KeepAliveListItem({required this.child});

  @override
  _KeepAliveListItemState createState() => _KeepAliveListItemState();
}

class _KeepAliveListItemState extends State<KeepAliveListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
