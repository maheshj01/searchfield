import 'package:flutter/material.dart';

class SearchInputDecoration extends InputDecoration {
  /// text capitalization defaults to [TextCapitalization.none]
  final TextCapitalization textCapitalization;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// The color of the cursor.
  /// The cursor indicates the current location of text insertion point in the field.
  /// If this is null it will default to the ambient DefaultSelectionStyle.cursorColor. If that is
  /// null, and the ThemeData.platform is TargetPlatform.iOS or TargetPlatform.macOS it will use
  /// CupertinoThemeData.primaryColor. Otherwise it will use the value of ColorScheme.primary of
  /// ThemeData.colorScheme.
  ///
  final Color cursorColor;

  ///Creates a [FormField] that contains a [TextField].

  /// The color of the cursor when the InputDecorator is showing an error.
  ///
  /// If this is null it will default to TextStyle.color of InputDecoration.errorStyle. If that is
  /// null, it will use ColorScheme.error of ThemeData.colorScheme.
  ///
  final Color? cursorErrorColor;

  /// How tall the cursor will be.
  ///
  /// If this property is null, RenderEditable.preferredLineHeight will be used.
  final double? cursorHeight;

  /// How thick the cursor will be.
  /// Defaults to 2.0.
  /// The cursor will draw under the text. The cursor width will extend to the right of the
  /// boundary between characters for left-to-right text and to the left for right-to-left text.
  /// This corresponds to extending downstream relative to the selected position. Negative values
  /// may be used to reverse this behavior.
  ///
  final double? cursorWidth;

  /// Whether the cursor will animate from fully transparent to fully opaque during each cursor
  /// blink.
  /// By default, the cursor opacity will animate on iOS platforms and will not animate on Android /
  /// platforms.
  ///
  final bool? cursorOpacityAnimates;

  /// The radius of the cursor.How rounded the corners of the cursor should be.
  /// By default, the cursor has no radius.
  ///
  final Radius? cursorRadius;

  /// The appearance of the keyboard.
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to ThemeData.brightness.
  ///
  final Brightness? keyboardAppearance;

  final Key? key;
  SearchInputDecoration({
    this.key,
    this.cursorColor = Colors.black,
    this.textCapitalization = TextCapitalization.none,
    this.searchStyle,
    this.cursorErrorColor,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.cursorOpacityAnimates,
    this.cursorRadius,
    this.keyboardAppearance,
    super.border,
    super.prefixIcon,
    super.suffixIcon,
    super.suffix,
    super.label,
    super.suffixIconColor,
    super.prefix,
    super.prefixIconColor,
    super.enabledBorder,
    super.focusedBorder,
    super.errorBorder,
    super.focusedErrorBorder,
    super.disabledBorder,
    super.contentPadding,
    super.hintText,
    super.hintStyle,
    super.labelText,
    super.labelStyle,
    super.prefixText,
    super.prefixStyle,
    super.suffixText,
    super.suffixStyle,
    super.counterText,
    super.counterStyle,
    super.filled,
    super.fillColor,
    super.focusColor,
    super.hoverColor,
    super.icon,
    super.iconColor,
    super.isCollapsed,
    super.isDense,
    super.floatingLabelBehavior,
    super.floatingLabelAlignment,
    super.alignLabelWithHint,
    super.enabled,
    super.constraints,
    super.counter,
    super.semanticCounterText,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.errorMaxLines,
    super.errorStyle,
  });
}
