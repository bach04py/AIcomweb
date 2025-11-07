import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Giới thiệu về AICOM GROUP',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'AICOM Group là tập đoàn hoạt động đa lĩnh vực trong các mảng công nghệ, dịch vụ và thương mại. '
                    'Chúng tôi hướng tới việc tạo ra giá trị thực thông qua tư duy sáng tạo và đội ngũ chuyên nghiệp.\n\n'
                    'Với sứ mệnh mang đến các giải pháp tối ưu cho khách hàng, AICOM không ngừng mở rộng mạng lưới dịch vụ trong và ngoài nước.',
                    style: TextStyle(fontSize: 18, height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

