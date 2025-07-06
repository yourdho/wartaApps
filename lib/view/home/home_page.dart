import 'package:flutter/material.dart';
import 'package:wartaapps/models/news_model.dart';
import 'package:wartaapps/routes/app_routes.dart';
import 'package:wartaapps/services/news_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  final List<String> categories = [
    'All',
    'Bisnis',
    'Teknologi',
    'Olahraga',
    'Hiburan',
    'Politik',
  ];

  late Future<NewsResponse> _newsFuture;
  int _selectedCategoryIndex = 0;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchNews();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<NewsResponse> _fetchNews() async {
    return await _newsService.getPublishedNews(
      page: _currentPage,
      limit: _itemsPerPage,
      category:
          _selectedCategoryIndex > 0
              ? categories[_selectedCategoryIndex]
              : null,
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreNews();
    }
  }

  Future<void> _loadMoreNews() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    _currentPage++;

    try {
      final newNews = await _fetchNews();
      setState(() {
        _newsFuture = _newsFuture.then((existingNews) {
          return NewsResponse(
            success: existingNews.success,
            message: existingNews.message,
            data: [...existingNews.data, ...newNews.data],
            pagination: newNews.pagination,
          );
        });
      });
    } catch (e) {
      debugPrint('Error loading more news: $e');
      _currentPage--;
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void _refreshNews() {
    setState(() {
      _currentPage = 1;
      _newsFuture = _fetchNews();
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _currentPage = 1;
      _newsFuture = _fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logos_warta.png', height: 36),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshNews(),
        child: FutureBuilder<NewsResponse>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_isLoadingMore) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Gagal memuat berita'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshNews,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(child: Text('Tidak ada berita tersedia'));
            }
            final newsResponse = snapshot.data!;
            final newsList = newsResponse.data;
            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari berita...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _newsFuture = _newsService.getPublishedNews(
                              search: value,
                              category:
                                  _selectedCategoryIndex > 0
                                      ? categories[_selectedCategoryIndex]
                                      : null,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return ChoiceChip(
                        label: Text(categories[index]),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2B4D8C),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) => _onCategorySelected(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ...newsList.map((news) => NewsCard(news: news)).toList(),
                if (_isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (newsResponse.pagination?.hasNext == false)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Anda telah mencapai akhir daftar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;
  const NewsCard({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail, arguments: news);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.featuredImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  news.featuredImageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (news.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news.category!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (news.publishedAt != null)
                        Text(
                          _formatDate(news.publishedAt!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (news.summary != null)
                    Text(
                      news.summary!,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (news.authorAvatar != null)
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(news.authorAvatar!),
                        ),
                      if (news.authorName != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            news.authorName!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.viewCount}',
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} bulan lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inMinutes} menit lalu';
    }
  }
}
