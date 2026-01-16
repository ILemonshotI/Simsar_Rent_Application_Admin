import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Custom_Widgets/identity_panel.dart';
import '../Custom_Widgets/screen_header.dart';
import '../Custom_Widgets/user_info_panel.dart';
import '../Models/user_verification_model.dart';
import '../Network/api_client.dart';
import '../Theme/app_colors.dart';

class AdminUserVerificationScreen extends StatefulWidget {
  final int userId;

  const AdminUserVerificationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AdminUserVerificationScreen> createState() => _AdminUserVerificationScreenState();
}

class _AdminUserVerificationScreenState extends State<AdminUserVerificationScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isAddingMoney = false;

  Future<UserVerificationModel> fetchUser(int userId) async {
    final response = await DioClient.dio.get('/api/users/$userId');
    return UserVerificationModel.fromJson(response.data);
  }

  Future<void> approveUser(int userId) async {
    await DioClient.dio.post('/api/users/$userId/approve');
  }

  Future<void> addMoney(int userId, double amount) async {
    await DioClient.dio.post(
      '/api/wallet/$userId',
      data: {
        "amount": amount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<UserVerificationModel>(
        future: fetchUser(widget.userId),
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
                            Expanded(flex: 5, child: UserInfoPanel(user: user)),
                            const SizedBox(width: 64),
                            Expanded(flex: 7, child: IdentityPanel(user: user)),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // 💰 Wallet Top-Up Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 240,
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Amount",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isAddingMoney
                                    ? null
                                    : () async {
                                  final amount = double.tryParse(_amountController.text);

                                  if (amount == null || amount <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Enter a valid amount")),
                                    );
                                    return;
                                  }

                                  setState(() => _isAddingMoney = true);

                                  try {
                                    await addMoney(user.id, amount);
                                    _amountController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Money added successfully")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Failed to add money: $e")),
                                    );
                                  }

                                  setState(() => _isAddingMoney = false);
                                },
                                child: _isAddingMoney
                                    ? const CircularProgressIndicator()
                                    : const Text("Add Money"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // ✅ Approve Button
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
