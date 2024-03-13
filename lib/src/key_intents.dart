import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class KCallbackAction<T extends Intent> extends CallbackAction<T> {
  KCallbackAction({required void Function(T) onInvoke})
      : super(onInvoke: onInvoke);
}

class NextIntent extends Intent {
  final bool isTabKey;
  const NextIntent(this.isTabKey);
}

// action to move to the next suggestion
class PreviousIntent extends Intent {
  final bool isTabKey;
  const PreviousIntent(this.isTabKey);
}

// action to select the suggestion
class SelectionIntent<T> extends Intent {
  final SearchFieldListItem<T> selectedItem;
  const SelectionIntent(this.selectedItem);
}

// action to hide the suggestions
class UnFocusIntent extends Intent {
  const UnFocusIntent();
}
