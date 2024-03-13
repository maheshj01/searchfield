import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:searchfield/searchfield.dart';

class SFListview<T> extends StatelessWidget {
  final ScrollController scrollController;
  final SuggestionDirection suggestionDirection;
  final int? selected;
  final Function(PointerDownEvent)? onTapOutside;
  final List<SearchFieldListItem<T>> list;
  final SuggestionDecoration? suggestionsDecoration;
  final Function(SearchFieldListItem<T>) onSuggestionTapped;
  final BoxDecoration? suggestionItemDecoration;
  final Color? marginColor;
  final TextStyle? suggestionStyle;
  SFListview(
      {super.key,
      required this.scrollController,
      required this.selected,
      required this.list,
      required this.onTapOutside,
      required this.suggestionsDecoration,
      required this.suggestionItemDecoration,
      required this.onSuggestionTapped,
      this.suggestionStyle,
      this.marginColor,
      this.suggestionDirection = SuggestionDirection.down});

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return ClipRRect(
      borderRadius: suggestionsDecoration?.borderRadius ??
          kDefaultShapeBorder.borderRadius,
      child: Container(
        decoration: suggestionsDecoration ??
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
        child: ListView.builder(
          reverse: suggestionDirection == SuggestionDirection.up,
          padding: EdgeInsets.zero,
          controller: scrollController,
          itemCount: list.length,
          physics: list.length == 1
              ? NeverScrollableScrollPhysics()
              : ScrollPhysics(),
          itemBuilder: (context, index) => Builder(builder: (context) {
            if (selected == index) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(context,
                    alignment: 0.1, duration: Duration(milliseconds: 300));
              });
            }
            return TextFieldTapRegion(
                onTapOutside: (x) {
                  onTapOutside!(x);
                },
                child: Material(
                  color: suggestionsDecoration == null
                      ? Theme.of(context).colorScheme.surface
                      : Colors.transparent,
                  child: InkWell(
                    hoverColor: suggestionsDecoration?.hoverColor ??
                        Theme.of(context).hoverColor,
                    onTap: () => onSuggestionTapped(list[index]),
                    child: Container(
                      key: list[index].key,
                      width: double.infinity,
                      decoration: suggestionItemDecoration?.copyWith(
                            color: selected == index
                                ? suggestionsDecoration?.selectionColor ??
                                    Theme.of(context).highlightColor
                                : null,
                            border: suggestionItemDecoration?.border ??
                                Border(
                                  bottom: BorderSide(
                                    color: marginColor ??
                                        onSurfaceColor.withOpacity(0.1),
                                  ),
                                ),
                          ) ??
                          BoxDecoration(
                            color: selected == index
                                ? suggestionsDecoration?.selectionColor ??
                                    Theme.of(context).highlightColor
                                : null,
                            border: index == list.length - 1
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: marginColor ??
                                          onSurfaceColor.withOpacity(0.1),
                                    ),
                                  ),
                          ),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: list[index].child ??
                                Text(
                                  list[index].searchKey,
                                  style: suggestionStyle,
                                ),
                          )),
                    ),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
