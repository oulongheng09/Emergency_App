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
    final colorScheme = Theme.of(context).colorScheme;
    final buttonColor = widget.activated
        ? Colors.green.shade600
        : AppColors.primaryRed;

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
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 182,
                  height: 182,
                  child: CircularProgressIndicator(
                    value: widget.activated ? 1 : _holdController.value,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.surface.withValues(
                      alpha: 0.55,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.activated ? Colors.green.shade400 : Colors.white,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 150,
                  height: 150,
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
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
