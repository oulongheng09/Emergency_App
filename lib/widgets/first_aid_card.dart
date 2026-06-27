import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FirstAidCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? helperText;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color accentColor;
  final double radius;
  final double iconSize;
  final double height;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment alignment;

  const FirstAidCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.helperText,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.accentColor = AppColors.primaryRed,
    this.radius = 16,
    this.iconSize = 66,
    this.height = 132,
    this.padding = const EdgeInsets.all(14),
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  State<FirstAidCard> createState() => _FirstAidCardState();
}

class _FirstAidCardState extends State<FirstAidCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();

    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final resolvedForeground =
        widget.foregroundColor ?? theme.colorScheme.onSurface;
    final resolvedBackground =
        widget.backgroundColor ?? theme.colorScheme.surface;
    final resolvedBorder =
        widget.borderColor ??
        theme.dividerColor.withValues(alpha: isDarkMode ? 0.85 : 0.7);
    final titleStyle = AppTextStyles.sectionTitle.copyWith(
      color: resolvedForeground,
      fontSize: 15,
    );
    final bodyStyle = AppTextStyles.body.copyWith(
      color: resolvedForeground.withValues(alpha: 0.75),
      height: 1.3,
    );

    final card = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(
                    resolvedBackground,
                    widget.accentColor,
                    isDarkMode ? 0.18 : 0.08,
                  ) ??
                  resolvedBackground,
              resolvedBackground,
            ],
          ),
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: resolvedBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.28 : 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: widget.alignment,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(
                      alpha: isDarkMode ? 0.22 : 0.12,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(
                          alpha: isDarkMode ? 0.16 : 0.08,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.accentColor,
                    size: widget.iconSize * 0.42,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: resolvedForeground.withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: widget.alignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  textAlign: widget.alignment == CrossAxisAlignment.center
                      ? TextAlign.center
                      : TextAlign.start,
                  style: titleStyle,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    textAlign: widget.alignment == CrossAxisAlignment.center
                        ? TextAlign.center
                        : TextAlign.start,
                    style: bodyStyle,
                  ),
                ],
                if (widget.helperText != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: widget.alignment == CrossAxisAlignment.center
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(
                          alpha: isDarkMode ? 0.16 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: widget.accentColor.withValues(
                            alpha: isDarkMode ? 0.24 : 0.16,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.helperText!,
                        style: TextStyle(
                          color: widget.accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );

    if (widget.onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.radius),
        splashColor: resolvedForeground.withValues(alpha: 0.12),
        highlightColor: resolvedForeground.withValues(alpha: 0.05),
        onTap: _handleTap,
        child: card,
      ),
    );
  }
}
