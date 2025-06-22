import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SizeScreen {
  static bool get isPhone => Device.screenType == ScreenType.mobile;
  static bool get isTablet => Device.screenType == ScreenType.tablet;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isPhonePortrait(BuildContext context) =>
      isPhone && isPortrait(context);

  // static bool isPhoneLandscape(BuildContext context) =>
  //     isPhone && isLandscape(context);

  static bool isTabletPortrait(BuildContext context) =>
      isTablet && isPortrait(context);

  static bool isTabletLandscape(BuildContext context) =>
      isTablet && isLandscape(context);
}

class ResponsiveValue {
  final double phonePortrait;
  // final double phoneLandscape;
  final double tabletPortrait;
  // final double tabletLandscape;

  const ResponsiveValue({
    required this.phonePortrait,
    // required this.phoneLandscape,
    required this.tabletPortrait,
    // required this.tabletLandscape,
  });

  double of(BuildContext context) {
    if (SizeScreen.isPhonePortrait(context)) return phonePortrait;
    // if (SizeScreen.isPhoneLandscape(context)) return phoneLandscape;
    // if (SizeScreen.isTabletPortrait(context)) return tabletPortrait;
    return tabletPortrait;
  }
}

int responsiveInt(BuildContext context, List<int> values) {
  return ResponsiveValue(
    phonePortrait: values[0].toDouble(),
    tabletPortrait: values[1].toDouble(),
  ).of(context).toInt();
}

double responsiveDoule(BuildContext context, List<double> values) {
  return ResponsiveValue(
    phonePortrait: values[0],
    tabletPortrait: values[1],
  ).of(context);
}
