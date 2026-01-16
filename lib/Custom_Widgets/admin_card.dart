import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Models/user_model.dart';
import 'package:simsar_web/Network/api_client.dart';

class AdminCard extends StatefulWidget { 
  const AdminCard({
    super.key,
  });

  @override
  State<AdminCard> createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  bool isLoading = true;
  String? errorMessage;
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final response = await DioClient.dio.get('/api/me');
      final fetchedUser = User.fromApiJson(response.data);

      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load user info';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(color: SAppColors.error),
        ),
      );
    }

    final photo = user!.photo;
    final initials = (user!.firstName.isNotEmpty ? user!.firstName[0] : '') +
        (user!.lastName.isNotEmpty ? user!.lastName[0] : '');
        
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
              backgroundImage: (photo.isNotEmpty)
                  ? NetworkImage(photo)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.fullName,
                  style: const TextStyle(color: SAppColors.white),
                ),
                Text(
                  user!.phone,
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