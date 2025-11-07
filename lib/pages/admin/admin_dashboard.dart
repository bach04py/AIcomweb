import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List posts = [];
  bool loading = true;
  String selectedCategory = 'Tất cả';

  final List<String> categories = [
    'Tất cả',
    'Dịch vụ',
    'Dự án',
    'Tin tức',
    'Thư viện',
    'Tuyển dụng'
  ];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  /// 📚 Tải danh sách bài viết
  Future<void> _loadPosts() async {
    try {
      setState(() => loading = true);
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/posts'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          posts = selectedCategory == 'Tất cả'
              ? data
              : data
                  .where((p) => p["category"] == selectedCategory)
                  .toList();
        });
      } else {
        debugPrint("⚠️ Lỗi tải bài viết: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi tải bài viết: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  /// ❌ Xóa bài viết
  Future<void> _deletePost(String id) async {
    try {
      final res =
          await http.delete(Uri.parse('${AppConfig.apiBaseUrl}/posts/delete/$id'));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Đã xóa bài viết")),
        );
        _loadPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi khi xóa: ${res.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi xóa bài viết: $e");
    }
  }

  /// 🧱 Giao diện chính
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("AICOM Admin Dashboard"),
        backgroundColor: const Color(0xFF004AAD),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/admin/post_editor');
              _loadPosts();
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Thêm bài viết mới",
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 🔢 Thống kê
                      _buildStatCard(
                        title: "Bài viết",
                        count: posts.length,
                        icon: Icons.article_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 24),

                      // 🧭 Bộ lọc chuyên mục
                      Row(
                        children: [
                          const Text(
                            "📚 Danh sách bài viết",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004AAD),
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: selectedCategory,
                            items: categories
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                selectedCategory = value;
                              });
                              _loadPosts();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 📋 Danh sách bài viết
                      posts.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(child: Text("Chưa có bài viết nào.")),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, i) {
                                final p = posts[i];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.blueAccent.withOpacity(0.15),
                                      child: const Icon(Icons.article,
                                          color: Colors.blueAccent),
                                    ),
                                    title: Text(
                                      p["title"] ?? "Không có tiêu đề",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      "📂 ${p["category"] ?? "Không rõ"} • "
                                      "${p["created_at"]?.substring(0, 10) ?? ""}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          tooltip: "Chỉnh sửa",
                                          onPressed: () async {
                                            await Navigator.pushNamed(
                                              context,
                                              '/admin/post_editor',
                                              arguments: p,
                                            );
                                            _loadPosts();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          tooltip: "Xóa bài viết",
                                          onPressed: () =>
                                              _confirmDelete(context, p),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF004AAD),
        icon: const Icon(Icons.add),
        label: const Text("Thêm bài viết"),
        onPressed: () async {
          await Navigator.pushNamed(context, '/admin/post_editor');
          _loadPosts();
        },
      ),
    );
  }

  /// 📊 Card thống kê
  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  /// 🗑️ Xác nhận xóa
  void _confirmDelete(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa bài viết"),
        content: Text("Bạn có chắc muốn xóa '${post["title"]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deletePost(post["id"]);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }
}

