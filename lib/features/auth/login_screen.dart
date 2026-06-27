import 'package:flutter/material.dart';

import '../../core/services/backend_api_service.dart';
import '../../models/backend_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_error_dialog.dart';
import '../../widgets/custom_success_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../l10n/app_text.dart';
import '../../state/app_settings_provider.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<BackendSession> onAuthenticated;

  const LoginScreen({super.key, required this.onAuthenticated});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      await CustomErrorDialog.show(
        context,
        title: AppText.t(
          context,
          en: 'Missing Information',
          km: 'ព័ត៌មានមិនគ្រប់គ្រាន់',
        ),
        message: AppText.t(
          context,
          en: 'Please enter both email and password.',
          km: 'សូមបញ្ចូលអ៊ីមែល និងពាក្យសម្ងាត់ទាំងពីរ។',
        ),
      );
      return;
    }

    if (_isRegisterMode && fullName.isEmpty) {
      await CustomErrorDialog.show(
        context,
        title: AppText.t(
          context,
          en: 'Full Name Required',
          km: 'ត្រូវការឈ្មោះពេញ',
        ),
        message: AppText.t(
          context,
          en: 'Please enter your full name before creating an account.',
          km: 'សូមបញ្ចូលឈ្មោះពេញមុនបង្កើតគណនី។',
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    LoadingDialog.show(context);

    try {
      final api = BackendApiService.instance;

      final session = _isRegisterMode
          ? await _registerAndLogin(
              api,
              fullName: fullName,
              email: email,
              password: password,
            )
          : await _loginAndLoadProfile(api, email: email, password: password);

      if (mounted) {
        LoadingDialog.hide(context);
      }

      if (_isRegisterMode && mounted) {
        await CustomSuccessDialog.show(
          context,
          title: AppText.t(context, en: 'Account Created', km: 'បានបង្កើតគណនី'),
          message: AppText.t(
            context,
            en: 'Your account has been created successfully. Welcome to KhmerSOS.',
            km: 'គណនីរបស់អ្នកត្រូវបានបង្កើតជោគជ័យ។ សូមស្វាគមន៍មកកាន់ KhmerSOS។',
          ),
        );
      }

      widget.onAuthenticated(session);
    } on BackendApiException catch (error) {
      if (mounted) {
        LoadingDialog.hide(context);

        await CustomErrorDialog.show(
          context,
          title: _isRegisterMode
              ? AppText.t(
                  context,
                  en: 'Registration Failed',
                  km: 'ចុះឈ្មោះបរាជ័យ',
                )
              : AppText.t(context, en: 'Login Failed', km: 'ចូលប្រព័ន្ធបរាជ័យ'),
          message: error.message,
        );
      }
    } catch (_) {
      if (mounted) {
        LoadingDialog.hide(context);

        await CustomErrorDialog.show(
          context,
          title: AppText.t(
            context,
            en: 'Connection Error',
            km: 'កំហុសការតភ្ជាប់',
          ),
          message: AppText.t(
            context,
            en: 'Unable to connect to the server. Please check your internet connection and try again.',
            km: 'មិនអាចភ្ជាប់ទៅម៉ាស៊ីនមេបាន។ សូមពិនិត្យអ៊ីនធឺណិត ហើយព្យាយាមម្ដងទៀត។',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<BackendSession> _registerAndLogin(
    BackendApiService api, {
    required String fullName,
    required String email,
    required String password,
  }) async {
    await api.register(fullName: fullName, email: email, password: password);
    return _loginAndLoadProfile(api, email: email, password: password);
  }

  Future<BackendSession> _loginAndLoadProfile(
    BackendApiService api, {
    required String email,
    required String password,
  }) async {
    final session = await api.login(email: email, password: password);
    final user = await api.fetchCurrentUser(session.token) ?? session.user;
    return session.copyWith(user: user);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = AppSettingsScope.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('KhmerSOS', style: AppTextStyles.title),
                        ),
                      ),
                      _LanguageToggleChip(
                        isKhmer: settings.isKhmer,
                        onTap: settings.toggleLanguage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppText.t(
                        context,
                        en: 'Connect to the backend and sync your emergency profile.',
                        km: 'ភ្ជាប់ទៅម៉ាស៊ីនមេ ហើយធ្វើសមកាលកម្មប្រវត្តិពេលបន្ទាន់របស់អ្នក។',
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.72,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isRegisterMode) ...[
                    _AuthField(
                      controller: _fullNameController,
                      label: AppText.t(
                        context,
                        en: 'Full Name',
                        km: 'ឈ្មោះពេញ',
                      ),
                      hint: AppText.t(
                        context,
                        en: 'e.g. John Doe',
                        km: 'ឧ. John Doe',
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  _AuthField(
                    controller: _emailController,
                    label: AppText.t(context, en: 'Email', km: 'អ៊ីមែល'),
                    hint: AppText.t(
                      context,
                      en: 'e.g. john@example.com',
                      km: 'ឧ. john@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _AuthField(
                    controller: _passwordController,
                    label: AppText.t(
                      context,
                      en: 'Password',
                      km: 'ពាក្យសម្ងាត់',
                    ),
                    hint: AppText.t(
                      context,
                      en: 'Enter your password',
                      km: 'បញ្ចូលពាក្យសម្ងាត់',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: null,
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: AppColors.border),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            AppText.t(
                              context,
                              en: 'By continuing, you allow the app to sync your account with the backend.',
                              km: 'ដោយបន្ត អ្នកអនុញ្ញាតឱ្យកម្មវិធីធ្វើសមកាលកម្មគណនីជាមួយម៉ាស៊ីនមេ។',
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.68,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    text: _isLoading
                        ? AppText.t(context, en: 'PLEASE WAIT', km: 'សូមរង់ចាំ')
                        : _isRegisterMode
                        ? AppText.t(
                            context,
                            en: 'CREATE ACCOUNT',
                            km: 'បង្កើតគណនី',
                          )
                        : AppText.t(context, en: 'LOGIN', km: 'ចូលប្រព័ន្ធ'),
                    icon: _isLoading ? null : Icons.arrow_forward,
                    onPressed: _isLoading ? null : _submit,
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isRegisterMode = !_isRegisterMode;
                            });
                          },
                    child: Text(
                      _isRegisterMode
                          ? AppText.t(
                              context,
                              en: 'Already have an account? Login',
                              km: 'មានគណនីរួចហើយ? ចូលប្រព័ន្ធ',
                            )
                          : AppText.t(
                              context,
                              en: 'New here? Create an account',
                              km: 'ថ្មីមែនទេ? បង្កើតគណនី',
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.health_and_safety_outlined,
                    color: AppColors.primaryRed,
                    size: 18,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppText.t(
                      context,
                      en: 'Your profile is stored in the backend and synchronized through Supabase.',
                      km: 'ប្រវត្តិរបស់អ្នកត្រូវបានរក្សាទុកនៅម៉ាស៊ីនមេ និងធ្វើសមកាលកម្មតាម Supabase។',
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.68,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageToggleChip extends StatelessWidget {
  const _LanguageToggleChip({required this.isKhmer, required this.onTap});

  final bool isKhmer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          isKhmer ? 'EN' : 'ខ្មែរ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            filled: true,
            fillColor: isDarkMode
                ? theme.colorScheme.surface.withValues(alpha: 0.82)
                : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
