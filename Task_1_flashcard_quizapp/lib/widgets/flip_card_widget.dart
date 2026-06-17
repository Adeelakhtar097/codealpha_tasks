import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlipCardWidget extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool isFront;
  final VoidCallback onTap;

  const FlipCardWidget({
    super.key,
    required this.front,
    required this.back,
    required this.isFront,
    required this.onTap,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Initial state setup
    if (!widget.isFront) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFront != oldWidget.isFront) {
      if (widget.isFront) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final double value = _animation.value;
          final double angle = value * math.pi;
          
          // Midpoint scale down for 3D depth effect
          final double scale = 1.0 - (value - 0.5).abs() * 0.12;

          return Transform.scale(
            scale: scale,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // 3D Perspective
                ..rotateY(angle),
              alignment: Alignment.center,
              child: angle < math.pi / 2
                  ? widget.front
                  : Transform(
                      transform: Matrix4.identity()..rotateY(math.pi),
                      alignment: Alignment.center,
                      child: widget.back,
                    ),
            ),
          );
        },
      ),
    );
  }
}
