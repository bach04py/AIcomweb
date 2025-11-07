import 'dart:ui';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final GlobalKey _serviceKey = GlobalKey();

  bool isDropdownVisible = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, dynamic>> services = [
    {
      "title": "Đào tạo & Nhân lực số",
      "icon": Icons.school_outlined,
      "route": "/services/dao-tao"
    },
    {
      "title": "Logistics & Thương mại số B2B",
      "icon": Icons.local_shipping_outlined,
      "route": "/services/logistics"
    },
    {
      "title": "Sơn - Sửa nhà cửa",
      "icon": Icons.home_repair_service_outlined,
      "route": "/services/son"
    },
    {
      "title": "Gia công phần mềm",
      "icon": Icons.code_outlined,
      "route": "/services/software"
    },
    {
      "title": "Tư vấn chiến lược số",
      "icon": Icons.analytics_outlined,
      "route": "/services/consulting"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _opacityAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _removeDropdown();
    _controller.dispose();
    super.dispose();
  }

  /// 🟢 Hiển thị dropdown bằng OverlayEntry
  void _showDropdown() {
    if (isDropdownVisible) return;

    final renderBox =
        _serviceKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;

    if (offset == null || size == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        child: MouseRegion(
          onEnter: (_) {},
          onExit: (_) => _hideDropdown(),
          child: FadeTransition(
            opacity: _opacityAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 280,
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: const Radius.circular(8),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: services.length,
                          itemBuilder: (context, i) {
                            final item = services[i];
                            return _buildSubMenuItem(
                              context,
                              item["title"],
                              item["route"],
                              item["icon"],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(from: 0);
    setState(() => isDropdownVisible = true);
  }

  /// 🔴 Ẩn dropdown
  void _hideDropdown() {
    if (!isDropdownVisible) return;
    _controller.reverse();
    Future.delayed(const Duration(milliseconds: 200), _removeDropdown);
  }

  void _removeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() => isDropdownVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ===== Logo =====
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/'),
            hoverColor: Colors.transparent,
            child: Row(
              children: [
                Image.asset('assets/images/aicom.png',
                    height: 50, fit: BoxFit.contain),
                const SizedBox(width: 10),
                const Text(
                  "AICOM GROUP",
                  style: TextStyle(
                    color: Color(0xFF004AAD),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // ===== Menu chính =====
          Row(
            children: [
              _buildMenuItem(context, "Trang chủ", "/"),
              _buildMenuItem(context, "Giới thiệu", "/about"),
              _buildServiceMenu(context),
              _buildMenuItem(context, "Dự án", "/projects"),
              _buildMenuItem(context, "Tin tức", "/news"),
              _buildMenuItem(context, "Thư viện", "/gallery"),
              _buildMenuItem(context, "Tuyển dụng", "/careers"),
              _buildMenuItem(context, "Liên hệ", "/contact"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _hideDropdown();
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceMenu(BuildContext context) {
    return MouseRegion(
      key: _serviceKey,
      onEnter: (_) => _showDropdown(),
      onExit: (_) {},
      child: GestureDetector(
        onTap: _showDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: const [
              Text(
                "Dịch vụ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(
      BuildContext context, String title, String route, IconData icon) {
    return InkWell(
      onTap: () {
        _hideDropdown();
        Navigator.pushNamed(context, route);
      },
      hoverColor: Colors.green.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.green.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

