import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

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
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      final int next = (_index + 1) % kPromoSlides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: kPromoSlides.length,
            onPageChanged: (int value) => setState(() => _index = value),
            itemBuilder: (BuildContext context, int index) {
              return _PromoCard(
                slide: kPromoSlides[index],
                onShop: () => widget.onShop(kPromoSlides[index]),
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
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.accent
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
  const _PromoCard({required this.slide, required this.onShop});

  final PromoSlide slide;
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onShop,
          borderRadius: AppRadius.card,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              image: DecorationImage(
                image: AssetImage(slide.asset),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.card,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    (isDark ? AppColors.navyDeep : Colors.white).withValues(
                      alpha: isDark ? 0.72 : 0.22,
                    ),
                    Colors.transparent,
                  ],
                  stops: const <double>[0, 0.55],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          slide.title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (slide.line != null)
                          Text(
                            slide.line!,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        Text(
                          slide.subtitle,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            AppStrings.shopNow,
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
