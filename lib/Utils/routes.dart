import 'package:go_router/go_router.dart';
import 'package:simsar_web/Layouts/main_layout.dart';
import 'package:simsar_web/Screens/admin_property_details_screen.dart';

import 'package:simsar_web/Screens/all_properties_screen.dart';
import 'package:simsar_web/Screens/pending_properties_screen.dart';
import 'package:simsar_web/Screens/all_users_screen.dart';
import 'package:simsar_web/Screens/pending_users_screen.dart';
import 'package:simsar_web/Screens/admin_home_screen.dart';
import 'package:simsar_web/Screens/user_screen.dart';
import 'package:simsar_web/Screens/user_verification_screen.dart';

class AppRouter {
  static const String home = '/home';
  static const String allPropertiesScreen = '/properties/all';
  static const String pendingPropertiesScreen = '/properties/pending';
  static const String allUsersScreen = '/users/all';
  static const String pendingUsersScreen = '/users/pending';
  static const String propertyDetails = '/property';
  static const String unapprovedUserDetails = '/unapproved-user';
  static const String userDetails = '/user';
  
  static final GoRouter router = GoRouter(
  initialLocation: '/user/5',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainWebLayout(child: child);
      },
      routes: [
        GoRoute(
            path: '$userDetails/:userId',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['userId'] ?? '0');


              return UserScreen(userId: id);
            }
        ),
        GoRoute(
        path: '$propertyDetails/:propertyId',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['propertyId'] ?? '0');


          return AdminPropertyDetailsScreen(apartmentId: id);
        }
        ),
        GoRoute(
            path: '$unapprovedUserDetails/:userId',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['userId'] ?? '0');


              return AdminUserVerificationScreen(userId: id);
            }
        ),
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