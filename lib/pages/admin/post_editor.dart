import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../api_client.dart';
import '../../config.dart';

class PostEditorPage extends StatefulWidget {
  const PostEditorPage({super.key});

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  bool loading = false;
  Map<String, dynamic>? editingPost;

  String? imageUrl;
  String? videoUrl;
  String selectedCategory = "Tin tức";

  final List<String> categories = [
    "Dịch vụ",
    "Dự án",
    "Tin tức",
    "Thư viện",
    "Tuyển dụng",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      editingPost = args;
      titleCtrl.text = args['title'] ?? '';
      contentCtrl.text = args['content'] ?? '';
      imageUrl = args['image'];
      videoUrl = args['video'];
      selectedCategory = args['category'] ?? "Tin tức";
    }
  }

  /// 🖼️ Upload ảnh hoặc video
  Future<void> _pickAndUploadFile({required bool isImage}) async {
    final result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.video,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      final api = ApiClient();
      setState(() => loading = true);
      final uploadedUrl = await api.uploadFile(fileBytes, fileName);
      setState(() => loading = false);

      if (uploadedUrl != null) {
        setState(() {
          if (isImage) {
            imageUrl = uploadedUrl;
          } else {
            videoUrl = uploadedUrl;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Upload thành công: $uploadedUrl")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Upload thất bại")),
        );
      }
    }
  }

  /// 💾 Lưu hoặc cập nhật bài viết
  Future<void> _savePost() async {
    if (titleCtrl.text.trim().isEmpty || contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Vui lòng nhập tiêu đề và nội dung")),
      );
      return;
    }

    final api = ApiClient();
    setState(() => loading = true);

    final post = {
      "id": editingPost?["id"],
      "title": titleCtrl.text.trim(),
      "content": contentCtrl.text.trim(),
      "image": imageUrl,
      "video": videoUrl,
      "category": selectedCategory,
    };

    bool success;
    if (editingPost == null) {
      // ✅ Tạo bài viết mới → /api/posts/add
      success = await api.createPost(post);
    } else {
      // ✅ Cập nhật bài viết → /api/posts/update/<id>
      success = await api.updatePost(post);
    }

    setState(() => loading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingPost == null
                ? "✅ Đã đăng bài thành công"
                : "✅ Đã cập nhật bài viết",
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Không thể lưu bài viết")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingPost != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "✏️ Chỉnh sửa bài viết" : "📝 Đăng bài mới"),
        backgroundColor: const Color(0xFF004AAD),
        actions: [
          IconButton(
            onPressed: loading ? null : _savePost,
            icon: const Icon(Icons.save),
            tooltip: "Lưu bài viết",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Tiêu đề -----
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Tiêu đề bài viết",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // ----- Chuyên mục -----
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Chuyên mục",
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v ?? "Tin tức"),
            ),
            const SizedBox(height: 20),

            // ----- Nội dung -----
            TextField(
              controller: contentCtrl,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: "Nội dung bài viết",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // ----- Ảnh -----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ảnh minh họa:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _pickAndUploadFile(isImage: true),
                  icon: const Icon(Icons.image),
                  label: const Text("Tải ảnh lên"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${AppConfig.apiBaseUrl.replaceAll('/api', '')}$imageUrl",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 30),

            // ----- Video -----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Video (tùy chọn):",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _pickAndUploadFile(isImage: false),
                  icon: const Icon(Icons.video_call),
                  label: const Text("Tải video lên"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (videoUrl != null)
              Text("🎬 Video đã tải lên: $videoUrl",
                  style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 40),

            // ----- Nút lưu -----
            Center(
              child: ElevatedButton.icon(
                onPressed: loading ? null : _savePost,
                icon: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.save),
                label: Text(
                  loading
                      ? "Đang lưu..."
                      : (isEditing ? "Cập nhật bài viết" : "Đăng bài mới"),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AAD),
                  minimumSize: const Size(250, 45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

