import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List posts = [];
  bool loading = true;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _loadLatestPosts();
    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Future<void> _loadLatestPosts() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/posts'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          posts = data;
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
    final newsPosts =
        posts.where((p) => p["category"] == "Tin tức").take(6).toList();
    final servicePosts =
        posts.where((p) => p["category"] == "Dịch vụ").take(3).toList();
    final projectPosts =
        posts.where((p) => p["category"] == "Dự án").take(3).toList();
    final careerPosts =
        posts.where((p) => p["category"] == "Tuyển dụng").take(3).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Header(), // ✅ chỉ hiển thị 1 lần
            _buildHeroSection(),
            _buildCategories(context),
            _buildCategorySection("Tin tức nổi bật", newsPosts),
            _buildCategorySection("Dịch vụ", servicePosts),
            _buildCategorySection("Dự án", projectPosts),
            _buildCategorySection("Tuyển dụng", careerPosts),
            _buildSlogan(),
            const Footer(), // ✅ thêm footer ở cuối
          ],
        ),
      ),
    );
  }

  /// 🌈 Hero Section (màn mở đầu có hiệu ứng gradient động)
  Widget _buildHeroSection() {
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(
                    -1 + _gradientController.value * 2, -1 + _gradientController.value),
                end: Alignment(
                    1 - _gradientController.value * 2, 1 - _gradientController.value),
                colors: const [
                  Color(0xFF43A047),
                  Color(0xFF66BB6A),
                  Color(0xFF2E7D32),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AICOM GROUP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AnimatedText(),
                  const SizedBox(height: 16),
                  const Text(
                    "Giải pháp công nghệ toàn diện cho doanh nghiệp Việt",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildCTAButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCTAButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        label: const Text(
          "Khám phá ngay",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 6,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.hovered)
                ? Colors.green.shade900
                : Colors.green.shade700,
          ),
        ),
      ),
    );
  }

  /// 🌿 Lĩnh vực hoạt động
  Widget _buildCategories(BuildContext context) {
    return Container(
      color: const Color(0xFFF6FFF2),
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Text(
            "LĨNH VỰC HOẠT ĐỘNG",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 30,
            children: [
              _buildServiceCard(context),
              _buildCategoryCard("Dự án", Icons.domain),
              _buildCategoryCard("Tin tức", Icons.newspaper),
              _buildCategoryCard("Thư viện", Icons.photo_library),
              _buildCategoryCard("Tuyển dụng", Icons.people_alt),
            ],
          ),
        ],
      ),
    );
  }

  /// 🌱 Card “Dịch vụ” có menu con
  Widget _buildServiceCard(BuildContext context) {
    bool showSubmenu = false;
    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) => setState(() => showSubmenu = true),
        onExit: (_) => setState(() => showSubmenu = false),
        cursor: SystemMouseCursors.click,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 220,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.handshake, size: 48, color: Colors.green.shade700),
                  const SizedBox(height: 12),
                  const Text(
                    "Dịch vụ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),

            // Submenu hiển thị khi hover
            Positioned(
              top: 190,
              left: 0,
              child: AnimatedOpacity(
                opacity: showSubmenu ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Visibility(
                  visible: showSubmenu,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade100),
                      ),
                      child: Column(
                        children: [
                          _buildSubmenuItem(context, "🧠 Đào tạo & Nhân lực số",
                              '/services/dao-tao'),
                          _buildSubmenuItem(context,
                              "🚚 Logistics & Thương mại số B2B", '/services/logistics'),
                          _buildSubmenuItem(
                              context, "🏠 Sơn - Sửa nhà cửa", '/services/son'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubmenuItem(BuildContext context, String title, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      width: 220,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.green.shade700),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List data) {
    return Container(
      color: const Color(0xFFF6FFF2),
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 30),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (data.isEmpty)
            _buildPlaceholderGrid()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final p = data[index];
                final imageUrl = (p["image"] ?? "").toString().isNotEmpty
                    ? "${AppConfig.apiBaseUrl.replaceAll('/api', '')}${p["image"]}"
                    : null;
                return _buildPostCard(context, p, imageUrl);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
      BuildContext context, Map<String, dynamic> post, String? imageUrl) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(imageUrl,
                height: 160, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post["category"] ?? "Tin tức",
                  style: const TextStyle(
                    color: Color(0xFF66BB6A),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post["title"] ?? "Không có tiêu đề",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlogan() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF4CAF50),
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: const Center(
        child: Text(
          "AICOM GROUP – CÙNG BẠN XÂY DỰNG TƯƠNG LAI CÔNG NGHỆ XANH 🌿",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderGrid() {
    return const Center(child: Text("Đang cập nhật..."));
  }
}

/// 🌈 Text animation
class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  final List<String> texts = [
    "CÔNG NGHỆ",
    "SÁNG TẠO",
    "CHUYỂN ĐỔI SỐ",
    "TRÍ TUỆ NHÂN TẠO"
  ];
  int index = 0;
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => index = (index + 1) % texts.length);
      _controller.forward();
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(_fade),
        child: Text(
          texts[index],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 56,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

