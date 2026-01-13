import 'package:flutter/material.dart';
import 'package:simsar_web/Custom_Widgets/layout_sidebar.dart';

class MainWebLayout extends StatelessWidget {
  final Widget child;

  const MainWebLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
