import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.pop(context);
      },
    ),
    title: const Text('Profile'),
  ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 16),
              const Text('SETTINGS', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 7),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Language', style: AppTextStyles.label),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(7),
                              ),
                            ),
                            child: const Text(
                              'EN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              border: Border.all(color: AppColors.border),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(7),
                              ),
                            ),
                            child: const Text(
                              'KH',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              const _SectionCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Appearance\nLight Mode',
                        style: AppTextStyles.label,
                      ),
                    ),
                    _MockSwitch(),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'PROFILE INFORMATION',
                icon: Icons.person_outline,
                child: const Column(
                  children: [
                    _MockField(label: 'Full Name', value: 'John Doe'),
                    SizedBox(height: 12),
                    _MockField(label: 'Phone Number', value: '+855 12 345 678'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'MEDICAL PROFILE',
                icon: Icons.medical_services_outlined,
                child: const Column(
                  children: [
                    _MockField(
                      label: 'Blood Group',
                      value: 'Unknown',
                      suffixIcon: Icons.keyboard_arrow_down,
                    ),
                    SizedBox(height: 12),
                    _MockField(
                      label: 'Known Allergies',
                      value: 'e.g. Penicillin, Peanuts',
                    ),
                    SizedBox(height: 12),
                    _MockLargeField(
                      label: 'Urgent Medical Notes',
                      value: 'Chronic conditions, current medications...',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(text: 'SAVE PROFILE', onPressed: () {}),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Information is stored locally for emergency first responders.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.location_on, color: AppColors.primaryRed, size: 16),
        SizedBox(width: 4),
        Text('KhmerSOS', style: AppTextStyles.appTitle),
        Spacer(),
        Icon(Icons.settings_outlined, size: 18, color: AppColors.primaryRed),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;

  const _SectionCard({
    required this.child,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightRed.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 14, color: AppColors.primaryRed),
                if (icon != null) const SizedBox(width: 5),
                Text(title!, style: AppTextStyles.sectionTitle),
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _MockField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? suffixIcon;

  const _MockField({
    required this.label,
    required this.value,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 5),
        Container(
          height: 37,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(child: Text(value, style: AppTextStyles.body)),
              if (suffixIcon != null)
                Icon(suffixIcon, size: 17, color: AppColors.textGrey),
            ],
          ),
        ),
      ],
    );
  }
}

class _MockLargeField extends StatelessWidget {
  final String label;
  final String value;

  const _MockLargeField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 5),
        Container(
          height: 92,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(value, style: AppTextStyles.body),
        ),
      ],
    );
  }
}

class _MockSwitch extends StatelessWidget {
  const _MockSwitch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 25,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: AppColors.primaryRed,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}