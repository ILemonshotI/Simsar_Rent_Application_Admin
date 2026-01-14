import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/user_model.dart';
import 'info_row.dart';
import 'info_section.dart';

class UserInfoPanel extends StatelessWidget {
  final UserVerificationModel user;

  const UserInfoPanel({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundImage: NetworkImage(user.photo),
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
            InfoRow("Date Joined", user.createdAt),
          ],
        ),
      ],
    );
  }
}
