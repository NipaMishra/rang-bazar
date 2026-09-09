import 'package:flutter/material.dart';

import '../utils/price_formatter.dart';

class PriceText extends StatelessWidget {
  const PriceText(this.value, {super.key, this.style});

  final num value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      PriceFormatter.format(value),
      style:
          style ??
          Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
