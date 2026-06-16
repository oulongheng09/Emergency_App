import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmergencySosButton extends StatefulWidget {
  final Future<void> Function()? onTriggered;
  final bool enabled;
  final bool activated;
  final bool isBusy;

  const EmergencySosButton({
    super.key,
    this.onTriggered,
    this.enabled = true,
    this.activated = false,
    this.isBusy = false,
  });

  @override
  State<EmergencySosButton> createState() => _EmergencySosButtonState();
}

class _EmergencySosButtonState extends State<EmergencySosButton>
    with TickerProviderStateMixin {
  static const _holdDuration = Duration(seconds: 3);

  late final AnimationController _holdController;
  late final AnimationController _pulseController;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(vsync: this, duration: _holdDuration)
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed &&
            !_triggered &&
            widget.enabled &&
            !widget.isBusy) {
          _triggered = true;
          await widget.onTriggered?.call();
          if (mounted) {
            _holdController.value = 1;
          }
        }
      });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant EmergencySosButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activated) {
      _holdController.value = 1;
    } else if (!widget.isBusy && oldWidget.activated && !widget.activated) {
      _holdController.reset();
      _triggered = false;
    }
  }

  @override
  void dispose() {
    _holdController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startHold() {
    if (!widget.enabled || widget.isBusy || widget.activated) {
      return;
    }
    _triggered = false;
    _holdController.forward(from: 0);
  }

  void _cancelHold() {
    if (_triggered || widget.activated) {
      return;
    }
    _holdController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final buttonColor = widget.activated
        ? Colors.green.shade600
        : AppColors.primaryRed;
    final progressColor = widget.activated
        ? const Color(0xFF9AF8B6)
        : isDarkMode
        ? const Color(0xFF7CF7FF)
        : const Color(0xFFFFD166);
    final trackColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.24);

    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _cancelHold(),
      onTapCancel: _cancelHold,
      child: AnimatedBuilder(
        animation: Listenable.merge([_holdController, _pulseController]),
        builder: (context, _) {
          return Transform.scale(
            scale: widget.isBusy || widget.activated
                ? 1
                : _pulseController.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 154,
              height: 154,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(31),
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.30),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: progressColor.withValues(
                      alpha: widget.isBusy || widget.activated
                          ? 0.20
                          : _holdController.value * 0.22,
                    ),
                    blurRadius: 28,
                    spreadRadius: 1.5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(31),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: CustomPaint(
                          painter: _RoundedRectProgressPainter(
                            progress: widget.activated
                                ? 1
                                : _holdController.value,
                            progressColor: progressColor,
                            trackColor: trackColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SOS',
                          style: TextStyle(
                            fontSize: 39,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.isBusy
                              ? 'SENDING...'
                              : widget.activated
                              ? 'ACTIVE NOW'
                              : 'HOLD 3S',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
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

class _RoundedRectProgressPainter extends CustomPainter {
  const _RoundedRectProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
  });

  final double progress;
  final Color progressColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = progress.clamp(0.0, 1.0);
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(18));
    final path = Path()..addRRect(rRect);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.6
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = progressColor.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.3
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rRect, trackPaint);

    if (clamped <= 0) {
      return;
    }

    for (final metric in path.computeMetrics()) {
      final progressPath = metric.extractPath(0, metric.length * clamped);
      canvas.drawPath(progressPath, glowPaint);
      canvas.drawPath(progressPath, progressPaint);
    }

    final sweepDotOffset = _positionAlongRoundedRect(size, clamped);
    canvas.drawCircle(sweepDotOffset, 4.3, Paint()..color = progressColor);
  }

  Offset _positionAlongRoundedRect(Size size, double progress) {
    final width = size.width;
    final height = size.height;
    final radius = 18.0;
    final lineWidth = width - (2 * radius);
    final lineHeight = height - (2 * radius);
    final cornerArc = math.pi * radius / 2;
    final total = 2 * (lineWidth + lineHeight) + 4 * cornerArc;
    var distance = total * progress;

    if (distance <= lineWidth) {
      return Offset(radius + distance, 0);
    }
    distance -= lineWidth;

    if (distance <= cornerArc) {
      final angle = -math.pi / 2 + (distance / cornerArc) * (math.pi / 2);
      return Offset(
        width - radius + radius * math.cos(angle),
        radius + radius * math.sin(angle),
      );
    }
    distance -= cornerArc;

    if (distance <= lineHeight) {
      return Offset(width, radius + distance);
    }
    distance -= lineHeight;

    if (distance <= cornerArc) {
      final angle = (distance / cornerArc) * (math.pi / 2);
      return Offset(
        width - radius + radius * math.cos(angle),
        height - radius + radius * math.sin(angle),
      );
    }
    distance -= cornerArc;

    if (distance <= lineWidth) {
      return Offset(width - radius - distance, height);
    }
    distance -= lineWidth;

    if (distance <= cornerArc) {
      final angle = math.pi / 2 + (distance / cornerArc) * (math.pi / 2);
      return Offset(
        radius + radius * math.cos(angle),
        height - radius + radius * math.sin(angle),
      );
    }
    distance -= cornerArc;

    if (distance <= lineHeight) {
      return Offset(0, height - radius - distance);
    }
    distance -= lineHeight;

    final angle = math.pi + (distance / cornerArc) * (math.pi / 2);
    return Offset(
      radius + radius * math.cos(angle),
      radius + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _RoundedRectProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
