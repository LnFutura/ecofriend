import 'package:flutter/material.dart';

/// Виджет медведя-талисмана
class BearMascot extends StatelessWidget {
  final double size;
  final bool withBag; // С мешком или без
  
  const BearMascot({
    super.key,
    this.size = 200,
    this.withBag = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      withBag 
        ? 'assets/icons/Эко Друг/Медведь с мешком.png'
        : 'assets/icons/Эко Друг/Медведь.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback если изображение не найдено
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.brown.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pets,
            size: size * 0.5,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// Виджет медведя с речевым пузырём
class BearWithThought extends StatelessWidget {
  final String thoughtText;
  final double bearSize;
  
  const BearWithThought({
    super.key,
    required this.thoughtText,
    this.bearSize = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Речевой пузырь
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            thoughtText,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        // Маленькие кружочки (хвостик облака)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ],
        ),
        // Медведь
        BearMascot(size: bearSize, withBag: false),
      ],
    );
  }
}

