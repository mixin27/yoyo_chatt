import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  Size get mqSize => MediaQuery.sizeOf(this);
  double get mqWidth => mqSize.width;
  double get mqHeight => mqSize.height;

  Orientation get mqOrientation => MediaQuery.orientationOf(this);
}

extension WidgetX on Widget {
  // Padding
  Widget addPadding(EdgeInsetsGeometry? padding) => padding == null
      ? this
      : Padding(
          padding: padding,
          child: this,
        );

  Widget p(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );
  Widget pl(double value) => Padding(
        padding: EdgeInsets.only(left: value),
        child: this,
      );
  Widget pr(double value) => Padding(
        padding: EdgeInsets.only(right: value),
        child: this,
      );
  Widget pt(double value) => Padding(
        padding: EdgeInsets.only(top: value),
        child: this,
      );
  Widget pb(double value) => Padding(
        padding: EdgeInsets.only(bottom: value),
        child: this,
      );
  Widget px(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );
  Widget py(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );

  // Margin
  Widget m(double value) => Container(
        margin: EdgeInsets.all(value),
        child: this,
      );
  Widget ml(double value) => Container(
        margin: EdgeInsets.only(left: value),
        child: this,
      );
  Widget mr(double value) => Container(
        margin: EdgeInsets.only(right: value),
        child: this,
      );
  Widget mt(double value) => Container(
        margin: EdgeInsets.only(top: value),
        child: this,
      );
  Widget mb(double value) => Container(
        margin: EdgeInsets.only(bottom: value),
        child: this,
      );
  Widget mx(double value) => Container(
        margin: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );
  Widget my(double value) => Container(
        margin: EdgeInsets.symmetric(vertical: value),
        child: this,
      );
}
