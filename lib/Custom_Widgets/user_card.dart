import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Models/user_model.dart'; // Your User model

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onViewDetails;

  const UserCard({
    super.key,
    required this.user,
    required this.onViewDetails,
  });

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: SAppColors.textGray),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 40, // 70x70
            backgroundImage: user.photo.isNotEmpty
                ? NetworkImage(user.photo)
                : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Full Name', user.fullName),
          const SizedBox(height: 4),
          _buildInfoRow('User ID', '${user.id}'),
          const SizedBox(height: 4),
          _buildInfoRow('Role', user.role),
          const Spacer(),
          SizedBox(
            width: 180,
            height: 50,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: SAppColors.secondaryDarkBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // all corners
                ),
              ),
              child: const Text('View Details'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
