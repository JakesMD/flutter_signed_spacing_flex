Modified versions of Flutter's `Flex`, `Column` and `Row` widgets that can space their children with positive or negative spacing.

![Preview](https://raw.githubusercontent.com/JakesMD/signed_spacing_flex/main/preview.gif "preview")

## Features

- [x] All the bells and whistles of Flutter's original `Flex`, `Column` and `Row` widgets.
- [x] Space the children apart with positive spacing.
- [x] Cause the children to overlap with negative spacing.
- [x] Set the order in which the children should be stacked when they overlap.
- [ ] `MainAxisAlignment.spaceAround`, `MainAxisAlignment.spaceBetween` and `MainAxisAlignment.spaceEvenly` or *not* supported. *(There's no need for them here. Just use Flutter's original widgets.)*

## Getting started

Install it:
``` dart
flutter pub add signed_spacing_flex
```
Import it:
``` dart
import 'package:signed_spacing_flex/signed_spacing_flex.dart';
```

## Usage

Checkout Flutter's guides to the [Flex](https://api.flutter.dev/flutter/widgets/Flex-class.html), [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) and [Row](https://api.flutter.dev/flutter/widgets/Row-class.html) widgets. This package is basically same just with some added features.

1. Replace `Flex`, `Column` or `Row` with `SignedSpacingFlex`, `SignedSpacingColumn` or `SignedSpacingRow`.
``` dart
// Flex(
SignedSpacingFlex(
    children: [],
)

// Column(
SignedSpacingColumn(
    children: [],
)

// Row(
SignedSpacingRow(
    children: [],
)
```
2. Use `spacing` to space the children apart or cause them to overlap:
``` dart
SignedSpacingColumn(
    spacing: 25, // Creates a 25px tall gap between the children.
    children: [],
)

SignedSpacingColumn(
    spacing: -25, // Makes the children overlap eachother by 25px.
    children: [],
)
```
3. Use `stackingOrder` to set the order in which the children should be stacked when they overlap:
``` dart
SignedSpacingColumn(
    spacing: -25, // Makes the children overlap eachother by 25px.
    stackingOrder: StackingOrder.firstOnTop // The children will be rendered first to last - top to bottom.
    children: [],
)

SignedSpacingColumn(
    spacing: -25, // Makes the children overlap eachother by 25px.
    stackingOrder: StackingOrder.lastOnTop // The children will be rendered first to last - bottom to top.
    children: [],
)
```


## Additional information

These are modified versions of Flutter's [flutter/packages/flutter/lib/src/widgets/basic.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/basic.dart) and [flutter/packages/flutter/lib/src/rendering/flex.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/rendering/flex.dart) files.
I am not the original author of this code.
