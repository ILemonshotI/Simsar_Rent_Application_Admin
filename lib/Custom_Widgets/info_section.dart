
import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SAppColors.textGray)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
