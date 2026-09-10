import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/ambient_backdrop.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/press_scale.dart';
import '../controllers/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool submitting = ref.read(loginControllerProvider);
    if (submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref.read(loginControllerProvider.notifier).submit();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _soon(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bool submitting = ref.watch(loginControllerProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      body: AmbientBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                clipBehavior: Clip.hardEdge,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const AppFadeIn(
                                  child: Center(child: BrandLogo(height: 74)),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 70),
                                  child: Text(
                                    AppStrings.loginTitle,
                                    textAlign: TextAlign.center,
                                    style: textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 120),
                                  child: Text(
                                    AppStrings.loginSubtitle,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: muted,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 170),
                                  child: AppTextField(
                                    controller: _email,
                                    label: AppStrings.emailLabel,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: Icons.mail_outline_rounded,
                                    autofillHints: const <String>[
                                      AutofillHints.email,
                                    ],
                                    validator: Validators.email,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 210),
                                  child: AppTextField(
                                    controller: _password,
                                    label: AppStrings.passwordLabel,
                                    obscureText: _obscure,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    autofillHints: const <String>[
                                      AutofillHints.password,
                                    ],
                                    validator: Validators.password,
                                    onToggleObscure: () {
                                      setState(() => _obscure = !_obscure);
                                    },
                                    onFieldSubmitted: (_) => _submit(),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        _soon(AppStrings.recoverySoon),
                                    child: Text(
                                      AppStrings.recoveryPassword,
                                      style: textTheme.labelLarge?.copyWith(
                                        color: muted,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 260),
                                  child: AppButton(
                                    label: AppStrings.loginCta,
                                    loading: submitting,
                                    onPressed: _submit,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Row(
                                  children: <Widget>[
                                    const Expanded(child: Divider()),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                        ),
                                        child: Text(
                                          AppStrings.continueWith,
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: muted,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                AppFadeIn(
                                  delay: const Duration(milliseconds: 310),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _SocialCircle(
                                        tooltip: AppStrings.signInGoogle,
                                        onTap: () => _soon(AppStrings.demoOnly),
                                        child: Text(
                                          'G',
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF4285F4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      _SocialCircle(
                                        tooltip: AppStrings.signInApple,
                                        onTap: () => _soon(AppStrings.demoOnly),
                                        child: Icon(
                                          Icons.apple_rounded,
                                          size: 27,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      _SocialCircle(
                                        tooltip: AppStrings.signInFacebook,
                                        onTap: () => _soon(AppStrings.demoOnly),
                                        child: const Icon(
                                          Icons.facebook_rounded,
                                          size: 26,
                                          color: Color(0xFF1877F2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppStrings.notAMember,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: muted,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _soon(AppStrings.registerSoon),
                                      child: Text(
                                        AppStrings.registerNow,
                                        style: textTheme.labelLarge?.copyWith(
                                          color: AppColors.accentDeep,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({
    required this.child,
    required this.onTap,
    required this.tooltip,
  });

  final Widget child;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: PressScale(
        onTap: onTap,
        scale: 0.9,
        semanticLabel: tooltip,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            boxShadow: AppShadows.soft(context.rangColors.cardShadow),
          ),
          child: child,
        ),
      ),
    );
  }
}
