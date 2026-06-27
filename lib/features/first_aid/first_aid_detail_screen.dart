import 'package:emergency_front_end/models/first_aid_tip_model.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import '../../l10n/app_text.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FirstAidTip> tips;
  final IconData heroIcon;
  final String emergencyCallLabel;

  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  const FirstAidDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tips,
    this.heroIcon = Icons.medical_services,
    this.emergencyCallLabel = 'EMERGENCY CALL: 119',
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
    required List<String> steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppColors.primaryRed,
        title: Text(
          AppText.t(context, en: '$title Instructions', km: 'ការណែនាំ $title'),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    user: user,
                    token: token,
                    onSaved: onUserUpdated,
                    onLogout: onLogout,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isTablet = width >= 600;
            final horizontalPadding = isTablet ? 24.0 : 18.0;
            final topPadding = isTablet ? 28.0 : 22.0;
            final bottomPadding = isTablet ? 36.0 : 32.0;
            final heroSpacing = isTablet ? 36.0 : 30.0;
            final sectionSpacing = isTablet ? 36.0 : 30.0;
            final cardSpacing = isTablet ? 18.0 : 14.0;
            final heroScale = isTablet ? 1.12 : 1.0;
            final heroTitleSize = isTablet ? 38.0 : 34.0;
            final heroSubtitleSize = isTablet ? 21.0 : 19.0;
            final heroIconBox = isTablet ? 156.0 : 144.0;
            final heroInnerBox = isTablet ? 88.0 : 82.0;
            final heroIconSize = isTablet ? 42.0 : 40.0;
            final stepCardPadding = isTablet ? 22.0 : 20.0;
            final stepNumberBox = isTablet ? 58.0 : 54.0;
            final stepIconBox = isTablet ? 50.0 : 46.0;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    children: [
                      _HeroCard(
                        title: title,
                        subtitle: subtitle,
                        icon: heroIcon,
                        outerSize: heroIconBox,
                        innerSize: heroInnerBox,
                        iconSize: heroIconSize,
                        titleSize: heroTitleSize,
                        subtitleSize: heroSubtitleSize,
                        scale: heroScale,
                      ),
                      SizedBox(height: heroSpacing),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 18 : 10,
                        ),
                        child: Text(
                          AppText.t(
                            context,
                            en: 'Stay Calm. Follow these steps.',
                            km: 'ស្ងប់ស្ងាត់។ អនុវត្តតាមជំហានខាងក្រោម។',
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isTablet ? 27 : 24,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                            height: isTablet ? 1.3 : 1.25,
                          ),
                        ),
                      ),
                      SizedBox(height: sectionSpacing),
                      for (var i = 0; i < tips.length; i++) ...[
                        _InstructionStepCard(
                          number: i + 1,
                          title: tips[i].title,
                          description: tips[i].content,
                          icon: _stepIcon(i),
                          padding: stepCardPadding,
                          numberBoxSize: stepNumberBox,
                          iconBoxSize: stepIconBox,
                        ),
                        SizedBox(height: cardSpacing),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    isTablet ? 28 : 22,
                  ),
                  child: PrimaryButton(
                    text: AppText.t(
                      context,
                      en: emergencyCallLabel,
                      km: 'ហៅបន្ទាន់: 119',
                    ),
                    icon: Icons.emergency,
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
  final double outerSize;
  final double innerSize;
  final double iconSize;
  final double titleSize;
  final double subtitleSize;
  final double scale;

  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.outerSize = 144,
    this.innerSize = 82,
    this.iconSize = 40,
    this.titleSize = 34,
    this.subtitleSize = 19,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Transform.scale(
        scale: scale,
        child: Column(
          children: [
            Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.75),
                ),
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
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: Colors.white, size: iconSize),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: AppTextStyles.title.copyWith(
                fontSize: titleSize,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subtitleSize,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionStepCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final double padding;
  final double numberBoxSize;
  final double iconBoxSize;

  const _InstructionStepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    this.padding = 20,
    this.numberBoxSize = 54,
    this.iconBoxSize = 46,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = theme.colorScheme.surface;
    final borderColor = theme.dividerColor.withValues(alpha: 0.75);
    final numberBg = AppColors.primaryRed;
    final numberColor = Colors.white;
    final titleColor = theme.colorScheme.onSurface;
    final descriptionColor = isDarkMode ? Colors.white70 : AppColors.textGrey;
    final iconBg = isDarkMode
        ? AppColors.primaryRed.withValues(alpha: 0.16)
        : AppColors.lightRed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(padding),
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
                    width: numberBoxSize,
                    height: numberBoxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: numberBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: numberColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 17,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            height: 1.6,
                            color: descriptionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primaryRed, size: 24),
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
