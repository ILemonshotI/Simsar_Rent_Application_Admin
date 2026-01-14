import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Network/api_client.dart';

import '../Custom_Widgets/identity_panel.dart';
import '../Custom_Widgets/user_info_panel.dart';
import '../Models/user_model.dart';

class AdminUserVerificationScreen extends StatelessWidget {
  final int userId;

  const AdminUserVerificationScreen({
    super.key,
    required this.userId,
  });

  Future<UserVerificationModel> fetchUser(int userId) async {
    final response = await DioClient.dio.get('/api/users/$userId');
    return UserVerificationModel.fromJson(response.data);
  }

  Future<void> approveUser(int userId) async {
    await DioClient.dio.post('/api/users/$userId/approve');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<UserVerificationModel>(
        future: fetchUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load user: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeader(title: "User Identity Verification"),

                const SizedBox(height: 32),

                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT — User Info
                            Expanded(
                              flex: 5,
                              child: UserInfoPanel(user: user),
                            ),

                            const SizedBox(width: 64),

                            // RIGHT — Identity Images
                            Expanded(
                              flex: 7,
                              child: IdentityPanel(user: user),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        SizedBox(
                          width: 280,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await approveUser(user.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User approved successfully")),
                              );
                            },
                            child: const Text(
                              "Approve User",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
