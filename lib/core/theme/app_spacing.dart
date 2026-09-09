import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double page = 20;
  static const double cardPadding = 16;
  static const double buttonHeight = 56;
  static const double icon = 24;
  static const double appBarLogoHeight = 40;
}

abstract final class AppRadius {
  static const double sm = 14;
  static const double md = 22;
  static const double lg = 28;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius field = BorderRadius.all(Radius.circular(18));
  static const BorderRadius image = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppShadows {
  static List<BoxShadow> soft(Color color) {
    return <BoxShadow>[
      BoxShadow(color: color, blurRadius: 24, offset: const Offset(0, 10)),
    ];
  }

  static List<BoxShadow> cta(Color color) {
    return <BoxShadow>[
      BoxShadow(color: color, blurRadius: 18, offset: const Offset(0, 8)),
    ];
  }
}

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1100;

  static int categoryColumns(double width) {
    if (width >= expanded) return 4;
    if (width >= compact) return 3;
    return 2;
  }

  static int productColumns(double width) {
    if (width >= expanded) return 4;
    if (width >= compact) return 3;
    return 2;
  }
}
