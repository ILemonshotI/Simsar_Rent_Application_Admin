import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
class AdminCard extends StatelessWidget {
  final String name;
  final String phone;
  final String? imageAsset; // optional

  const AdminCard({
    super.key,
    required this.name,
    required this.phone,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SAppColors.primaryBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: SAppColors.white,
              backgroundImage: AssetImage(
                imageAsset ?? 'assets/images/profile_placeholder.png',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: SAppColors.white),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: SAppColors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
