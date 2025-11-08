import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.hiking, AppTheme.primaryGreen, 'Экопоходы'),
          _buildNavItem(1, Icons.school, AppTheme.primaryPurple, 'Обучение'),
          _buildNavItem(2, Icons.article, AppTheme.lightRed, 'Новости'),
          _buildNavItem(3, Icons.location_on, AppTheme.primaryOrange, 'Карта'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, Color backgroundColor, String tooltip) {
    final isSelected = currentIndex == index;
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppTheme.textDark,
              width: isSelected ? 3 : 2,
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.textDark,
            size: isSelected ? 32 : 28,
          ),
        ),
      ),
    );
  }
}

