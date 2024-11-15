import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/providers/dashboard_provider/dashboard_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xff2E2739),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _navItems.length; i++)
                GestureDetector(
                  onTap: () => dashboardProvider.setIndex(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _navItems[i].icon,
                        color: dashboardProvider.currentIndex == i
                            ? Colors.purple
                            : Colors.white,
                      ),
                      Text(
                        _navItems[i].label,
                        style: TextStyle(
                          color: dashboardProvider.currentIndex == i
                              ? Colors.purple
                              : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}

const List<NavItem> _navItems = [
  NavItem(Icons.dashboard, 'Dashboard'),
  NavItem(Icons.tv, 'Watch'),
  NavItem(Icons.video_library, 'Media Library'),
  NavItem(Icons.more_horiz, 'More'),
];
