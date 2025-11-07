import 'package:flutter/material.dart';

class SonPage extends StatelessWidget {
  const SonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          _buildHero(
            "🏠 Sơn - Sửa nhà cửa",
            "Dịch vụ cải tạo, sơn sửa nhà ở và văn phòng hiện đại – chuyên nghiệp – tiết kiệm.",
          ),
          _buildSection(
            "Giới thiệu",
            "AICOM Group phát triển dịch vụ sơn và sửa chữa nhà cửa với đội ngũ kỹ thuật chuyên nghiệp, sử dụng vật liệu thân thiện môi trường và công nghệ thi công tiên tiến, đảm bảo chất lượng và tiến độ.",
          ),
          _buildSection(
            "Dịch vụ cung cấp",
            "• Sơn lại nhà, văn phòng, công trình\n• Cải tạo nội thất, chống thấm, chống ẩm\n• Thi công trần - tường - sàn\n• Dịch vụ bảo trì định kỳ và vệ sinh công trình",
          ),
          _buildSection(
            "Cam kết chất lượng",
            "• Sử dụng sơn chính hãng, an toàn cho sức khỏe\n• Bảo hành dịch vụ lên đến 3 năm\n• Đội ngũ kỹ thuật viên được đào tạo chuyên sâu\n• Hỗ trợ khách hàng 24/7",
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

