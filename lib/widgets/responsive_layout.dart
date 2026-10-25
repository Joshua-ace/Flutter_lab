import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobileMax = 650;
  static const double tabletMax = 1000;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.mobileMax &&
      MediaQuery.of(context).size.width < Breakpoints.tabletMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.tabletMax;

  static int responsiveGridColumns(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3}) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.tabletMax) return desktop;
    if (width >= Breakpoints.mobileMax) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.tabletMax && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= Breakpoints.mobileMax && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
