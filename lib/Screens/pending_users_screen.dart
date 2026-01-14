import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Custom_Widgets/pending_user_card.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Models/user_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Network/api_client.dart';

class PendingUsersScreen extends StatefulWidget {
  const PendingUsersScreen({super.key});

  @override
  State<PendingUsersScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<PendingUsersScreen> {

  List<User> dummyUsers = [
  User.dummy(),
  User.dummy(),
  User.dummy(),
  User.dummy(),
  User.dummy(),
  User.dummy(),
];

   List<User> users = [];
   bool isLoading = false;
   String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    try {
      setState(() {
        isLoading = false;
        errorMessage = null;
      });

      final response = await DioClient.dio.get('/api/users');

      final List data = response.data['data'] ?? [];

      final fetchedUsers =
          data.map((e) => User.fromApiJson(e)).toList();

      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load users';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenHeader(title: "Property Listings"),

            const DescriptionBanner(
              message: "Here is a listing of all available properties.",
            ),

            const SizedBox(height: 32),

            // if (isLoading)
            //   const Center(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 60),
            //       child: CircularProgressIndicator(),
            //     ),
            //   )
            // else if (errorMessage != null)
            //   Center(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 60),
            //       child: Text(
            //         errorMessage!,
            //         style: const TextStyle(color: SAppColors.error),
            //       ),
            //     ),
            //   )
            // else if (mockProperties.isEmpty)
            //   const Center(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 60),
            //       child: Text("No properties found"),
            //     ),
            //   )
            // else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 64,
                    runSpacing: 24,
                    children: dummyUsers.map((property) {
                      return PendingUserCard(
                        user: property,
                        onViewDetails: () {
          
                        },
                        onApproved: () {
                          
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
}
