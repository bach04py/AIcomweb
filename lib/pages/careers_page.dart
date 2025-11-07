import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(60),
              children: const [
                Text(
                  'TUYỂN DỤNG AICOM GROUP',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004AAD)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                JobItem(
                    title: 'Nhân viên Marketing Online',
                    desc:
                        'Yêu cầu kinh nghiệm digital marketing, biết chạy quảng cáo Facebook/Google.'),
                JobItem(
                    title: 'Nhân viên Logistics',
                    desc:
                        'Quản lý đơn hàng, theo dõi vận chuyển, giao tiếp với đối tác.'),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class JobItem extends StatelessWidget {
  final String title;
  final String desc;
  const JobItem({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Text(desc,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

