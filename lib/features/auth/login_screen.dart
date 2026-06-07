import 'package:flutter/material.dart';

import '../../core/services/backend_api_service.dart';
import '../../models/backend_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

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
      _showError('Email and password are required.');
      return;
    }

    if (_isRegisterMode && fullName.isEmpty) {
      _showError('Full name is required to register.');
      return;
    }

    setState(() => _isLoading = true);

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

      widget.onAuthenticated(session);
    } on BackendApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Unable to connect to the backend.');
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

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              decoration: BoxDecoration(
                color: AppColors.card,
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('KhmerSOS', style: AppTextStyles.title),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Connect to the backend and sync your emergency profile.',
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isRegisterMode) ...[
                    _AuthField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      hint: 'e.g. John Doe',
                    ),
                    const SizedBox(height: 14),
                  ],
                  _AuthField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'e.g. john@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _AuthField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'By continuing, you allow the app to sync your account with the backend.',
                            style: AppTextStyles.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    text: _isLoading
                        ? 'PLEASE WAIT'
                        : _isRegisterMode
                            ? 'CREATE ACCOUNT'
                            : 'LOGIN',
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
                          ? 'Already have an account? Login'
                          : 'New here? Create an account',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.health_and_safety_outlined,
                    color: AppColors.primaryRed,
                    size: 18,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your profile is stored in the backend and synchronized through Supabase.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.small,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
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
