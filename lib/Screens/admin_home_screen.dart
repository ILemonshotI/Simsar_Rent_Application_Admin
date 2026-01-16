import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Custom_Widgets/primary_button.dart';
import 'package:simsar_web/Custom_Widgets/text_field.dart';
import 'package:simsar_web/Custom_Widgets/password_field.dart';
import 'package:simsar_web/Custom_Widgets/checkbox_tile.dart';
import 'package:simsar_web/Custom_Widgets/login_header.dart';
import 'package:simsar_web/Custom_Widgets/login_footer.dart';
import '../Network/token_storage.dart';
import '../Network/api_client.dart';
import 'package:simsar_web/Theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool agreed = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final String preText = "Don't have an account? ";
  final String sufText = "Request Admin Account from owner";

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = phoneController.text.trim();
    final password = passwordController.text;

    try {
      final response = await DioClient.dio.post(
        '/api/login',
        data: {'phone': phone, 'password': password},
      );

      if (mounted) {
        TokenStorage.setToken(response.data['token']);
          context.go('/properties/all');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Login failed';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: SAppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a small screen
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: SAppColors.background,
      body: Row( // Using a Row to allow for a side-banner on large screens
        children: [
          // Left Side: Image/Banner (Only visible on Desktop/Tablet)
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                color: SAppColors.secondaryDarkBlue,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.apartment, size: 100, color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        "Simsar Web Portal",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Right Side: Login Form
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  // Crucial for Web: Stop the form from getting too wide
                  constraints: const BoxConstraints(maxWidth: 400), 
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginHeader(
                          title: "Welcome Back",
                          description: "Enter your credentials to manage your properties.",
                        ),
                        const SizedBox(height: 48),
                        
                        STextField(
                          labelText: "Phone Number",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Phone number is required";
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        SPasswordField(
                          labelText: "Password",
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Password is required";
                            if (value.length < 5) return "Min 5 characters required";
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SCheckboxTile(
                            value: agreed,
                            text: "Remember me",
                            onChanged: (value) => setState(() => agreed = value ?? false),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        SPrimaryButton(
                          text: "Sign in",
                          onPressed: _loginPressed,
                          // Optional: width: double.infinity for web buttons
                        ),
                        
                        const SizedBox(height: 24),
                        
                        LoginFooter(
                          preText: preText,
                          sufText: sufText,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}