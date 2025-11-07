// lib/pages/news_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List posts = [];
  bool loading = true;
  String selectedCategory = 'Tất cả';
  final List<String> categories = ['Tất cả', 'Dịch vụ', 'Dự án', 'Tin tức', 'Thư viện', 'Tuyển dụng'];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => loading = true);
    try {
      final query = selectedCategory == 'Tất cả' ? '' : '?category=${Uri.encodeComponent(selectedCategory)}';
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/posts$query'));
      if (res.statusCode == 200) {
        setState(() {
          posts = jsonDecode(res.body);
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              children: [
                const Text(
                  "📰 Tất cả bài viết",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF004AAD)),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => selectedCategory = v);
                    _loadPosts();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : posts.isEmpty
                    ? const Center(child: Text("Không có bài viết nào."))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final p = posts[index];
                          final imageUrl = (p["image"] ?? "").toString().isNotEmpty
                              ? "${AppConfig.apiBaseUrl.replaceAll('/api', '')}${p["image"]}"
                              : null;
                          return _buildPostCard(context, p, imageUrl);
                        },
                      ),
          ),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post, String? imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/post', arguments: {'id': post['id']});
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post["category"] ?? "Tin tức",
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(post["title"] ?? "Không có tiêu đề",
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    post["content"]?.toString().substring(0, (post["content"].toString().length > 90 ? 90 : post["content"].toString().length)) ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
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

