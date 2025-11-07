import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Map<String, dynamic>? post;
  List relatedPosts = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args["id"] != null) {
      _loadPostDetail(args["id"]);
    }
  }

  /// 🔄 Tải chi tiết bài viết
  Future<void> _loadPostDetail(String id) async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/posts'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        final found = data.firstWhere((p) => p["id"] == id, orElse: () => null);
        if (found != null) {
          setState(() {
            post = found;
            relatedPosts = data
                .where((p) =>
                    p["id"] != id &&
                    p["category"] == found["category"])
                .take(3)
                .toList();
            loading = false;
          });
        } else {
          setState(() => loading = false);
        }
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
      backgroundColor: Colors.white,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : post == null
              ? const Center(child: Text("Không tìm thấy bài viết"))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Header(),

                      // 🌿 Tiêu đề bài viết
                      Container(
                        width: double.infinity,
                        color: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post!["category"]?.toUpperCase() ?? "TIN TỨC",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post!["title"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tác giả: ${post!["author_name"] ?? "Không rõ"} • ${post!["created_at"]?.substring(0, 10) ?? ""}",
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      // 🌿 Ảnh minh họa
                      if (post!["image"] != null && post!["image"].toString().isNotEmpty)
                        Image.network(
                          "${AppConfig.apiBaseUrl.replaceAll("/api", "")}${post!["image"]}",
                          width: double.infinity,
                          height: 450,
                          fit: BoxFit.cover,
                        ),

                      // 🌿 Nội dung
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post!["content"] ?? "",
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 18, height: 1.7, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),

                      // 🌿 Bài viết liên quan
                      if (relatedPosts.isNotEmpty)
                        Container(
                          color: const Color(0xFFF6FFF2),
                          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "BÀI VIẾT LIÊN QUAN",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Wrap(
                                spacing: 30,
                                runSpacing: 30,
                                children: relatedPosts
                                    .map((r) => _buildRelatedCard(context, r))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                      const Footer(),
                    ],
                  ),
                ),
    );
  }

  /// 🧱 Thẻ bài viết liên quan
  Widget _buildRelatedCard(BuildContext context, Map<String, dynamic> post) {
    final imageUrl = (post["image"] ?? "").toString().isNotEmpty
        ? "${AppConfig.apiBaseUrl.replaceAll('/api', '')}${post["image"]}"
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/post', arguments: {'id': post["id"]});
      },
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["title"] ?? "Không có tiêu đề",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post["content"]?.toString().substring(0, post["content"].toString().length > 100
                        ? 100
                        : post["content"].toString().length) ?? "",
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

