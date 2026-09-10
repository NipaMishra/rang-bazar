import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppRadius.md,
  });

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color base = context.rangColors.imageFill;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: <Color>[
                base,
                Color.lerp(base, Colors.white, 0.35)!,
                base,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({
    super.key,
    required this.columns,
    this.padding = const EdgeInsets.all(AppSpacing.page),
    this.rows = 3,
    this.physics,
  });

  final int columns;
  final EdgeInsets padding;
  final int rows;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.72,
      ),
      itemCount: columns * rows,
      itemBuilder: (BuildContext context, int index) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: ShimmerBox()),
            SizedBox(height: AppSpacing.sm),
            ShimmerBox(height: 14, width: double.infinity, borderRadius: 6),
            SizedBox(height: AppSpacing.xs),
            ShimmerBox(height: 14, width: 72, borderRadius: 6),
          ],
        );
      },
    );
  }
}
