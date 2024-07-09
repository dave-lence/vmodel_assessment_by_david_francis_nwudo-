import 'dart:math';

import 'package:flutter/material.dart';

class DottedLoader extends StatefulWidget {
  const DottedLoader({super.key});

  @override
  State<DottedLoader> createState() => _DottedLoaderState();
}

class _DottedLoaderState extends State<DottedLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.bounceIn);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      
      animation: _animation!,
      builder: (context, child) {
        return Center(
          child: CustomPaint(
            
            painter: DotPainter(_animation!.value),
            child: const SizedBox(
              width: 50,
              height: 50,
            ),
          ),
        );
      },
    );
  }
}

class DotPainter extends CustomPainter {
  final double progress;

  DotPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    double dotRadius = 5.0;
    int dotCount = 7;

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * pi / 4) + (progress * 2 * pi);
      double dx = radius + (radius - dotRadius) * cos(angle);
      double dy = radius + (radius - dotRadius) * sin(angle);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
