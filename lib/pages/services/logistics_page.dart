import 'package:flutter/material.dart';

class LogisticsPage extends StatelessWidget {
  const LogisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          _buildHero(
            "🚚 Logistics & Thương mại số B2B",
            "Giải pháp hậu cần và thương mại điện tử tối ưu cho doanh nghiệp.",
          ),
          _buildSection(
            "Giới thiệu",
            "AICOM Group cung cấp các giải pháp Logistics thông minh và hệ thống quản lý chuỗi cung ứng tích hợp dữ liệu thời gian thực, giúp doanh nghiệp tối ưu vận hành và tăng hiệu suất thương mại điện tử B2B.",
          ),
          _buildSection(
            "Giải pháp chính",
            "• Quản lý vận đơn và kho hàng bằng AI\n• Nền tảng thương mại số B2B tùy chỉnh\n• Hệ thống kết nối nhà cung cấp - đối tác - khách hàng\n• Báo cáo phân tích tự động (Business Intelligence)",
          ),
          _buildSection(
            "Giá trị mang lại",
            "• Giảm 30% chi phí vận hành logistics\n• Nâng cao tốc độ xử lý đơn hàng gấp 2 lần\n• Tối ưu mạng lưới cung ứng nhờ dữ liệu thời gian thực",
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildHero(String title, String subtitle) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 18)),
          ],
        ),
      );

  Widget _buildSection(String title, String content) => Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(content,
                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6)),
          ],
        ),
      );
}

