import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://aicomgroup.vn/wp-content/uploads/2023/04/aicom-banner.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 500,
        ),
        Container(
          height: 500,
          color: Colors.black.withOpacity(0.4),
          alignment: Alignment.center,
          child: const Text(
            'AICOM GROUP\nTư duy sáng tạo – Thi công chuyên nghiệp',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

