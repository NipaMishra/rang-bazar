import 'package:flutter/material.dart';

/// Slides content up while fading it in. Used to stagger lists and sections so
/// screens assemble themselves instead of popping in all at once.
class AppFadeIn extends StatefulWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 18,
    this.duration = const Duration(milliseconds: 420),
  });

  /// Staggers by [index] but caps the wait so long grids never feel sluggish.
  AppFadeIn.staggered({
    super.key,
    required this.child,
    required int index,
    this.offset = 18,
    this.duration = const Duration(milliseconds: 420),
    int step = 55,
    int maxSteps = 6,
  }) : delay = Duration(
         milliseconds: (index < maxSteps ? index : maxSteps) * step,
       );

  final Widget child;
  final Duration delay;
  final double offset;
  final Duration duration;

  @override
  State<AppFadeIn> createState() => _AppFadeInState();
}

class _AppFadeInState extends State<AppFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _curve.value) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
