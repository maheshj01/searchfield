import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

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
    super.prefixIconConstraints,
    super.hintMaxLines,
    super.floatingLabelStyle,
    super.errorText,
    super.error,
    super.hintTextDirection,
    super.hintFadeDuration,
    super.helper,
    super.prefixIcon,
    super.suffixIcon,
    super.suffix,
    super.label,
    @Deprecated(
      'Use maintainHintSize instead. '
      'This will maintain both hint height and hint width. '
      'This feature was deprecated after v1.26.0',
    )
    super.maintainHintHeight,
    super.maintainHintSize,
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
    super.hint,
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
    super.constraints,
    super.counter,
    super.semanticCounterText,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.errorMaxLines,
    super.errorStyle,
    super.suffixIconConstraints,
    super.visualDensity,
  });
  @override
  InputDecoration copyWith({
    Widget? icon,
    Color? iconColor,
    Widget? label,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    Widget? helper,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    Widget? hint,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    Duration? hintFadeDuration,
    int? hintMaxLines,
    bool? maintainHintHeight,
    bool? maintainHintSize,
    bool? maintainLabelSize,
    Widget? error,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    bool? isCollapsed,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? prefix,
    String? prefixText,
    BoxConstraints? prefixIconConstraints,
    TextStyle? prefixStyle,
    Color? prefixIconColor,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool? enabled,
    String? semanticCounterText,
    bool? alignLabelWithHint,
    BoxConstraints? constraints,
    VisualDensity? visualDensity,
    SemanticsService? semanticsService,
  }) {
    return SearchInputDecoration(
      key: key ?? this.key,
      maintainHintHeight: maintainHintHeight ?? this.maintainHintHeight,
      maintainHintSize: maintainHintSize ?? this.maintainHintSize,
      cursorColor: cursorColor,
      textCapitalization: textCapitalization,
      searchStyle: searchStyle ?? this.searchStyle,
      prefixIconConstraints:
          prefixIconConstraints ?? this.prefixIconConstraints,
      suffixIconConstraints:
          suffixIconConstraints ?? this.suffixIconConstraints,
      hintMaxLines: hintMaxLines ?? this.hintMaxLines,
      floatingLabelStyle: floatingLabelStyle ?? this.floatingLabelStyle,
      errorText: errorText ?? this.errorText,
      error: error ?? this.error,
      hintTextDirection: hintTextDirection ?? this.hintTextDirection,
      hint: hint ?? this.hint,
      hintFadeDuration: hintFadeDuration ?? this.hintFadeDuration,
      helper: helper ?? this.helper,
      cursorErrorColor: cursorErrorColor ?? this.cursorErrorColor,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? this.cursorOpacityAnimates,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      alignLabelWithHint: alignLabelWithHint ?? this.alignLabelWithHint,
      border: border ?? this.border,
      constraints: constraints ?? this.constraints,
      contentPadding: contentPadding ?? this.contentPadding,
      counter: counter ?? this.counter,
      counterStyle: counterStyle ?? this.counterStyle,
      counterText: counterText ?? this.counterText,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      errorMaxLines: errorMaxLines ?? this.errorMaxLines,
      errorStyle: errorStyle ?? this.errorStyle,
      fillColor: fillColor ?? this.fillColor,
      filled: filled ?? this.filled,
      floatingLabelAlignment:
          floatingLabelAlignment ?? this.floatingLabelAlignment,
      floatingLabelBehavior:
          floatingLabelBehavior ?? this.floatingLabelBehavior,
      focusColor: focusColor ?? this.focusColor,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      focusedErrorBorder: focusedErrorBorder ?? this.focusedErrorBorder,
      helperMaxLines: helperMaxLines ?? this.helperMaxLines,
      helperStyle: helperStyle ?? this.helperStyle,
      helperText: helperText ?? this.helperText,
      hintStyle: hintStyle ?? this.hintStyle,
      hintText: hintText ?? this.hintText,
      hoverColor: hoverColor ?? this.hoverColor,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isDense: isDense ?? this.isDense,
      label: label ?? this.label,
      labelStyle: labelStyle ?? this.labelStyle,
      labelText: labelText ?? this.labelText,
      prefix: prefix ?? this.prefix,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefixIconColor: prefixIconColor ?? this.prefixIconColor,
      prefixStyle: prefixStyle ?? this.prefixStyle,
      prefixText: prefixText ?? this.prefixText,
      semanticCounterText: semanticCounterText ?? this.semanticCounterText,
      suffix: suffix ?? this.suffix,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      suffixIconColor: suffixIconColor ?? this.suffixIconColor,
      suffixStyle: suffixStyle ?? this.suffixStyle,
      suffixText: suffixText ?? this.suffixText,
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }
}
