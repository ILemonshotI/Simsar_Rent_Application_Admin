import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Custom_Widgets/pending_user_card.dart';
import 'package:simsar_web/Custom_Widgets/user_card.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Models/user_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Network/api_client.dart';

class PendingUsersScreen extends StatefulWidget {
  const PendingUsersScreen({super.key});

  @override
  State<PendingUsersScreen> createState() => _PendingUsersScreenState();
}

class _PendingUsersScreenState extends State<PendingUsersScreen> {
   List<User> users = [];
   bool isLoading = false;
   String? errorMessage;
   bool hasFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await DioClient.dio.get('/api/users/unapproved');

      final List data = response.data['users'] ?? [];

      final fetchedUsers =
          data.map((e) => User.unapprovedFromJson(e)).toList();

      setState(() {
        users = fetchedUsers;
        hasFetched = true;
      });
    } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      setState(() {
        users = []; 
        hasFetched = true;
        errorMessage = null; 
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load unapproved users';
        hasFetched = true;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'An unexpected error occurred';
      hasFetched = true;
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _approveUser(int userId) async {
  try {
    await DioClient.dio.post(
      '/api/user/$userId/approve',
    );

    setState(() {
      users.removeWhere((p) => p.id == userId);
    });

    // Optional success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User approved successfully'),
        backgroundColor: SAppColors.success,
      ),
    );
  } on DioException catch (e) {
    String message = 'Something went wrong';

    if (e.response?.statusCode == 404) {
      message = 'User not found';
    } 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SAppColors.error,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unexpected error occurred'),
        backgroundColor: Colors.red,
      ),
    );
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
            const ScreenHeader(title: "Pending Users"),

            const DescriptionBanner(
              message: "Here is a listing of pending users awaiting approval.",
            ),

            const SizedBox(height: 32),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: SAppColors.error),
                  ),
                ),
              )
            else if (users.isEmpty && hasFetched == true)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text("No unapproved users found"),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 64,
                    runSpacing: 24,
                    children: users.map((user) {
                      return PendingUserCard(
                        user: user,
                        onViewDetails: () {context.push('/user/${user.id}');},
                        onApproved:() => _approveUser(user.id),
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
