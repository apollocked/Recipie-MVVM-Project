import 'package:dio_receipe/core/theme/app_theme.dart';
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
        initialLocation: index == navigationShell.currentIndex,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : AppColors.transparent,
              borderRadius: BorderRadius.circular(29),
            ),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.textOnAccent
                      : AppColors.textTertiary,
                  size: 25,
                ),
                const SizedBox(width: 8),
                if (isSelected) ...[
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
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
