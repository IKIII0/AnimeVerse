import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationShell extends StatelessWidget {
  const BottomNavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required double screenWidth,
    required double screenHeight,
  }) {
    final isActive = index == navigationShell.currentIndex;

    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        onTap: () => _onItemTapped(index),
        child: isActive
            ? Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.025,
                  horizontal: screenWidth * 0.045,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff092c47),
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: screenWidth * 0.02,
                      offset: Offset(0, screenHeight * 0.005),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Icon(
                  icon,
                  color: Colors.grey.shade600,
                  size: screenWidth * 0.06,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        body: navigationShell,
        extendBody: true,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
            decoration: const BoxDecoration(color: Color(0xFF0b395e)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  screenWidth: screenSize.width,
                  screenHeight: screenSize.height,
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.favorite_rounded,
                  label: 'Favorites',
                  screenWidth: screenSize.width,
                  screenHeight: screenSize.height,
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  screenWidth: screenSize.width,
                  screenHeight: screenSize.height,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
