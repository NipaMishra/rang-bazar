import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft brand glows behind full-screen content (splash, login).
class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        Positioned(
          top: -110,
          right: -70,
          child: _Glow(
            color: AppColors.accent.withValues(alpha: isDark ? 0.16 : 0.26),
            size: 230,
          ),
        ),
        Positioned(
          left: -90,
          bottom: -120,
          child: _Glow(
            color: AppColors.pink.withValues(alpha: isDark ? 0.14 : 0.16),
            size: 240,
          ),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: color, blurRadius: 90, spreadRadius: 40),
          ],
        ),
      ),
    );
  }
}
