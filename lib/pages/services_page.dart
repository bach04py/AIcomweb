import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

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
                children: const [
                  Text(
                    'DỊCH VỤ CỦA AICOM GROUP',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD)),
                  ),
                  SizedBox(height: 30),
                  ServiceItem(
                    title: 'Sơn - Sửa Nhà Cửa',
                    desc:
                        'Cung cấp giải pháp cải tạo nhà ở chuyên nghiệp, chất lượng cao và an toàn.',
                  ),
                  ServiceItem(
                    title: 'Logistics & Thương Mại Số B2B',
                    desc:
                        'Kết nối doanh nghiệp thông qua các giải pháp vận chuyển và giao thương kỹ thuật số.',
                  ),
                  ServiceItem(
                    title: 'Đào Tạo & Nhân Lực Số',
                    desc:
                        'Phát triển nguồn nhân lực công nghệ và kỹ năng số cho doanh nghiệp Việt.',
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

class ServiceItem extends StatelessWidget {
  final String title;
  final String desc;
  const ServiceItem({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 10),
          Text(desc,
              style: const TextStyle(fontSize: 17, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

