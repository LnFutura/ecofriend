import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/news_provider.dart';
import '../../utils/theme.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем новости при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Эко-новости'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          // Фильтр по категориям
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (category) {
              Provider.of<NewsProvider>(context, listen: false)
                  .setCategoryFilter(category);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Все категории'),
              ),
              const PopupMenuItem(
                value: 'environment',
                child: Text('🌍 Экология'),
              ),
              const PopupMenuItem(
                value: 'recycling',
                child: Text('♻️ Переработка'),
              ),
              const PopupMenuItem(
                value: 'events',
                child: Text('📅 События'),
              ),
              const PopupMenuItem(
                value: 'tips',
                child: Text('💡 Советы'),
              ),
              const PopupMenuItem(
                value: 'news',
                child: Text('📰 Новости'),
              ),
            ],
          ),
        ],
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
                      provider.fetchNews();
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

          if (provider.newsList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Новостей пока нет',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchNews(),
            color: AppTheme.primaryGreen,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.newsList.length,
              itemBuilder: (context, index) {
                final news = provider.newsList[index];
                return _NewsCard(news: news);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final dynamic news;

  const _NewsCard({required this.news});

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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/news-detail',
            arguments: news.id,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение (если есть)
            if (news.thumbnail != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  news.thumbnail!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
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
                        DateFormat('dd MMM yyyy', 'ru').format(news.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Заголовок
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Превью контента
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Лайки и комментарии
                  Row(
                    children: [
                      // Лайки
                      InkWell(
                        onTap: () {
                          Provider.of<NewsProvider>(context, listen: false)
                              .likeNews(news.id);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: news.likesCount > 0
                                  ? AppTheme.errorRed
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${news.likesCount}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Комментарии
                      Row(
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.commentsCount}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

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
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

