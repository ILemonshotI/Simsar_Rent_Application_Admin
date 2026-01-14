import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme/app_colors.dart';

class IdCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const IdCard({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          width: 280,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              )
            ],
          ),
        ),
      ],
    );
  }
}
