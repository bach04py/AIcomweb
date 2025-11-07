import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = List.generate(
        6,
        (i) =>
            'https://aicomgroup.vn/wp-content/uploads/2023/07/${i + 1}-3-1024x576.jpg');

    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(60),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: images.length,
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(images[i], fit: BoxFit.cover),
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

