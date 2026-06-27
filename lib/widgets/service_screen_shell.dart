import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceScreenShell extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  const ServiceScreenShell({
    super.key,
    required this.title,
    required this.child,
    this.actions = const <Widget>[],
    this.onSettingsTap,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 10, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                  ...actions,
                  if (actions.isEmpty)
                    IconButton(
                      onPressed: onSettingsTap,
                      icon: Icon(
                        Icons.settings_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
