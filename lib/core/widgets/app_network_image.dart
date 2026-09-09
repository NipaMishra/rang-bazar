import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.borderRadius = AppRadius.image,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color fill = context.rangColors.imageFill;
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: fill,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          placeholder: (BuildContext context, String url) => ColoredBox(
            color: fill,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (BuildContext context, String url, Object error) {
            return ColoredBox(
              color: fill,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}
