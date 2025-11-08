import 'package:flutter/material.dart';
import '../../utils/theme.dart';

/// Виджет облака для речевых пузырей (как в дизайне Figma)
class CloudBubble extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final bool showBubbles; // Показывать ли маленькие кружочки сверху
  
  const CloudBubble({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.padding,
    this.showBubbles = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBubbles) {
      // Без кружочков - простое облако
      return Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.textDark, width: 2),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }
    
    // С кружочками сверху (как в Figma)
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Маленькие кружочки сверху слева
        Positioned(
          top: -10,
          left: 30,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.textDark, width: 2),
            ),
          ),
        ),
        Positioned(
          top: -25,
          left: 15,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.textDark, width: 2),
            ),
          ),
        ),
        // Основное облако
        Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.textDark, width: 2),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Виджет облака с кастомным содержимым
class CloudBubbleCustom extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  
  const CloudBubbleCustom({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.textDark, width: 2),
      ),
      child: child,
    );
  }
}

/// Виджет облака с "хвостиком" (речевой пузырь медведя)
class ThoughtBubble extends StatelessWidget {
  final String text;
  final bool isLeft;
  
  const ThoughtBubble({
    super.key,
    required this.text,
    this.isLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Облако
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.textDark, width: 2),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        // Маленькие кружочки (хвостик облака мысли)
        Positioned(
          left: isLeft ? 20 : null,
          right: isLeft ? null : 20,
          bottom: -15,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.textDark, width: 2),
            ),
          ),
        ),
        Positioned(
          left: isLeft ? 10 : null,
          right: isLeft ? null : 10,
          bottom: -25,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.textDark, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

