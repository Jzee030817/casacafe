import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../config/app_style.dart';

class McRaisedButton extends RaisedButton {
  final Widget child;
  final GestureTapCallback onPressed;

  McRaisedButton({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: buttonBackColor,
      splashColor: buttonSplashColor,
      textStyle: TextStyle(color: buttonTextColor),
      child: child,
      onPressed: onPressed,
      shape: StadiumBorder(),
    );
  }
}
