import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/wishlist/presentation/providers/wishlist_provider.dart';
import '../constants/app_durations.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Heart toggle that pops when tapped. Sits on product cards as a filled
/// accent tile, and on the details gallery as a floating circle.
class WishlistButton extends ConsumerStatefulWidget {
  const WishlistButton({
    super.key,
    required this.productId,
    this.framed = false,
  });

  final int productId;
  final bool framed;

  @override
  ConsumerState<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends ConsumerState<WishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    lowerBound: 0,
    upperBound: 1,
  );

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  void _toggle(bool saved) {
    ref.read(wishlistProvider.notifier).toggle(widget.productId);
    _pop
      ..reset()
      ..forward();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppDurations.snackbar,
          content: Text(
            saved ? AppStrings.favouriteRemoved : AppStrings.favouriteAdded,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool saved = ref.watch(wishlistProvider).contains(widget.productId);
    final double size = widget.framed ? 42 : 34;

    return Tooltip(
      message: saved ? AppStrings.favouriteRemove : AppStrings.favouriteSave,
      child: GestureDetector(
        onTap: () => _toggle(saved),
        child: AnimatedBuilder(
          animation: _pop,
          builder: (BuildContext context, Widget? child) {
            // Quick squash-and-stretch: 1 -> 1.25 -> 1.
            final double t = _pop.value;
            final double scale = 1 + (t < 0.5 ? t : 1 - t) * 0.5;
            return Transform.scale(scale: scale, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: widget.framed
                  ? scheme.surface.withValues(alpha: 0.88)
                  : (saved ? AppColors.accentDeep : scheme.surface),
              borderRadius: widget.framed ? AppRadius.pillAll : AppRadius.tile,
              boxShadow: AppShadows.soft(context.rangColors.cardShadow),
            ),
            child: Icon(
              saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: widget.framed ? 20 : 18,
              color: !widget.framed && saved
                  ? Colors.white
                  : AppColors.accentDeep,
            ),
          ),
        ),
      ),
    );
  }
}
