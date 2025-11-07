import 'package:flutter/material.dart';

class DaoTaoPage extends StatelessWidget {
  const DaoTaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          _buildHero("🧠 Đào tạo & Nhân lực số", "Phát triển đội ngũ chuyên gia công nghệ tương lai."),
          _buildSection("Giới thiệu", "AICOM Group cung cấp các chương trình đào tạo kỹ năng số, AI, và chuyển đổi công nghệ dành cho doanh nghiệp và cá nhân."),
          _buildSection("Dịch vụ chính", "• Đào tạo AI / Data Science\n• Upskill đội ngũ kỹ sư phần mềm\n• Hỗ trợ nhân lực số cho doanh nghiệp"),
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
        padding: const EdgeInsets.all(40),
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

