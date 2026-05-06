import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/view_model/providers/theme_provider.dart';
import 'package:dio_receipe/views/layout/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: customAppBar('Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: AppColors.border, width: 1),
              ),
              child: ListTile(
                leading: Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary, // Using theme colors
                ),
                title: Text(
                  "Dark Mode",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isDarkMode
                      ? "Tap to switch to Light Mode"
                      : "Tap to switch to Dark Mode",
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    showThemeConfirmation(context, value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showThemeConfirmation(BuildContext context, bool targetValue) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Confirm Theme Change"),
        content: Text("Switch to ${targetValue ? 'Dark' : 'Light'} mode?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // We use the original context to find the provider
              context.read<ThemeProvider>().toggleTheme();
              Navigator.pop(dialogContext);
            },
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );
}
