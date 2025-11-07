import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF004AAD))),
        const SizedBox(height: 10),
        Container(width: 80, height: 3, color: const Color(0xFF004AAD)),
      ],
    );
  }
}

