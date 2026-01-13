import 'package:flutter/cupertino.dart';

class ThumbnailScroller extends StatelessWidget {
  final List<String> images;

  const ThumbnailScroller({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              images[index],
              width: 160,
              height: 110,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
