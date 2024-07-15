import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:searchfield/searchfield.dart';

class SFListview<T> extends StatefulWidget {
  final ScrollController? scrollController;
  final SuggestionDirection suggestionDirection;
  final int? selected;

  /// height limit for the box (dynamic height)
  final double? maxHeight;

  final Function(PointerDownEvent)? onTapOutside;
  final List<SearchFieldListItem<T>> list;
  final SuggestionDecoration? suggestionsDecoration;
  final Function(SearchFieldListItem<T>) onSuggestionTapped;
  final BoxDecoration? suggestionItemDecoration;
  final Color? marginColor;
  final TextStyle? suggestionStyle;
  final Function(double, double)? onScroll;
  SFListview(
      {super.key,
      this.maxHeight,
      required this.scrollController,
      required this.selected,
      required this.list,
      required this.onTapOutside,
      required this.suggestionsDecoration,
      required this.suggestionItemDecoration,
      required this.onSuggestionTapped,
      this.onScroll,
      this.suggestionStyle,
      this.marginColor,
      this.suggestionDirection = SuggestionDirection.down});

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
            itemBuilder: (context, index) => Builder(builder: (context) {
              if (widget.selected == index) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(context,
                      alignment: 0.1, duration: Duration(milliseconds: 300));
                });
              }
              return TextFieldTapRegion(
                  onTapOutside: (x) {
                    widget.onTapOutside!(x);
                  },
                  child: Material(
                    color: widget.suggestionsDecoration == null
                        ? Theme.of(context).colorScheme.surface
                        : Colors.transparent,
                    child: InkWell(
                      hoverColor: widget.suggestionsDecoration?.hoverColor ??
                          Theme.of(context).hoverColor,
                      onTap: () =>
                          widget.onSuggestionTapped(widget.list[index]),
                      child: Container(
                        key: widget.list[index].key,
                        width: double.infinity,
                        decoration: widget.suggestionItemDecoration?.copyWith(
                              color: widget.selected == index
                                  ? widget.suggestionsDecoration
                                          ?.selectionColor ??
                                      Theme.of(context).highlightColor
                                  : null,
                              border: widget.suggestionItemDecoration?.border ??
                                  Border(
                                    bottom: BorderSide(
                                      color: widget.marginColor ??
                                          onSurfaceColor.withOpacity(0.1),
                                    ),
                                  ),
                            ) ??
                            BoxDecoration(
                              color: widget.selected == index
                                  ? widget.suggestionsDecoration
                                          ?.selectionColor ??
                                      Theme.of(context).highlightColor
                                  : null,
                              border: index == widget.list.length - 1
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                        color: widget.marginColor ??
                                            onSurfaceColor.withOpacity(0.1),
                                      ),
                                    ),
                            ),
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
                    ),
                  ));
            }),
          ),
        ),
      ),
    );
  }
}
