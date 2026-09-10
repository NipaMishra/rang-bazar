import 'package:flutter/material.dart';

import 'shop_bottom_nav.dart';
import 'shop_drawer.dart';

class ShopScaffold extends StatelessWidget {
  const ShopScaffold({
    super.key,
    required this.current,
    required this.body,
    this.appBar,
    this.footer,
    this.flushFooter = false,
  });

  final ShopTab current;
  final Widget body;
  final PreferredSizeWidget? appBar;

  /// Pinned panel above the tab bar (e.g. the cart summary). Living in the
  /// scaffold's bottom slot keeps floating snackbars clear of its buttons.
  final Widget? footer;

  /// Set when the footer is a full-width panel that should read as one piece
  /// with the tab bar, rather than a card floating above it.
  final bool flushFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const ShopDrawer(),
      body: body,
      bottomNavigationBar: footer == null
          ? ShopBottomNav(current: current)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                footer!,
                ShopBottomNav(current: current, roundedTop: !flushFooter),
              ],
            ),
    );
  }
}
