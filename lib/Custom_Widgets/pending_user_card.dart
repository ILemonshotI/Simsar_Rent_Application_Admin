import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Models/user_model.dart'; // Your User model

class PendingUserCard extends StatelessWidget {
  final User user;
  final VoidCallback onViewDetails;
  final VoidCallback onApproved;

  const PendingUserCard({
    super.key,
    required this.user,
    required this.onViewDetails,
    required this.onApproved,
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
          _buildInfoRow('Phone Number', user.phone),
          const SizedBox(height: 4),
          _buildInfoRow('Role', user.role),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(
            width: 100,
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
              child: const Text(
                'View Details',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14), 
              ),
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: SAppColors.success,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // all corners
                ),
              ),
              child: const Text(
                'Approve',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14), 
              ),
            ),
          ),
          ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
