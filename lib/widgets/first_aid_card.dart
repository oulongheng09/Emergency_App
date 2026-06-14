import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FirstAidCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
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
    this.onTap,
    this.backgroundColor = AppColors.card,
    this.foregroundColor = AppColors.textDark,
    this.borderColor = AppColors.border,
    this.radius = 16,
    this.iconSize = 70,
    this.height = 120,
    this.padding = const EdgeInsets.all(16),
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  State<FirstAidCard> createState() => _FirstAidCardState();
}

class _FirstAidCardState extends State<FirstAidCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
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
    final card = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: widget.borderColor),
          boxShadow: [
            BoxShadow(
              color: widget.foregroundColor.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: widget.alignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: widget.foregroundColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.foregroundColor,
                size: widget.iconSize * 0.55,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: widget.foregroundColor,
              ),
            ),

            if (widget.subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                widget.subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: widget.foregroundColor,
                ),
              ),
            ],
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
        splashColor: widget.foregroundColor.withValues(alpha: 0.12),
        highlightColor: widget.foregroundColor.withValues(alpha: 0.05),
        onTap: _handleTap,
        child: card,
      ),
    );
  }
}