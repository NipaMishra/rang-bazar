import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'press_scale.dart';

/// Pill search input with an inline filter affordance, matching the shop
/// header in the design reference.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool active = _focus.hasFocus;
    final bool hasText = widget.controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 48,
      padding: const EdgeInsets.only(left: AppSpacing.sm, right: 6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.pillAll,
        border: Border.all(
          color: active ? AppColors.accent : scheme.outline,
          width: active ? 1.4 : 1,
        ),
        boxShadow: active
            ? AppShadows.cta(AppColors.accent.withValues(alpha: 0.18))
            : AppShadows.soft(context.rangColors.cardShadow),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search_rounded,
            size: 20,
            color: active ? AppColors.accentDeep : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              onChanged: (String value) {
                setState(() {});
                widget.onChanged(value);
              },
              textInputAction: TextInputAction.search,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: AppStrings.searchHint,
                hintStyle: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          if (hasText)
            Tooltip(
              message: AppStrings.clearSearch,
              child: PressScale(
                scale: 0.85,
                onTap: () {
                  widget.controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
                semanticLabel: AppStrings.clearSearch,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.close_rounded, size: 18),
                ),
              ),
            ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: scheme.outline,
          ),
          Tooltip(
            message: AppStrings.filterTooltip,
            child: PressScale(
              scale: 0.85,
              onTap: widget.onFilter,
              semanticLabel: AppStrings.filterTooltip,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: context.rangColors.accentSoft,
                  borderRadius: AppRadius.pillAll,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: AppColors.accentDeep,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
