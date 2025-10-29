import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/news_provider.dart';
import '../../utils/theme.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({
    super.key,
    required this.newsId,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Загружаем новость при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false)
          .fetchNewsById(widget.newsId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    final provider = Provider.of<NewsProvider>(context, listen: false);
    final success = await provider.addComment(
      widget.newsId,
      _commentController.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      _commentController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Комментарий добавлен'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Ошибка'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'environment':
        return 'Экология';
      case 'recycling':
        return 'Переработка';
      case 'events':
        return 'События';
      case 'tips':
        return 'Советы';
      case 'news':
        return 'Новости';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'environment':
        return Icons.eco;
      case 'recycling':
        return Icons.recycling;
      case 'events':
        return Icons.event;
      case 'tips':
        return Icons.lightbulb;
      case 'news':
        return Icons.article;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новость'),
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchNewsById(widget.newsId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          final news = provider.selectedNews;
          if (news == null) {
            return const Center(
              child: Text('Новость не найдена'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение
                if (news.thumbnail != null)
                  Image.network(
                    news.thumbnail!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Категория и дата
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(news.category),
                                  size: 16,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getCategoryName(news.category),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('dd MMMM yyyy', 'ru')
                                .format(news.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Заголовок
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Автор
                      if (news.authorName != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              news.authorName!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),

                      // Контент
                      Text(
                        news.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Лайки
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              provider.likeNews(news.id);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: news.likesCount > 0
                                  ? AppTheme.errorRed
                                  : Colors.white,
                            ),
                            label: Text('${news.likesCount} лайков'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${news.commentsCount} комментариев',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Комментарии
                      const Text(
                        'Комментарии',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Форма добавления комментария
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  hintText: 'Напишите комментарий...',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                enabled: !_isSubmitting,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitComment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryGreen,
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Отправить'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Список комментариев
                      if (news.comments.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'Комментариев пока нет',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...news.comments.map((comment) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              AppTheme.primaryGreen,
                                          child: Text(
                                            comment.username?[0]
                                                    .toUpperCase() ??
                                                'A',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment.username ?? 'Аноним',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('dd MMM yyyy, HH:mm',
                                                      'ru')
                                                  .format(comment.createdAt),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(comment.text),
                                  ],
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

