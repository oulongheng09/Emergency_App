import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/models/first_aid_tip_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_info_chip.dart';
import '../../widgets/app_section_title.dart';
import '../../widgets/first_aid_card.dart';
import '../../widgets/primary_button.dart';
import 'first_aid_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/services/backend_api_service.dart';
import '../../models/first_aid_category.dart';
import '../../l10n/app_text.dart';

const _vidCpr = 'videos/cpr.mp4';
const _vidBurns = 'videos/burn.mp4';
const _vidBleeding = 'videos/bleeding.mp4';
const _vidChoking = 'videos/chocking.mp4';
const _vidSnakeBite = 'videos/snake bite.mp4';

class _TrainingItem {
  final String title;
  final String titleKm;
  final String subtitle;
  final String subtitleKm;
  final String videoUrl;

  const _TrainingItem({
    required this.title,
    required this.titleKm,
    required this.subtitle,
    required this.subtitleKm,
    required this.videoUrl,
  });

  String localizedTitle(BuildContext context) =>
      AppText.t(context, en: title, km: titleKm);

  String localizedSubtitle(BuildContext context) =>
      AppText.t(context, en: subtitle, km: subtitleKm);
}

const _trainingItems = <_TrainingItem>[
  _TrainingItem(
    title: 'CPR',
    titleKm: 'CPR',
    subtitle: 'Cardiopulmonary Resuscitation',
    subtitleKm: 'ការជួយដង្ហើមបេះដូង',
    videoUrl: _vidCpr,
  ),
  _TrainingItem(
    title: 'Burns',
    titleKm: 'ការរលាក',
    subtitle: 'Cool, cover, and protect',
    subtitleKm: 'ត្រជាក់ គ្រប និងការពារ',
    videoUrl: _vidBurns,
  ),
  _TrainingItem(
    title: 'Bleeding',
    titleKm: 'ហូរឈាម',
    subtitle: 'Pressure first',
    subtitleKm: 'សំពាធជាមុន',
    videoUrl: _vidBleeding,
  ),
  _TrainingItem(
    title: 'Choking',
    titleKm: 'ស្ទះដង្ហើម',
    subtitle: 'Clear the airway',
    subtitleKm: 'បើកផ្លូវដង្ហើម',
    videoUrl: _vidChoking,
  ),
  _TrainingItem(
    title: 'Snake Bite',
    titleKm: 'ពស់ចឹក',
    subtitle: 'Immobilize and get help',
    subtitleKm: 'មិនឲ្យចលនា និងស្នើជំនួយ',
    videoUrl: _vidSnakeBite,
  ),
];

