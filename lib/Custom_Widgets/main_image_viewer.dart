import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainImageViewer extends StatelessWidget {
  final String imageUrl;

  const MainImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
    );
  }
}
