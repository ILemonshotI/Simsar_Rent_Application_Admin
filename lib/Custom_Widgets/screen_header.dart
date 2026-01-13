import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Theme/text_theme.dart';

/// A dynamic header for the top of the screen
class ScreenHeader extends StatelessWidget {
  final String title;

  const ScreenHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: SAppColors.secondaryDarkBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ), 
      ),
      child: Text(
        title,
        style: TextStyle(
          color: SAppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        )
    ),
    );
    
  }
}

/// A dynamic banner that displays a description with a light background
class DescriptionBanner extends StatelessWidget {
  final String message;

  const DescriptionBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // Light grayish-blue banner background
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        message,
        style: STextTheme.lightTextTheme.bodyMedium?.copyWith(
          color: SAppColors.textGray,
        ),
      ),
    );
  }
}

