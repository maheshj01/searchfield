import 'package:flutter/material.dart';

class KCallbackAction<T extends Intent> extends CallbackAction<T> {
  KCallbackAction({required void Function(T) onInvoke})
      : super(onInvoke: onInvoke);
}

class NextIntent extends Intent {
  const NextIntent();
}

// action to move to the next suggestion
class PreviousIntent extends Intent {
  const PreviousIntent();
}

// action to select the suggestion
class SelectionIntent extends Intent {
  const SelectionIntent();
}

// action to hide the suggestions
class UnFocusIntent extends Intent {
  const UnFocusIntent();
}
