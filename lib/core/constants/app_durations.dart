abstract final class AppDurations {
  static const Duration splash = Duration(seconds: 3);
  static const Duration splashFade = Duration(milliseconds: 900);
  static const Duration loginSimulate = Duration(milliseconds: 900);
  static const Duration checkoutSimulate = Duration(milliseconds: 800);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration snackbar = Duration(seconds: 2);

  /// Slack given to a snackbar's own timer before a fallback dismisses it.
  static const Duration snackbarGrace = Duration(milliseconds: 600);
}
