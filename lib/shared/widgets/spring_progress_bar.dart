import 'package:flutter/material.dart';

class SpringProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;

  const SpringProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final progressColor = value > 1
        ? colors.error
        : value >= 0.8
        ? colors.tertiary
        : colors.primary;

    return LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: height,
      color: progressColor,
      backgroundColor: backgroundColor ?? colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}
