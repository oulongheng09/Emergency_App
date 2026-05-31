import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
  });

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
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Join Sentinel', style: AppTextStyles.title),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your immediate link to emergency services. Enter your details to continue.',
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _MockField(label: 'Full Name', hint: 'e.g. John Doe'),
                  const SizedBox(height: 14),
                  const _MockField(
                    label: 'Phone Number',
                    hint: '+855 XX XXX XXX',
                    suffixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: null,
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: AppColors.border),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: AppColors.primaryRed,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' and acknowledge the critical nature of emergency data processing.',
                                ),
                              ],
                            ),
                            style: AppTextStyles.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    text: 'LOGIN',
                    icon: Icons.arrow_forward,
                    onPressed: onLogin,
                  ),
                  const SizedBox(height: 35),
                  const Icon(
                    Icons.health_and_safety_outlined,
                    color: AppColors.primaryRed,
                    size: 18,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your data is encrypted using military-grade protocols for immediate dispatcher access.',
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

class _MockField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? suffixIcon;

  const _MockField({
    required this.label,
    required this.hint,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.small,
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, size: 15, color: AppColors.textGrey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
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