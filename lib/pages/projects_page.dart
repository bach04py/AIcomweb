import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(60),
              child: Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: const [
                  ProjectCard(
                      title: 'AICOM Home Decor',
                      imageUrl:
                          'https://aicomgroup.vn/wp-content/uploads/2023/07/1-3-1024x576.jpg'),
                  ProjectCard(
                      title: 'Logistics B2B',
                      imageUrl:
                          'https://aicomgroup.vn/wp-content/uploads/2023/07/2-2-1024x576.jpg'),
                  ProjectCard(
                      title: 'AICOM Training',
                      imageUrl:
                          'https://aicomgroup.vn/wp-content/uploads/2023/07/3-2-1024x576.jpg'),
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

