import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> steps;
  final IconData heroIcon;
  final String emergencyCallLabel;

  const FirstAidDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.steps,
    this.heroIcon = Icons.medical_services,
    this.emergencyCallLabel = 'EMERGENCY CALL: 119',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryRed,
        title: Text('$title Instructions'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                children: [
                  _HeroCard(title: title, subtitle: subtitle, icon: heroIcon),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Stay Calm. Follow these steps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (var i = 0; i < steps.length; i++) ...[
                    _InstructionStepCard(
                      number: i + 1,
                      title: _stepTitle(i),
                      description: steps[i],
                      icon: _stepIcon(i),
                    ),
                    if (i != steps.length - 1) const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: PrimaryButton(
                text: emergencyCallLabel,
                icon: Icons.emergency,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stepTitle(int index) {
    final titles = <String>[
      'Check Scene Safety',
      'Check Responsiveness',
      'Call Emergency Services',
      'Start Compressions',
      'Rescue Breaths',
    ];

    if (index < titles.length) {
      return titles[index];
    }
    return 'Step ${index + 1}';
  }

  IconData _stepIcon(int index) {
    final icons = <IconData>[
      Icons.shield_outlined,
      Icons.spatial_audio_off_outlined,
      Icons.phone_in_talk_outlined,
      Icons.front_hand_outlined,
      Icons.air_outlined,
    ];

    if (index < icons.length) {
      return icons[index];
    }
    return Icons.medical_services_outlined;
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: Colors.white, size: 36),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 32,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionStepCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final IconData icon;

  const _InstructionStepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.card;
    final borderColor = AppColors.border;
    final numberBg = AppColors.primaryRed;
    final numberColor = Colors.white;
    final titleColor = AppColors.textDark;
    final descriptionColor = AppColors.textGrey;
    final iconBg = AppColors.lightRed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: numberBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: numberColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 16,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: descriptionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primaryRed, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
