import 'package:flutter/material.dart';
import 'package:wartaapps/models/news_model.dart';
import 'package:wartaapps/routes/app_routes.dart';
import 'package:wartaapps/services/news_service.dart';

class MyArticlesPage extends StatefulWidget {
  const MyArticlesPage({super.key});

  @override
  State<MyArticlesPage> createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> {
  final NewsService _newsService = NewsService();
  late Future<NewsResponse> _articlesFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() {
    setState(() {
      _articlesFuture = _fetchMyArticles();
    });
    return _articlesFuture;
  }

  Future<NewsResponse> _fetchMyArticles() async {
    try {
      return await _newsService.getAuthorNews();
    } catch (e) {
      throw Exception('Failed to load articles: ${e.toString()}');
    }
  }

  Future<void> _deleteArticle(String id) async {
    try {
      await _newsService.deleteNews(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Article deleted successfully'),
            backgroundColor: Colors.green[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      _loadArticles(); // Refresh the list
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete article: ${e.toString()}'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _confirmDelete(News article) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Article'),
            content: Text(
              'Are you sure you want to delete "${article.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteArticle(article.id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Articles',
          style: TextStyle(
            color: Color(0xFF2B4D8C),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2B4D8C)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createArticle);
            },
            tooltip: 'Create new article',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2B4D8C)),
            onPressed: () => _refreshIndicatorKey.currentState?.show(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadArticles,
        color: const Color(0xFF2B4D8C),
        child: FutureBuilder<NewsResponse>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2B4D8C)),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading articles',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B4D8C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _loadArticles,
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No articles found',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B4D8C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.createArticle);
                      },
                      child: const Text(
                        'Create New Article',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
            final articles = snapshot.data!.data;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final article = articles[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: article,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Article Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Article Image
                              if (article.featuredImageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.featuredImageUrl!,
                                    width: 80,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          width: 80,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                  ),
                                )
                              else
                                Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.article_outlined,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      article.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Status and Date
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                article.isPublished
                                                    ? Colors.green[50]
                                                    : Colors.orange[50],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            article.isPublished
                                                ? 'Published'
                                                : 'Draft',
                                            style: TextStyle(
                                              color:
                                                  article.isPublished
                                                      ? Colors.green[700]
                                                      : Colors.orange[700],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (article.publishedAt != null)
                                          Text(
                                            _formatDate(article.publishedAt!),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${article.viewCount} views',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.editArticle,
                                    arguments: article,
                                  );
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                ),
                                onPressed: () => _confirmDelete(article),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
