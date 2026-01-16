import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Custom_Widgets/user_card.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Models/user_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Network/api_client.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
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

      final response = await DioClient.dio.get('/api/users/all');

      final List data = response.data['users'] ?? [];

      final fetchedUsers =
          data.map((e) => User.fromJson(e)).toList();

      setState(() {
        users = fetchedUsers;
        hasFetched = true;
      });
    } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      setState(() {
        hasFetched = true;
        errorMessage = 'UnAuthenticated'; 
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load properties';
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
            const ScreenHeader(title: "All Users"),

            const DescriptionBanner(
              message: "Here is a listing of all users registered in the Simsar App.",
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
                  child: Text("No users found"),
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
                      return UserCard(
                        user: user,
                        onViewDetails: () {context.push('/user/${user.id}');},
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
