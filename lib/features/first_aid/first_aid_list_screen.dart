import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_info_chip.dart';
import '../../widgets/app_section_title.dart';
import '../../widgets/first_aid_card.dart';
import '../../widgets/primary_button.dart';
import 'first_aid_detail_screen.dart';

const _defaultTrainingVideoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

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
    videoUrl: _defaultTrainingVideoUrl,
  ),
  _TrainingItem(
    title: 'Burns',
    subtitle: 'Cool, cover, and protect',
    videoUrl: _defaultTrainingVideoUrl,
  ),
  _TrainingItem(
    title: 'Bleeding',
    subtitle: 'Pressure first',
    videoUrl: _defaultTrainingVideoUrl,
  ),
  _TrainingItem(
    title: 'Choking',
    subtitle: 'Clear the airway',
    videoUrl: _defaultTrainingVideoUrl,
  ),
  _TrainingItem(
    title: 'Snake Bite',
    subtitle: 'Immobilize and get help',
    videoUrl: _defaultTrainingVideoUrl,
  ),
];

class FirstAidListScreen extends StatelessWidget {
  const FirstAidListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderBar(onSettingsTap: () {}),
              const SizedBox(height: 28),
              const AppSectionTitle(
                title: 'First-Aid Guide',
                subtitle:
                    'Instant protocols for critical emergencies. Tap any category for immediate instructions.',
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FirstAidCard(
                  title: 'CPR',
                  subtitle: 'Cardiopulmonary Resuscitation',
                  icon: Icons.favorite,
                  height: 158,
                  radius: 18,
                  iconSize: 42,
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  borderColor: const Color(0xFF5D0A16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FirstAidDetailScreen(
                          title: 'CPR',
                          subtitle: 'Cardiopulmonary Resuscitation',
                          heroIcon: Icons.favorite,
                          emergencyCallLabel: 'EMERGENCY CALL: 119',
                          steps: [
                            'Ensure the environment is safe for you and the victim before approaching.',
                            'Tap the shoulders and shout "Are you okay?". Check for normal breathing.',
                            'If unresponsive, immediately call for help or tell someone to do it.',
                            'Push hard and fast in the center of the chest. Aim for 100-120 beats per minute.',
                            'Tilt head, lift chin, and give two breaths after 30 compressions. (Only if trained).',
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  FirstAidCard(
                    title: 'Burns',
                    icon: Icons.local_fire_department_outlined,
                    iconSize: 26,
                    height: 120,
                    foregroundColor: const Color(0xFFAA5A00),
                    backgroundColor: const Color(0xFFF4EEE8),
                    borderColor: const Color(0xFFD5C2B1),
                    onTap: () => _openDetail(
                      context,
                      title: 'Burns',
                      subtitle: 'Cool, cover, and protect',
                      steps: const [
                        'Cool the burn under cool running water.',
                        'Remove tight items before swelling starts.',
                        'Cover with a clean, non-stick dressing.',
                        'Do not apply ice or ointments directly.',
                      ],
                    ),
                  ),
                  FirstAidCard(
                    title: 'Bleeding',
                    icon: Icons.medical_services_outlined,
                    iconSize: 26,
                    height: 120,
                    foregroundColor: const Color(0xFFC8102E),
                    backgroundColor: const Color(0xFFF6ECEC),
                    borderColor: const Color(0xFFDDB7B7),
                    onTap: () => _openDetail(
                      context,
                      title: 'Bleeding',
                      subtitle: 'Pressure first',
                      steps: const [
                        'Apply direct pressure with a clean cloth.',
                        'Raise the injured area if possible.',
                        'Do not remove soaked cloth; add layers on top.',
                        'Seek urgent help if bleeding is severe.',
                      ],
                    ),
                  ),
                  FirstAidCard(
                    title: 'Snake Bite',
                    icon: Icons.warning_amber_outlined,
                    iconSize: 26,
                    height: 120,
                    foregroundColor: const Color(0xFF6C6C6C),
                    backgroundColor: const Color(0xFFF2F1F1),
                    borderColor: const Color(0xFFD4D4D4),
                    onTap: () => _openDetail(
                      context,
                      title: 'Snake Bite',
                      subtitle: 'Keep calm, immobilize, and get help',
                      steps: const [
                        'Keep the person calm and still.',
                        'Remove rings or tight clothing.',
                        'Immobilize the bitten area.',
                        'Get emergency help immediately.',
                      ],
                    ),
                  ),
                  FirstAidCard(
                    title: 'Choking',
                    icon: Icons.air,
                    iconSize: 26,
                    height: 120,
                    foregroundColor: const Color(0xFF0057B8),
                    backgroundColor: const Color(0xFFF0F5FB),
                    borderColor: const Color(0xFFC4D7EC),
                    onTap: () => _openDetail(
                      context,
                      title: 'Choking',
                      subtitle: 'Clear the airway',
                      steps: const [
                        'Ask if the person can speak or cough.',
                        'Give back blows if needed.',
                        'Perform abdominal thrusts if trained.',
                        'Call emergency services right away.',
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
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
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.primaryRed, size: 18),
        const SizedBox(width: 4),
        const Text('KhmerSOS', style: AppTextStyles.appTitle),
        const Spacer(),
        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(Icons.settings_outlined, size: 22),
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
            colors: [Color(0xFF3A3A3A), Color(0xFF121212)],
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
            color: AppColors.card,
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
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.lightRed,
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textDark),
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
    _controller = VideoPlayerController.network(widget.item.videoUrl);
    _initializeFuture = _controller.initialize().then((_) => setState(() {}));
    _controller.setLooping(true);
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
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
                    color: AppColors.card,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: _controller.value.isPlaying ? 'Pause' : 'Play',
              icon: _controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              onPressed: () {
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
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.waves_rounded,
                size: 20,
                color: AppColors.textDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textDark),
            ],
          ),
        ),
      ),
    );
  }
}
