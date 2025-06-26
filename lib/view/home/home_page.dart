import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logos_warta.png', height: 36),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              // Image.asset('assets/images/logo_warta.png', width: 70),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari berita...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
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
                final cat = categories[index];
                final isSelected = index == 0;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2B4D8C),
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) {},
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 📰 Berita list
          ...articles.map((a) => NewsCard(article: a)).toList(),
        ],
      ),
    );
  }
}

// Contoh: Kategori
final categories = [
  'Trending',
  'Bisnis',
  'Teknologi',
  'Olahraga',
  'Hiburan',
  'Politik',
  'Kecantikan',
];

// Model Berita
class Article {
  final String title, source, imageUrl, time;
  Article(this.title, this.source, this.imageUrl, this.time);
}

// Contoh data
final articles = [
  Article(
    'Barca Hajar Madrid 4-0 Bukan Kemenangan Terbesar Blaugrana di El Clasico',
    'CNN Indonesia',
    'assets/images/barca.jpg',
    '2 jam lalu',
  ),
  Article(
    'Iran Tolak Mentah-Mentah Syarat AS soal Nuklir, OTW Perang Dunia 3?',
    'Kompas',
    'assets/images/wwc3.jpeg',
    '5 jam lalu',
  ),
  Article(
    'Barca Hajar Madrid 4-0 Bukan Kemenangan Terbesar Blaugrana di El Clasico',
    'CNN Indonesia',
    'assets/images/barca.jpg',
    '2 jam lalu',
  ),
  Article(
    'Barca Hajar Madrid 4-0 Bukan Kemenangan Terbesar Blaugrana di El Clasico',
    'CNN Indonesia',
    'assets/images/barca.jpg',
    '2 jam lalu',
  ),
  Article(
    'Barca Hajar Madrid 4-0 Bukan Kemenangan Terbesar Blaugrana di El Clasico',
    'CNN Indonesia',
    'assets/images/barca.jpg',
    '2 jam lalu',
  ),
  // Tambahkan berita lainnya
];

// 🧾 Card Berita
class NewsCard extends StatelessWidget {
  final Article article;
  const NewsCard({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: article);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                article.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.source,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
