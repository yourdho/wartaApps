import 'package:flutter/material.dart';
import 'package:wartaapps/models/news_model.dart';
import 'package:wartaapps/services/news_service.dart';
import 'package:wartaapps/utils/Storage.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final NewsService _newsService = NewsService();
  late Future<SingleNewsResponse> _newsFuture;
  News? _initialNews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is News) {
      _initialNews = args;
      _newsFuture = _fetchNews(_initialNews!.slug);
    } else if (args is String) {
      _newsFuture = _fetchNews(args);
    }
  }

  Future<SingleNewsResponse> _fetchNews(String slug) async {
    try {
      final response = await _newsService.getNewsBySlug(slug);
      if (Storage.getIsLoggedIn()) {
        await _newsService.getNewsBySlug(slug);
      }
      return response;
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/images/logos_warta.png', height: 36),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2B4D8C)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF2B4D8C)),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<SingleNewsResponse>(
        future: _newsFuture,
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
                    'Error loading article',
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
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
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
                    'Article not found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          final news = snapshot.data!.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Featured Image
                if (news.featuredImageUrl != null)
                  Hero(
                    tag: news.id,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          news.featuredImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                color: Colors.grey[100],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (news.category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B4D8C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          news.category!.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF2B4D8C),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            news.isPublished
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        news.isPublished ? 'PUBLISHED' : 'DRAFT',
                        style: TextStyle(
                          color:
                              news.isPublished
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (news.authorAvatar != null)
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(news.authorAvatar!),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (news.authorName != null)
                            Text(
                              news.authorName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          if (news.publishedAt != null)
                            Text(
                              _formatDate(news.publishedAt!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // View Count
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${news.viewCount}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (news.summary != null && news.summary!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B4D8C).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2B4D8C).withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      news.summary!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  news.content ?? 'No content available',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Article Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2B4D8C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      if (news.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              news.tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          _buildTableRow(
                            'Created',
                            _formatDateTime(news.createdAt),
                          ),
                          _buildTableRow(
                            'Updated',
                            _formatDateTime(news.updatedAt),
                          ),
                          _buildTableRow(
                            'Status',
                            news.isPublished ? 'Published' : 'Draft',
                            valueColor:
                                news.isPublished
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (news.authorBio != null && news.authorBio!.isNotEmpty) ...[
                  const Text(
                    'About the Author',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2B4D8C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.authorAvatar != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(news.authorAvatar!),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (news.authorName != null)
                              Text(
                                news.authorName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              news.authorBio!,
                              style: const TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, {Color? valueColor}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: TextStyle(color: Colors.grey[600])),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
    return '${date.day} ${months[date.month - 1]} ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
