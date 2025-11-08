import 'package:flutter/material.dart';

/// Виджет фона с декоративными следами лап (как в дизайне Figma)
class PawPrintsBackground extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  
  const PawPrintsBackground({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          // Декоративные следы лап (более заметные)
          Positioned(
            top: 50,
            right: 30,
            child: _PawPrint(size: 70, opacity: 0.12),
          ),
          Positioned(
            top: 180,
            left: 50,
            child: _PawPrint(size: 60, opacity: 0.1),
          ),
          Positioned(
            top: 350,
            right: 40,
            child: _PawPrint(size: 65, opacity: 0.13),
          ),
          Positioned(
            bottom: 300,
            left: 60,
            child: _PawPrint(size: 75, opacity: 0.11),
          ),
          Positioned(
            bottom: 150,
            right: 70,
            child: _PawPrint(size: 80, opacity: 0.12),
          ),
          Positioned(
            bottom: 60,
            left: 30,
            child: _PawPrint(size: 70, opacity: 0.1),
          ),
          // Основной контент
          child,
        ],
      ),
    );
  }
}

/// Виджет одного следа лапы
class _PawPrint extends StatelessWidget {
  final double size;
  final double opacity;
  
  const _PawPrint({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PawPrintPainter(),
      ),
    );
  }
}

/// Painter для рисования следа лапы
class _PawPrintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Центральная подушечка (большая)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.6),
        width: size.width * 0.4,
        height: size.height * 0.5,
      ),
      paint,
    );

    // Верхние пальчики (4 маленьких овала)
    // Левый пальчик
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.25),
        width: size.width * 0.2,
        height: size.height * 0.25,
      ),
      paint,
    );

    // Центральный левый пальчик
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.15),
        width: size.width * 0.2,
        height: size.height * 0.25,
      ),
      paint,
    );

    // Центральный правый пальчик
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.15),
        width: size.width * 0.2,
        height: size.height * 0.25,
      ),
      paint,
    );

    // Правый пальчик
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.25),
        width: size.width * 0.2,
        height: size.height * 0.25,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

