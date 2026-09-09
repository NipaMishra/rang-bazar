import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_spacing.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.height = 120,
    this.semanticLabel = 'RangBazaar',
  });

  final double height;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: semanticLabel,
    );
  }
}

class CompactBrandMark extends StatelessWidget {
  const CompactBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: AppSpacing.appBarLogoHeight,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'RangBazaar',
    );
  }
}
