import 'package:flutter/material.dart';

class ScrollbarDecoration {
  /// The [OutlinedBorder] of the scrollbar's thumb.
  ///
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  /// it's simplest to just specify [radius]. By default, the scrollbar thumb's
  /// shape is a simple rectangle.
  OutlinedBorder? shape;

  /// The [Radius] of the scrollbar's thumb.
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  Radius? radius;

  /// The thickness of the scrollbar's thumb.
  double? thickness;

  /// Mustn't be null and the value has to be greater or equal to `minOverscrollLength`, which in
  /// turn is >= 0. Defaults to 18.0.
  double minThumbLength;

  /// The [Color] of the scrollbar's thumb.
  Color? thumbColor;

  /// The [Color] of the scrollbar's track.
  bool? trackVisibility;

  /// The [Radius] of the scrollbar's track.
  Radius? trackRadius;

  /// The [Color] of the scrollbar's track.
  Color? trackColor;

  /// The [Color] of the scrollbar's track border.
  Color? trackBorderColor;

  /// The [Duration] of the fade animation.
  Duration fadeDuration;

  /// Defines whether to show the scrollbar always or only when scrolling.
  /// defaults to `true`
  final bool? thumbVisibility;

  /// The [Duration] of time until the fade animation begins.
  /// Cannot be null, defaults to a [Duration] of 600 milliseconds.
  Duration timeToFade;

  /// The [Duration] of time that a LongPress will trigger the drag gesture of the scrollbar thumb.
  /// Cannot be null, defaults to [Duration.zero].
  Duration pressDuration;

  ScrollbarDecoration({
    this.minThumbLength = 18.0,
    this.thumbVisibility = true,
    this.radius,
    this.thickness,
    this.thumbColor,
    this.shape,
    this.trackVisibility,
    this.trackRadius,
    this.trackColor,
    this.trackBorderColor,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.pressDuration = const Duration(milliseconds: 100),
  });
}

class SuggestionDecoration extends BoxDecoration {
  /// padding around the suggestion list
  @override
  final EdgeInsetsGeometry padding;

  SuggestionDecoration({
    this.padding = EdgeInsets.zero,
    Color? color,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BoxShape shape = BoxShape.rectangle,
  }) : super(
            color: color,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
            gradient: gradient,
            shape: shape);
}
