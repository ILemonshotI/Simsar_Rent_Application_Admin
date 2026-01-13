import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Custom_Widgets/admin_card.dart';
import 'package:simsar_web/Theme/app_colors.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _propertiesExpanded = true;
  bool _usersExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Get the current route to highlight active items
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 230, // Slightly wider for a more professional feel
      decoration: BoxDecoration(
        color: SAppColors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          // 1. App Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Image.asset(
              'assets/images/blue_house_icon.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),

          // 2. Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                /// PROPERTIES SECTION
                _buildSection(
                  title: "Properties",
                  icon: Icons.home_outlined, // Modern outlined icon
                  expanded: _propertiesExpanded,
                  isActive: location.startsWith('/properties'),
                  onTap: () {
                    setState(() {
                      _propertiesExpanded = !_propertiesExpanded;
                      _usersExpanded = false;
                    });
                  },
                  children: [
                    _buildItem(
                      "All Properties",
                      '/properties/all',
                      location,
                    ),
                    _buildItem(
                      "Pending Properties",
                      '/properties/pending',
                      location,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// USERS SECTION
                _buildSection(
                  title: "Users",
                  icon: Icons.people_outline,
                  expanded: _usersExpanded,
                  isActive: location.startsWith('/users'),
                  onTap: () {
                    setState(() {
                      _usersExpanded = !_usersExpanded;
                      _propertiesExpanded = false;
                    });
                  },
                  children: [
                    _buildItem("All Users", '/users/all', location),
                    _buildItem("Pending Users", '/users/pending', location),
                  ],
                ),
              ],
            ),
          ),

          // 3. Footer Admin Card
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: AdminCard(
              name: 'Laith Ahmad',
              phone: '0912345678',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool expanded,
    required bool isActive,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        Theme(
          // Remove default splash for a cleaner look
          data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: isActive ? SAppColors.primaryBlue.withValues(alpha: 0.08) : Colors.transparent,
            leading: Icon(
              icon,
              color: isActive ? SAppColors.primaryBlue : SAppColors.textGray,
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isActive ? SAppColors.primaryBlue : SAppColors.textGray,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            trailing: Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: isActive ? SAppColors.primaryBlue : SAppColors.textGray,
              size: 18,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            minLeadingWidth: 0,
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildItem(String title, String path, String location) {
    final bool isSelected = location == path;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => context.go(path),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(left: 32), 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? SAppColors.primaryBlue.withValues(alpha: 0.05) : Colors.transparent,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? SAppColors.primaryBlue : SAppColors.descriptionTextGray,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}