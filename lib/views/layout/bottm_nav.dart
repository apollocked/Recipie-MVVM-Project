import 'package:dio_receipe/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomNavItem extends StatelessWidget {
  const CustomNavItem({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
    required this.navigationShell,
  });

  final int index;
  final IconData icon;
  final String label;
  final dynamic navigationShell;

  @override
  Widget build(BuildContext context) {
    bool isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => navigationShell.goBranch(
        index,
        initialLocation:
            index ==
            navigationShell
                .currentIndex, // Stay on the same branch if already selected
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Constrains the column to the icon/text size
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // Creates a pill shape behind the active icon
              color: isSelected ? yellowColor : transparentColor,
              borderRadius: BorderRadius.circular(29),
            ),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                Icon(icon, color: isSelected ? iconColor : greyColor, size: 25),
                const SizedBox(width: 8),
                if (isSelected) ...[
                  Text(
                    label,
                    style: TextStyle(
                      color: iconLableColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