class FirstAidListScreen extends StatefulWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  const FirstAidListScreen({
    super.key,
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  @override
  State<FirstAidListScreen> createState() => _FirstAidListScreenState();
}

class _FirstAidListScreenState extends State<FirstAidListScreen> {
  late Future<List<FirstAidCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = BackendApiService.instance.fetchFirstAidCategories();
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'bleeding':
        return Icons.bloodtype;

      case 'burns':
        return Icons.local_fire_department;

      case 'choking':
        return Icons.air;

      case 'cpr':
        return Icons.monitor_heart;

      case 'snake bite':
        return Icons.crisis_alert;

      default:
        return Icons.medical_services;
    }
  }

  Color _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'bleeding':
        return const Color(0xFFE53935);

      case 'burns':
        return const Color(0xFFFF6F00);

      case 'choking':
        return const Color(0xFF29B6F6);

      case 'cpr':
        return const Color(0xFFD81B60);

      case 'snake bite':
        return const Color(0xFF43A047);

      default:
        return AppColors.primaryRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width < 600 ? 16.0 : 22.0;
            final maxContentWidth = width >= 1100 ? 1040.0 : double.infinity;
            final crossAxisCount = width < 600
                ? 1
                : width < 900
                ? 2
                : 3;
            final cardExtent = width < 600
                ? 190.0
                : width < 900
                ? 190.0
                : 200.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(
                        onSettingsTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                user: widget.user,
                                token: widget.token,
                                onSaved: widget.onUserUpdated,
                                onLogout: widget.onLogout,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      AppSectionTitle(
                        title: AppText.t(
                          context,
                          en: 'First-Aid Guide',
                          km: 'មគ្គុទេសក៍ជំនួយបឋម',
                        ),
                        subtitle: AppText.t(
                          context,
                          en: 'Instant protocols for critical emergencies. Tap any category for immediate instructions.',
                          km: 'វិធានការភ្លាមៗសម្រាប់ស្ថានការណ៍បន្ទាន់។ ចុចលើប្រភេទណាមួយដើម្បីមើលការណែនាំភ្លាមៗ។',
                        ),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<List<FirstAidCategory>>(
                        future: _categoriesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          final categories = snapshot.data ?? [];

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: cardExtent,
                                ),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final color = _getCategoryColor(category.name);

                              return FirstAidCard(
                                title: category.name,
                                subtitle: _categorySubtitle(
                                  context,
                                  category.name,
                                ),
                                helperText: AppText.t(
                                  context,
                                  en: 'Tap for steps',
                                  km: 'ចុចដើម្បីមើលជំហាន',
                                ),
                                icon: _getCategoryIcon(category.name),
                                foregroundColor: color,
                                borderColor: color.withValues(alpha: 0.18),
                                accentColor: color,
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  try {
                                    final data = await BackendApiService
                                        .instance
                                        .fetchFirstAidCategory(category.id);

                                    if (!context.mounted) return;

                                    Navigator.pop(context); // close loading

                                    final tips = (data['tips'] as List)
                                        .map((e) => FirstAidTip.fromJson(e))
                                        .toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FirstAidDetailScreen(
                                          title: category.name,
                                          subtitle: AppText.t(
                                            context,
                                            en: 'Emergency First Aid',
                                            km: 'ជំនួយបឋមបន្ទាន់',
                                          ),
                                          tips: tips,
                                          heroIcon: _getCategoryIcon(
                                            category.name,
                                          ),
                                          user: widget.user,
                                          token: widget.token,
                                          onUserUpdated: widget.onUserUpdated,
                                          onLogout: widget.onLogout,
                                          steps: [],
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      _TrainingBanner(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TrainingModuleScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      AppSectionTitle(
                        title: AppText.t(
                          context,
                          en: 'OTHER SCENARIOS',
                          km: 'ស្ថានការណ៍ផ្សេងទៀត',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ScenarioRow(
                        label: AppText.t(context, en: 'Drowning', km: 'លង់ទឹក'),
                        onTap: () => _openDetail(
                          context,
                          title: AppText.t(
                            context,
                            en: 'Drowning',
                            km: 'លង់ទឹក',
                          ),
                          subtitle: AppText.t(
                            context,
                            en: 'Get the person to safety',
                            km: 'នាំអ្នករងគ្រោះទៅកន្លែងសុវត្ថិភាព',
                          ),
                          steps: [
                            AppText.t(
                              context,
                              en: 'Remove the person from water only if safe.',
                              km: 'យកមនុស្សចេញពីទឹកតែបើមានសុវត្ថិភាព។',
                            ),
                            AppText.t(
                              context,
                              en: 'Call emergency services.',
                              km: 'ទូរស័ព្ទហៅសេវាបន្ទាន់។',
                            ),
                            AppText.t(
                              context,
                              en: 'Start rescue breathing if trained.',
                              km: 'ចាប់ផ្តើមដង្ហើមជំនួយ ប្រសិនបើអ្នកបានបណ្តុះបណ្តាល។',
                            ),
                            AppText.t(
                              context,
                              en: 'Keep monitoring until help arrives.',
                              km: 'តាមដានជាបន្តបន្ទាប់រហូតដល់ជំនួយមកដល់។',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ScenarioRow(
                        label: AppText.t(
                          context,
                          en: 'Electric Shock',
                          km: 'ឆក់អគ្គិសនី',
                        ),
                        onTap: () => _openDetail(
                          context,
                          title: AppText.t(
                            context,
                            en: 'Electric Shock',
                            km: 'ឆក់អគ្គិសនី',
                          ),
                          subtitle: AppText.t(
                            context,
                            en: 'Disconnect power first',
                            km: 'ផ្តាច់ភ្លើងជាមុន',
                          ),
                          steps: [
                            AppText.t(
                              context,
                              en: 'Turn off the power source if safe.',
                              km: 'បិទប្រភពអគ្គិសនី បើមានសុវត្ថិភាព។',
                            ),
                            AppText.t(
                              context,
                              en: 'Do not touch the person until safe.',
                              km: 'កុំប៉ះអ្នករងគ្រោះរហូតដល់មានសុវត្ថិភាព។',
                            ),
                            AppText.t(
                              context,
                              en: 'Call emergency services.',
                              km: 'ទូរស័ព្ទហៅសេវាបន្ទាន់។',
                            ),
                            AppText.t(
                              context,
                              en: 'Check for breathing and injuries.',
                              km: 'ពិនិត្យការដកដង្ហើម និងរបួស។',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ScenarioRow(
                        label: AppText.t(
                          context,
                          en: 'Heat Stroke',
                          km: 'ជំងឺក្តៅខ្លាំង',
                        ),
                        onTap: () => _openDetail(
                          context,
                          title: AppText.t(
                            context,
                            en: 'Heat Stroke',
                            km: 'ជំងឺក្តៅខ្លាំង',
                          ),
                          subtitle: AppText.t(
                            context,
                            en: 'Cool fast, call help',
                            km: 'ត្រជាក់ឲ្យលឿន ហៅជំនួយ',
                          ),
                          steps: [
                            AppText.t(
                              context,
                              en: 'Move to a cool place immediately.',
                              km: 'ផ្លាស់ទីទៅកន្លែងត្រជាក់ភ្លាមៗ។',
                            ),
                            AppText.t(
                              context,
                              en: 'Remove excess clothing.',
                              km: 'ដោះសម្លៀកបំពាក់លើសចេញ។',
                            ),
                            AppText.t(
                              context,
                              en: 'Cool with water and fans.',
                              km: 'បំបាត់កំដៅដោយទឹក និងកង្ហារ។',
                            ),
                            AppText.t(
                              context,
                              en: 'Call emergency services urgently.',
                              km: 'ទូរស័ព្ទហៅសេវាបន្ទាន់ភ្លាមៗ។',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _categorySubtitle(BuildContext context, String name) {
    switch (name.toLowerCase()) {
      case 'bleeding':
        return AppText.t(
          context,
          en: 'Control the flow fast',
          km: 'គ្រប់គ្រងការហូរឈាមឲ្យលឿន',
        );
      case 'burns':
        return AppText.t(
          context,
          en: 'Cool, cover, protect',
          km: 'ត្រជាក់ គ្រប និងការពារ',
        );
      case 'choking':
        return AppText.t(context, en: 'Clear the airway', km: 'បើកផ្លូវដង្ហើម');
      case 'cpr':
        return AppText.t(
          context,
          en: 'Life-saving rhythm',
          km: 'ចង្វាក់សង្គ្រោះជីវិត',
        );
      case 'snake bite':
        return AppText.t(
          context,
          en: 'Immobilize and get help',
          km: 'មិនឲ្យចលនា និងស្នើជំនួយ',
        );
      default:
        return AppText.t(
          context,
          en: 'Open the emergency steps',
          km: 'បើកជំហានបន្ទាន់',
        );
    }
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<String> steps,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FirstAidDetailScreen(
          title: title,
          subtitle: subtitle,
          steps: steps,
          user: widget.user,
          token: widget.token,
          onUserUpdated: widget.onUserUpdated,
          onLogout: widget.onLogout,
          tips: [],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const _HeaderBar({required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.primaryRed, size: 18),
        const SizedBox(width: 4),
        const Text('KhmerSOS', style: AppTextStyles.appTitle),
        const Spacer(),
        IconButton(
          onPressed: onSettingsTap,
          icon: Icon(
            Icons.settings_outlined,
            size: 22,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _TrainingBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _TrainingBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 195,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF4D4D), Color(0xFFD50032)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              bottom: -8,
              child: Icon(
                Icons.medical_services,
                size: 145,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    AppText.t(
                      context,
                      en: 'TRAINING MODULES AVAILABLE',
                      km: 'មានម៉ូឌុលបណ្តុះបណ្តាល',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppInfoChip(
                    label: AppText.t(
                      context,
                      en: 'Tap to open',
                      km: 'ចុចដើម្បីបើក',
                    ),
                    backgroundColor: Color(0x33FFFFFF),
                    textColor: Colors.white,
                    icon: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingModuleScreen extends StatelessWidget {
  const TrainingModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppColors.primaryRed,
        title: Text(
          AppText.t(context, en: 'Training Modules', km: 'ម៉ូឌុលបណ្តុះបណ្តាល'),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        itemCount: _trainingItems.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = _trainingItems[index];
          return Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => _TrainingVideoDialog(item: item),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.75),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.primaryRed.withValues(alpha: 0.16)
                            : AppColors.lightRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.play_circle_fill,
                        color: AppColors.primaryRed,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.localizedTitle(context),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.localizedSubtitle(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white70
                                  : AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrainingVideoDialog extends StatefulWidget {
  final _TrainingItem item;

  const _TrainingVideoDialog({required this.item});

  @override
  State<_TrainingVideoDialog> createState() => _TrainingVideoDialogState();
}

class _TrainingVideoDialogState extends State<_TrainingVideoDialog> {
  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.item.videoUrl);
    _initializeFuture = _controller.initialize().then((_) {
      _controller
        ..setLooping(true)
        ..play();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.localizedTitle(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FutureBuilder<void>(
                future: _initializeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text(
                            AppText.t(
                              context,
                              en: 'Loading training video...',
                              km: 'កំពុងផ្ទុកវីដេអូបណ្តុះបណ្តាល...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: !_controller.value.isInitialized
                  ? AppText.t(context, en: 'Loading...', km: 'កំពុងផ្ទុក...')
                  : _controller.value.isPlaying
                  ? AppText.t(context, en: 'Pause', km: 'ផ្អាក')
                  : AppText.t(context, en: 'Play', km: 'ចាក់'),
              icon: _controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              onPressed: !_controller.value.isInitialized
                  ? null
                  : () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ScenarioRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.75),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.waves_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
