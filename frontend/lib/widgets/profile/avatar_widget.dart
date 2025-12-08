import 'package:flutter/material.dart';
import '../../config/constants.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final VoidCallback onEditTap;
  final double width;  // Изменено: отдельные width и height
  final double height;

  const AvatarWidget({
    Key? key,
    this.avatarUrl,
    required this.displayName,
    required this.onEditTap,
    this.width = 78,   // Размеры из Figma
    this.height = 101,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Аватар с прямоугольной формой и закругленными краями
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Закругленные края из Figma
            border: Border.all(color: const Color(0xFF141414), width: 3),
            color: const Color(0xFF7FD17F), // Зеленый цвет как в Figma
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17), // Немного меньше для учета border
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    '${ApiConstants.serverUrl}$avatarUrl',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
        ),

        // Кнопка редактирования (edit-a-photo иконка в правом нижнем углу)
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 40,  // Размеры из Figma
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF41BBE8), // Голубой цвет
                borderRadius: BorderRadius.circular(10),
                // border убран как у nav bar
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Равен основному
                child: Image.asset(
                  'assets/icons/Эко Друг/edit-a-photo.png',
                  fit: BoxFit.cover, // Иконка заполняет контейнер
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Placeholder с инициалами пользователя
  Widget _buildPlaceholder() {
    String initials = _getInitials(displayName);

    return Container(
      color: const Color(0xFF7FD17F), // Зеленый цвет как в Figma
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: height * 0.35, // Используем height для размера шрифта
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Получить инициалы из имени
  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      // Имя и Фамилия -> ИФ
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      // Только имя -> первая буква
      return name.substring(0, 1).toUpperCase();
    }
  }
}

