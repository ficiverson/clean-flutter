import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

// workaround for iPhone X which draws navigation in the bottom of the screen.
// Wait until https://github.com/flutter/flutter/issues/12099 is fixed
class IPhoneXPadding extends Container {
  final Widget child;

  IPhoneXPadding({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    if (!_isIPhoneX(mediaQueryData)) {
      // fallback for all non iPhone X
      return child;
    }

    var homeIndicatorHeight =
    // TODO verify exact values
    mediaQueryData.orientation == Orientation.portrait ? 22.0 : 20.0;

    var outer = mediaQueryData.padding;
    var bottom = outer.bottom + homeIndicatorHeight;
    return new MediaQuery(data: new MediaQueryData(
        padding: new EdgeInsets.fromLTRB(
            outer.left, outer.top, outer.right, bottom)),
        child: child
    );
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }
}