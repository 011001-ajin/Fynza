import 'package:flutter/material.dart';

class FadingScrollBoundary extends StatefulWidget {
  final Widget child;
  final double fadeExtent;

  const FadingScrollBoundary({
    super.key,
    required this.child,
    this.fadeExtent = 28,
  });

  @override
  State<FadingScrollBoundary> createState() => _FadingScrollBoundaryState();
}

class _FadingScrollBoundaryState extends State<FadingScrollBoundary> {
  double _topFade = 0;
  double _bottomFade = 0;

  bool _handleNotification(Notification notification) {
    final ScrollMetrics metrics;
    final int depth;
    if (notification is ScrollNotification) {
      metrics = notification.metrics;
      depth = notification.depth;
    } else if (notification is ScrollMetricsNotification) {
      metrics = notification.metrics;
      depth = notification.depth;
    } else {
      return false;
    }

    if (depth != 0 ||
        metrics.axis != Axis.vertical ||
        widget.fadeExtent <= 0) {
      return false;
    }

    final hasScrollRange = metrics.maxScrollExtent > metrics.minScrollExtent;
    final topFade = hasScrollRange
        ? ((metrics.pixels - metrics.minScrollExtent) / widget.fadeExtent)
              .clamp(0.0, 1.0)
              .toDouble()
        : 0.0;
    final bottomFade = hasScrollRange
        ? ((metrics.maxScrollExtent - metrics.pixels) / widget.fadeExtent)
              .clamp(0.0, 1.0)
              .toDouble()
        : 0.0;

    if ((topFade - _topFade).abs() > 0.01 ||
        (bottomFade - _bottomFade).abs() > 0.01) {
      setState(() {
        _topFade = topFade;
        _bottomFade = bottomFade;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: _handleNotification,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          if (bounds.height <= 0 || widget.fadeExtent <= 0) {
            return const LinearGradient(
              colors: [Colors.black, Colors.black],
            ).createShader(bounds);
          }

          final edgeRatio = (widget.fadeExtent / bounds.height)
              .clamp(0.0, 0.4)
              .toDouble();
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 1 - _topFade),
              Colors.black,
              Colors.black,
              Colors.black.withValues(alpha: 1 - _bottomFade),
            ],
            stops: [0, edgeRatio, 1 - edgeRatio, 1],
          ).createShader(bounds);
        },
        child: widget.child,
      ),
    );
  }
}
