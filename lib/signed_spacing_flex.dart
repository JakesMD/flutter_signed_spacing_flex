library signed_spacing_flex;

/*
This is a modified version of Flutter's [flutter/packages/flutter/lib/src/widgets/basic.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/basic.dart) file.
I am not the original author of this code.
*/

/*
Copyright 2014 The Flutter Authors. All rights reserved.
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Google Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'render_signed_spacing_flex.dart';

enum StackingOrder {
  firstOnTop,
  lastOnTop,
}

/// A widget that displays its children in a one-dimensional array.
///
/// The [SignedSpacingFlex] widget allows you to control the axis along which the children are
/// placed (horizontal or vertical). This is referred to as the _main axis_. If
/// you know the main axis in advance, then consider using a [SignedSpacingRow] (if it's
/// horizontal) or [SignedSpacingColumn] (if it's vertical) instead, because that will be less
/// verbose.
///
/// To cause a child to expand to fill the available space in the [direction]
/// of this widget's main axis, wrap the child in an [Expanded] widget.
class SignedSpacingFlex extends MultiChildRenderObjectWidget {
  /// Creates a flex layout.
  ///
  /// The [direction] is required.
  ///
  /// The [direction], [mainAxisAlignment], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null. If [crossAxisAlignment] is
  /// [CrossAxisAlignment.baseline], then [textBaseline] must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to decide which direction to lay the children in or to
  /// disambiguate `start` or `end` values for the main or cross axis
  /// directions, the [textDirection] must not be null.
  SignedSpacingFlex({
    super.key,
    required this.direction,
    this.spacing = 0.0,
    this.stackingOrder = StackingOrder.firstOnTop,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.clipBehavior = Clip.none,
    List<Widget> children = const [],
  })  : assert(crossAxisAlignment != CrossAxisAlignment.baseline || textBaseline != null,
            'textBaseline is required if you specify the crossAxisAlignment with CrossAxisAlignment.baseline'),
        super(children: stackingOrder == StackingOrder.firstOnTop ? children.reversed.toList() : children);

  /// The direction to use as the main axis.
  ///
  /// If you know the axis in advance, then consider using a [SignedSpacingRow] (if it's
  /// horizontal) or [SignedSpacingColumn] (if it's vertical) instead of a [SignedSpacingFlex], since that
  /// will be less verbose. (For [SignedSpacingRow] and [SignedSpacingColumn] this property is fixed to
  /// the appropriate axis.)
  final Axis direction;

  /// How the children should overlap.
  final StackingOrder stackingOrder;

  /// The space between the children.
  ///
  /// This can be a positive or negative number.
  final double spacing;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for a [SignedSpacingRow] or the top for a [SignedSpacingColumn]) of the
  /// main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  ///
  /// For example, [CrossAxisAlignment.center], the default, centers the
  /// children in the cross axis (e.g., horizontally for a [SignedSpacingColumn]).
  final CrossAxisAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left), and the
  /// meaning of the [mainAxisAlignment] property's [MainAxisAlignment.start] and
  /// [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [mainAxisAlignment] is either [MainAxisAlignment.start] or
  /// [MainAxisAlignment.end], or there's more than one child, then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [mainAxisAlignment]
  /// property's [MainAxisAlignment.start] and [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the [mainAxisAlignment]
  /// is either [MainAxisAlignment.start] or [MainAxisAlignment.end], or there's
  /// more than one child, then the [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// If aligning items according to their baseline, which baseline to use.
  ///
  /// This must be set if using baseline alignment. There is no default because there is no
  /// way for the framework to know the correct baseline _a priori_.
  final TextBaseline? textBaseline;

  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  bool get _needTextDirection {
    switch (direction) {
      case Axis.horizontal:
        return true; // because it affects the layout order.
      case Axis.vertical:
        return crossAxisAlignment == CrossAxisAlignment.start || crossAxisAlignment == CrossAxisAlignment.end;
    }
  }

  /// The value to pass to [RenderSignedSpacingFlex.textDirection].
  ///
  /// This value is derived from the [textDirection] property and the ambient
  /// [Directionality]. The value is null if there is no need to specify the
  /// text direction. In practice there's always a need to specify the direction
  /// except for vertical flexes (e.g. [SignedSpacingColumn]s) whose [crossAxisAlignment] is
  /// not dependent on the text direction (not `start` or `end`). In particular,
  /// a [SignedSpacingRow] always needs a text direction because the text direction controls
  /// its layout order. (For [SignedSpacingColumn]s, the layout order is controlled by
  /// [verticalDirection], which is always specified as it does not depend on an
  /// inherited widget and defaults to [VerticalDirection.down].)
  ///
  /// This method exists so that subclasses of [SignedSpacingFlex] that create their own
  /// render objects that are derived from [RenderSignedSpacingFlex] can do so and still use
  /// the logic for providing a text direction only when it is necessary.
  @protected
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    final newTextDirection = textDirection ?? (_needTextDirection ? Directionality.maybeOf(context) : null);
    if (newTextDirection != null && stackingOrder == StackingOrder.firstOnTop) {
      switch (newTextDirection) {
        case TextDirection.ltr:
          return TextDirection.rtl;
        case TextDirection.rtl:
          return TextDirection.ltr;
      }
    }
    return newTextDirection;
  }

  VerticalDirection _getVerticalDirection() {
    if (stackingOrder == StackingOrder.firstOnTop) {
      switch (verticalDirection) {
        case VerticalDirection.down:
          return VerticalDirection.up;
        case VerticalDirection.up:
          return VerticalDirection.down;
      }
    }
    return verticalDirection;
  }

  MainAxisAlignment _getMainAxisAlignment() {
    if (stackingOrder == StackingOrder.firstOnTop) {
      switch (mainAxisAlignment) {
        case MainAxisAlignment.start:
          return MainAxisAlignment.end;
        case MainAxisAlignment.end:
          return MainAxisAlignment.start;
        default:
          return mainAxisAlignment;
      }
    }
    return mainAxisAlignment;
  }

  @override
  RenderSignedSpacingFlex createRenderObject(BuildContext context) {
    return RenderSignedSpacingFlex(
      direction: direction,
      spacing: spacing,
      mainAxisAlignment: _getMainAxisAlignment(),
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: _getVerticalDirection(),
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSignedSpacingFlex renderObject) {
    renderObject
      ..direction = direction
      ..spacing = spacing
      ..mainAxisAlignment = _getMainAxisAlignment()
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = _getVerticalDirection()
      ..textBaseline = textBaseline
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<double>('spacing', spacing));
    properties.add(EnumProperty<StackingOrder>('stackingOrder', stackingOrder));
    properties.add(EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize, defaultValue: MainAxisSize.max));
    properties.add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection, defaultValue: VerticalDirection.down));
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline, defaultValue: null));
  }
}

/// A widget that displays its children in a horizontal array.
///
/// To cause a child to expand to fill the available horizontal space, wrap the
/// child in an [Expanded] widget.
class SignedSpacingRow extends SignedSpacingFlex {
  /// Creates a horizontal array of children.
  ///
  /// The [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null.
  /// If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then
  /// [textBaseline] must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to determine the layout order (which is always the case
  /// unless the row has no children or only one child) or to disambiguate
  /// `start` or `end` values for the [mainAxisAlignment], the [textDirection]
  /// must not be null.
  SignedSpacingRow({
    super.key,
    super.spacing,
    super.stackingOrder,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    super.children,
  }) : super(direction: Axis.horizontal);
}

/// A widget that displays its children in a vertical array.
///
/// To cause a child to expand to fill the available vertical space, wrap the
/// child in an [Expanded] widget.
class SignedSpacingColumn extends SignedSpacingFlex {
  /// Creates a vertical array of children.
  ///
  /// The [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and
  /// [verticalDirection] arguments must not be null.
  /// If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then
  /// [textBaseline] must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to disambiguate `start` or `end` values for the
  /// [crossAxisAlignment], the [textDirection] must not be null.
  SignedSpacingColumn({
    super.key,
    super.spacing,
    super.stackingOrder,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.children,
  }) : super(direction: Axis.vertical);
}
