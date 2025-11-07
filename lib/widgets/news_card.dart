import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewsCard extends StatefulWidget {
  final String title;
  final String imageUrl;

  const NewsCard({super.key, required this.title, required this.imageUrl});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard>
    with SingleTickerProviderStateMixin {
  bool hovered = false;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final transformMatrix = hovered
        ? Matrix4.translationValues(0, -5, 0)
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
          padding: EdgeInsets.only(top: visible ? 0 : 50),
          curve: Curves.easeOut,
          child: MouseRegion(
            onEnter: (_) => setState(() => hovered = true),
            onExit: (_) => setState(() => hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: transformMatrix,
              curve: Curves.easeOut,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: hovered ? Colors.black26 : Colors.black12,
                    blurRadius: hovered ? 10 : 5,
                    offset: hovered ? const Offset(0, 4) : const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 160,
                      width: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
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

