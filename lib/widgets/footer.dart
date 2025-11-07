import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ai.png',
            height: 60,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported),
          ),
          const SizedBox(height: 25),
          const Text(
            'CÔNG TY TNHH TẬP ĐOÀN AICOM',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mã số thuế: 0318981019',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Địa chỉ: Số 20/13/12 Đường Bình Chiểu, Khu phố 30, Phường Tam Bình, TP. Hồ Chí Minh, Việt Nam.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Liên hệ: info.aicomgroup.vn@gmail.com | 101 Lê Văn Thịnh, TP. Thủ Đức | Đồng Nai: 122 tổ 5, xã Dầu Giây.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.black26, thickness: 0.5),
          const SizedBox(height: 10),
          const Text(
            '© 2025 AICOM Group - All Rights Reserved',
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

