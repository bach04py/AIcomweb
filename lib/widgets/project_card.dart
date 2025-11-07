import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String imageUrl;

  const ProjectCard({super.key, required this.title, required this.imageUrl});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool hovered = false;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final transformMatrix = hovered
        ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
        : Matrix4.identity();

    return VisibilityDetector(
      key: Key(widget.title),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !visible) {
          setState(() => visible = true);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        opacity: visible ? 1 : 0,
        curve: Curves.easeOut,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 700),
          padding: EdgeInsets.only(top: visible ? 0 : 60),
          curve: Curves.easeOut,
          child: MouseRegion(
            onEnter: (_) => setState(() => hovered = true),
            onExit: (_) => setState(() => hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              transform: transformMatrix,
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: hovered ? Colors.black26 : Colors.black12,
                    blurRadius: hovered ? 15 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      width: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

