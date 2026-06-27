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

const _vidCpr = 'videos/cpr.mp4';
const _vidBurns = 'videos/burn.mp4';
const _vidBleeding = 'videos/bleeding.mp4';
const _vidChoking = 'videos/chocking.mp4';
const _vidSnakeBite = 'videos/snake bite.mp4';

class _TrainingItem {
  final String title;
  final String subtitle;
  final String videoUrl;

  const _TrainingItem({
    required this.title,
    required this.subtitle,
    required this.videoUrl,
  });
}

const _trainingItems = <_TrainingItem>[
  _TrainingItem(
    title: 'CPR',
    subtitle: 'Cardiopulmonary Resuscitation',
    videoUrl: _vidCpr,
  ),
  _TrainingItem(
    title: 'Burns',
    subtitle: 'Cool, cover, and protect',
    videoUrl: _vidBurns,
  ),
  _TrainingItem(
    title: 'Bleeding',
    subtitle: 'Pressure first',
    videoUrl: _vidBleeding,
  ),
  _TrainingItem(
    title: 'Choking',
    subtitle: 'Clear the airway',
    videoUrl: _vidChoking,
  ),
  _TrainingItem(
    title: 'Snake Bite',
    subtitle: 'Immobilize and get help',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
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
              const AppSectionTitle(
                title: 'First-Aid Guide',
                subtitle:
                    'Instant protocols for critical emergencies. Tap any category for immediate instructions.',
              ),
              const SizedBox(height: 22),
              FutureBuilder<List<FirstAidCategory>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final categories = snapshot.data ?? [];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      final color = _getCategoryColor(category.name);

                      return FirstAidCard(
                        title: category.name,
                        icon: _getCategoryIcon(category.name),
                        foregroundColor: color,
                        borderColor: color.withValues(alpha: 0.15),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            final data = await BackendApiService.instance
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
                                  subtitle: 'Emergency First Aid',
                                  tips: tips,
                                  heroIcon: _getCategoryIcon(category.name),
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
              const AppSectionTitle(title: 'OTHER SCENARIOS'),
              const SizedBox(height: 12),
              _ScenarioRow(
                label: 'Drowning',
                onTap: () => _openDetail(
                  context,
                  title: 'Drowning',
                  subtitle: 'Get the person to safety',
                  steps: const [
                    'Remove the person from water only if safe.',
                    'Call emergency services.',
                    'Start rescue breathing if trained.',
                    'Keep monitoring until help arrives.',
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _ScenarioRow(
                label: 'Electric Shock',
                onTap: () => _openDetail(
                  context,
                  title: 'Electric Shock',
                  subtitle: 'Disconnect power first',
                  steps: const [
                    'Turn off the power source if safe.',
                    'Do not touch the person until safe.',
                    'Call emergency services.',
                    'Check for breathing and injuries.',
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _ScenarioRow(
                label: 'Heat Stroke',
                onTap: () => _openDetail(
                  context,
                  title: 'Heat Stroke',
                  subtitle: 'Cool fast, call help',
                  steps: const [
                    'Move to a cool place immediately.',
                    'Remove excess clothing.',
                    'Cool with water and fans.',
                    'Call emergency services urgently.',
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  const Text(
                    'TRAINING MODULES AVAILABLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppInfoChip(
                    label: 'Tap to open',
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
        title: const Text('Training Modules'),
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
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
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
                    widget.item.title,
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
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Loading training video...'),
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
                  ? 'Loading...'
                  : _controller.value.isPlaying
                  ? 'Pause'
                  : 'Play',
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
