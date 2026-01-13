import 'package:go_router/go_router.dart';
import 'package:simsar_web/Layouts/main_layout.dart';

import 'package:simsar_web/Screens/all_properties_screen.dart';
import 'package:simsar_web/Screens/pending_properties_screen.dart';
import 'package:simsar_web/Screens/all_users_screen.dart';
import 'package:simsar_web/Screens/pending_users_screen.dart';
import 'package:simsar_web/Screens/admin_home_screen.dart';

class AppRouter {
  static const String home = '/home';
  static const String allPropertiesScreen = '/properties/all';
  static const String pendingPropertiesScreen = '/properties/pending';
  static const String allUsersScreen = '/users/all';
  static const String pendingUsersScreen = '/users/pending';
  
  static final GoRouter router = GoRouter(
  initialLocation: allPropertiesScreen,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainWebLayout(child: child);
      },
      routes: [
        GoRoute(
          path: allPropertiesScreen,
          builder: (context, state) => const AllPropertiesScreen(),
        ),
        GoRoute(
          path: pendingPropertiesScreen,
          builder: (context, state) => const PendingPropertiesScreen(),
        ),
        GoRoute(
          path: allUsersScreen,
          builder: (context, state) => const AllUsersScreen(),
        ),
        GoRoute(
          path: pendingUsersScreen,
          builder: (context, state) => const PendingUsersScreen(),
        ),
      ],
    ),
  ],
);
}