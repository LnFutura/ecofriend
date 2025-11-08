import 'package:flutter/material.dart';

/// Виджет белой декоративной волны (как в дизайне Figma)
class WaveDecoration extends StatelessWidget {
  final Widget child;
  final double height;
  
  const WaveDecoration({
    super.key,
    required this.child,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Волна на фоне
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, height),
            painter: _WavePainter(),
          ),
          // Контент поверх волны
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter для рисования волны
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Начинаем с левого верхнего угла с волной
    path.moveTo(0, size.height * 0.25);
    
    // Рисуем верхнюю волнистую линию
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.25,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width,
      size.height * 0.25,
    );
    
    // Идём вниз по правому краю
    path.lineTo(size.width, size.height);
    // Идём влево по низу
    path.lineTo(0, size.height);
    // Замыкаем путь
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

