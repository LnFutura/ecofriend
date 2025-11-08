import 'package:flutter/material.dart';
import '../../utils/theme.dart';

/// Кастомная кнопка в стиле Figma (овальная с обводкой)
class FigmaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final EdgeInsets? padding;
  final bool isLoading;
  
  const FigmaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? AppTheme.textDark,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: borderColor ?? AppTheme.textDark,
              width: 2,
            ),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppTheme.textDark,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppTheme.textDark,
                ),
              ),
      ),
    );
  }
}

/// Маленькая иконка-кнопка в стиле Figma
class FigmaIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  
  const FigmaIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.textDark,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppTheme.textDark,
          size: size * 0.5,
        ),
      ),
    );
  }
}

