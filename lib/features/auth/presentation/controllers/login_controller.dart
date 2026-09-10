import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_durations.dart';

class LoginController extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> submit() async {
    if (state) return;
    state = true;
    try {
      await Future<void>.delayed(AppDurations.loginSimulate);
    } finally {
      state = false;
    }
  }
}

final loginControllerProvider = NotifierProvider<LoginController, bool>(
  LoginController.new,
);
