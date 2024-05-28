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

  /// Dictates the orientation of the scrollbar.
  ///
  /// [ScrollbarOrientation.top] places the scrollbar on top of the screen. [ScrollbarOrientation
  /// bottom] places the scrollbar on the bottom of the screen. [ScrollbarOrientation.left] places
  /// the scrollbar on the left of the screen. [ScrollbarOrientation.right] places the scrollbar on
  /// the right of the screen.
  ///
  /// [ScrollbarOrientation.top] and [ScrollbarOrientation.bottom] can only be used with a vertical
  /// scroll. [ScrollbarOrientation.left] and [ScrollbarOrientation.right] can only be used with a
  /// horizontal scroll.
  ///
  /// For a vertical scroll the orientation defaults to [ScrollbarOrientation.right] for
  /// [TextDirection.ltr] and [ScrollbarOrientation.left] for [TextDirection.rtl]. For a horizontal
  /// scroll the orientation defaults to [ScrollbarOrientation.bottom].

  ScrollbarOrientation orientation;

  /// Whether the Scrollbar should be interactive and respond to dragging on the thumb, or tapping in the track area.
  /// Defaults to true when null, unless on Android, which will default to false when null.
  bool? interactive;

  /// Distance from the scrollbar thumb's side to the nearest cross axis edge in logical pixels.
  ///
  /// The scrollbar track consumes this space.
  ///
  /// Defaults to zero.
  double? crossAxisMargin;

  ScrollbarDecoration({
    this.minThumbLength = 18.0,
    this.thumbVisibility = true,
    this.radius,
    this.thickness,
    this.thumbColor,
    this.shape,
    this.orientation = ScrollbarOrientation.right,
    this.trackVisibility,
    this.trackRadius,
    this.crossAxisMargin = 0,
    this.trackColor,
    this.interactive = true,
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
  // color when the suggestion is hovered
  // defaults to Theme.of(context).hoverColor
  final Color? hoverColor;
  // color of the selected suggestion
  // defaults to Theme.of(context).highlightColor
  final Color? selectionColor;

  /// The elevation of the suggestion list
  /// defaults to 2.0
  final double? elevation;

  /// The shadow color of the suggestion list
  final Color? shadowColor;

  /// The width of the suggestion menu from left to right
  final double? width;

  SuggestionDecoration({
    this.padding = EdgeInsets.zero,
    Color? color,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    this.width,
    this.elevation,
    this.hoverColor,
    this.shadowColor,
    this.selectionColor,
    BoxShape shape = BoxShape.rectangle,
  }) : super(
            color: color,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
            gradient: gradient,
            shape: shape);
}

const kDefaultShapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
  bottomLeft: Radius.circular(4),
  bottomRight: Radius.circular(4),
));

const kDefaultElevation = 2.0;
