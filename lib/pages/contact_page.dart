import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
                children: [
                  const Text(
                    'LIÊN HỆ AICOM GROUP',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD)),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Email: info.aicomgroup.vn@gmail.com\n'
                    'Địa chỉ: 20/13/12 Đường Bình Chiểu, Phường Tam Bình, TP. Hồ Chí Minh\n'
                    'Chi nhánh: 101 Lê Văn Thịnh, TP. Thủ Đức\n'
                    'Văn phòng Đồng Nai: 122 tổ 5, xã Dầu Giây',
                    style: TextStyle(fontSize: 18, height: 1.7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        TextField(decoration: InputDecoration(labelText: 'Họ tên')),
                        TextField(decoration: InputDecoration(labelText: 'Email')),
                        TextField(
                          decoration: InputDecoration(labelText: 'Nội dung'),
                          maxLines: 5,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: null,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(0xFF004AAD)),
                          ),
                          child: Text('Gửi liên hệ'),
                        ),
                      ],
                    ),
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

