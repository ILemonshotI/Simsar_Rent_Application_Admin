
import 'package:flutter/material.dart';
import '../Models/user_model.dart';
import '../Models/user_verification_model.dart';
import 'info_row.dart';
import 'info_section.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:intl/intl.dart';
class UserInfoPanel extends StatelessWidget {
  final UserVerificationModel user;

  const UserInfoPanel({required this.user});

  @override
  Widget build(BuildContext context) {
    debugPrint('DEBUG - Current Photo URL: ${user.photo}');
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundColor: SAppColors.white,
              backgroundImage: (user.photo.isNotEmpty)
                  ? NetworkImage(user.photo)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
        ),
  
        const SizedBox(height: 32),

        InfoSection(
          title: "Personal Details",
          children: [
            InfoRow("Full Name", user.fullName),
            InfoRow("Phone Number", user.phone),
            InfoRow("Date of Birth", user.birthDate),
          ],
        ),

        const SizedBox(height: 32),

        InfoSection(
          title: "Account Details",
          children: [
            InfoRow("User ID", user.id.toString()),
            InfoRow("Date Joined", 
            user.createdAt.isNotEmpty
      ? DateFormat.yMMMMd().format(DateTime.parse(user.createdAt))
      : 'N/A', 
      ),
          ],
        ),
      ],
    );
  }
}
