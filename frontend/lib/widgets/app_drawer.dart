import 'package:frontend/app.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;
  final VoidCallback onProfileTap;
  final VoidCallback onRecentTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  const AppDrawer({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onProfileTap,
    required this.onRecentTap,
    required this.onSettingsTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: onProfileTap,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.purple.shade200,
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : "U",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "View Profile",
                            style: TextStyle(
                              color: textColor.withOpacity(0.75),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(color: theme.dividerColor),

            _drawerItem(
              icon: Icons.person_outline,
              title: "Profile",
              onTap: onProfileTap,
              color: textColor,
            ),

            _drawerItem(
              icon: Icons.history,
              title: "Recent",
              onTap: onRecentTap,
              color: textColor,
            ),

            _drawerItem(
              icon: Icons.settings_outlined,
              title: "Settings & Privacy",
              onTap: onSettingsTap,
              color: textColor,
            ),

            SwitchListTile.adaptive(
              value: isDarkMode,
              onChanged: onThemeToggle,
              title: Text(
                isDarkMode ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(color: textColor, fontSize: 18),
              ),
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: textColor,
                size: 28,
              ),
              activeColor: theme.colorScheme.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),

            const Spacer(),

            Divider(color: theme.dividerColor),

            _drawerItem(
              icon: Icons.logout,
              title: "Logout",
              color: Colors.redAccent,
              onTap: onLogoutTap,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
