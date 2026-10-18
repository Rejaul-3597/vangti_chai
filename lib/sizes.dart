import 'package:flutter/widgets.dart';

/// Flutter equivalent of sizes.xml: every text size, padding, margin and
/// height used by the layouts lives here, so no number is hardcoded in
/// main.dart.
class AppSizes {
  const AppSizes({
    required this.amountFont,
    required this.noteFont,
    required this.keyFont,
    required this.pagePadding,
    required this.sectionGap,
    required this.keySpacing,
    required this.keyRadius,
    required this.portraitBodyHeight,
    required this.landscapeBodyHeight,
  });

  final double amountFont;
  final double noteFont;
  final double keyFont;
  final double pagePadding;
  final double sectionGap;
  final double keySpacing;
  final double keyRadius;
  final double portraitBodyHeight;
  final double landscapeBodyHeight;

  /// Screens whose shortest side is at least this many dp use the tablet
  /// sizes (Nexus 10: 800 dp). Pixel XL has a shortest side of 411 dp.
  static const double tabletBreakpoint = 600;

  /// Sizes for phones such as the Pixel XL (411 x 731 dp).
  static const AppSizes phone = AppSizes(
    amountFont: 24,
    noteFont: 18,
    keyFont: 22,
    pagePadding: 16,
    sectionGap: 16,
    keySpacing: 4,
    keyRadius: 4,
    portraitBodyHeight: 360,
    landscapeBodyHeight: 280,
  );

  /// Sizes for tablets such as the Nexus 10 (800 x 1280 dp).
  static const AppSizes tablet = AppSizes(
    amountFont: 40,
    noteFont: 32,
    keyFont: 36,
    pagePadding: 32,
    sectionGap: 32,
    keySpacing: 8,
    keyRadius: 8,
    portraitBodyHeight: 560,
    landscapeBodyHeight: 480,
  );

  static AppSizes of(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return shortest >= tabletBreakpoint ? tablet : phone;
  }
}
