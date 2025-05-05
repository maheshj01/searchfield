import 'package:flutter/material.dart';

class SearchFieldListItem<T> {
  Key? key;

  /// the text based on which the search happens
  final String searchKey;

  /// Custom Object to be associated with each ListItem
  /// For Suggestions with Custom Objects, pass [item] parameter to [SearchFieldListItem]
  /// see example in [example/lib/country_search.dart](https://github.com/maheshj01/searchfield/tree/master/example/lib/country_search.dart)
  final T? item;

  /// The value to set in the searchField when the suggestion is selected
  /// if not specified, the [searchKey] will be used
  final String? value;

  /// The widget to be shown in the searchField suggestion list
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

  /// The widget to be shown in the suggestion list
  /// if not specified, Text widget with default styling will be used
  /// to show a custom widget, use [child] instead
  /// see example in [example/lib/country_search.dart]()
  SearchFieldListItem(this.searchKey,
      {this.child, this.item, this.key, this.value = ''});

  SearchFieldListItem<T> copyWith({
    String? searchKey,
    T? item,
    String? value,
    Widget? child,
  }) {
    return SearchFieldListItem<T>(
      searchKey ?? this.searchKey,
      item: item ?? this.item,
      value: value ?? this.value,
      child: child ?? this.child,
    );
  }

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
