import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

abstract final class ProductSwatches {
  static const List<List<Color>> palettes = <List<Color>>[
    <Color>[Color(0xFF1A1A1A), Color(0xFFFF9B7B), AppColors.sky],
    <Color>[Color(0xFF2B2B2B), AppColors.accent, Color(0xFFB8B8B8)],
    <Color>[AppColors.navy, Color(0xFFFFC4B0), AppColors.teal],
    <Color>[Color(0xFF4A3728), AppColors.coral, Color(0xFFE8E0D8)],
  ];

  static List<Color> of(int productId) => palettes[productId % palettes.length];
}

class ColorDots extends StatelessWidget {
  const ColorDots({
    super.key,
    required this.colors,
    this.size = 8,
    this.gap = 4,
  });

  final List<Color> colors;
  final double size;
  final double gap;

  factory ColorDots.forProduct(int productId, {double size = 8}) {
    return ColorDots(colors: ProductSwatches.of(productId), size: size);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < colors.length; i++) ...<Widget>[
          if (i > 0) SizedBox(width: gap),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle),
          ),
        ],
      ],
    );
  }
}
