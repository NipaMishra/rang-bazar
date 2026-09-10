import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/providers.dart';

class ThemeController extends Notifier<ThemeMode> {
  static const String _key = 'theme_mode';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  ThemeMode build() {
    final String? stored = _prefs.getString(_key);
    return switch (stored) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.light,
    };
  }

  Future<void> toggle() async {
    final ThemeMode next = state == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    state = next;
    await _prefs.setString(_key, next.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);
