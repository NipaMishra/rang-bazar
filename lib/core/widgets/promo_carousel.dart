import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

class PromoSlide {
  const PromoSlide({
    required this.title,
    required this.subtitle,
    required this.asset,
    this.line,
    this.categorySlug,
  });

  final String title;
  final String subtitle;
  final String asset;
  final String? line;
  final String? categorySlug;
}

const List<PromoSlide> kPromoSlides = <PromoSlide>[
  PromoSlide(
    title: AppStrings.promoTitle,
    line: AppStrings.promoLine,
    subtitle: AppStrings.promoSubtitle,
    asset: AppAssets.promoOne,
  ),
  PromoSlide(
    title: AppStrings.promoTechTitle,
    subtitle: AppStrings.promoTechSubtitle,
    categorySlug: 'electronics',
    asset: AppAssets.promoFive,
  ),
  PromoSlide(
    title: AppStrings.promoJewelleryTitle,
    subtitle: AppStrings.promoJewellerySubtitle,
    categorySlug: 'jewelery',
    asset: AppAssets.promoTwo,
  ),
  PromoSlide(
    title: AppStrings.promoMenTitle,
    subtitle: AppStrings.promoMenSubtitle,
    categorySlug: "men's clothing",
    asset: AppAssets.promoFour,
  ),
  PromoSlide(
    title: AppStrings.promoAccessoriesTitle,
    subtitle: AppStrings.promoAccessoriesSubtitle,
    categorySlug: "men's clothing",
    asset: AppAssets.promoThree,
  ),
];

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key, required this.onShop});

  final ValueChanged<PromoSlide> onShop;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController();
  double _page = 0;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;
      final int next = (_index + 1) % kPromoSlides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _onScroll() {
    final double? page = _controller.page;
    if (page == null) return;
    setState(() => _page = page);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 172,
          child: PageView.builder(
            controller: _controller,
            itemCount: kPromoSlides.length,
            onPageChanged: (int value) => setState(() => _index = value),
            itemBuilder: (BuildContext context, int index) {
              // Distance from the centred page drives a gentle depth effect.
              final double delta = (_page - index).abs().clamp(0.0, 1.0);
              return Transform.scale(
                scale: 1 - delta * 0.06,
                child: Opacity(
                  opacity: 1 - delta * 0.35,
                  child: _PromoCard(
                    slide: kPromoSlides[index],
                    parallax: (_page - index).clamp(-1.0, 1.0),
                    onShop: () => widget.onShop(kPromoSlides[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(kPromoSlides.length, (int i) {
            final bool active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.accentDeep
                    : Theme.of(context).colorScheme.outline,
                borderRadius: AppRadius.pillAll,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.slide,
    required this.onShop,
    required this.parallax,
  });

  final PromoSlide slide;
  final VoidCallback onShop;
  final double parallax;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scrim = isDark ? AppColors.navyDeep : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: PressScale(
        onTap: onShop,
        scale: 0.98,
        semanticLabel: '${slide.title} ${slide.subtitle}',
        child: ClipRRect(
          borderRadius: AppRadius.card,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.translate(
                offset: Offset(parallax * 28, 0),
                child: Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    slide.asset,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      scrim.withValues(alpha: isDark ? 0.94 : 0.82),
                      scrim.withValues(alpha: isDark ? 0.72 : 0.42),
                      Colors.transparent,
                    ],
                    stops: const <double>[0, 0.5, 0.88],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 8, 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          slide.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        if (slide.line != null)
                          Text(
                            slide.line!,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          slide.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentDeep,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.cta,
                            borderRadius: AppRadius.pillAll,
                            boxShadow: AppShadows.cta(
                              AppColors.accent.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            child: Text(
                              AppStrings.shopNow,
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
