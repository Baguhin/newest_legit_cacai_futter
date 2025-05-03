import 'package:cacai/ui/views/QR.dart';
import 'package:cacai/ui/views/app_colors.dart';
import 'package:flutter/material.dart';

import 'average_rating_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool locationEnabled = true;
  bool analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark ? Colors.black : AppColors.primaryGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // User profile section

            // Main settings sections
            _buildSection(
              title: 'App Preferences',
              children: [
                _buildSwitchTile(
                  title: 'Notifications',
                  subtitle: 'Get alerts about detected pests and treatments',
                  icon: Icons.notifications_outlined,
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme for night use',
                  icon: Icons.dark_mode_outlined,
                  value: darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      darkModeEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  title: 'Location Services',
                  subtitle: 'Enable region-specific pest identification',
                  icon: Icons.location_on_outlined,
                  value: locationEnabled,
                  onChanged: (value) {
                    setState(() {
                      locationEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  title: 'Usage Analytics',
                  subtitle: 'Help us improve by sending anonymous data',
                  icon: Icons.analytics_outlined,
                  value: analyticsEnabled,
                  onChanged: (value) {
                    setState(() {
                      analyticsEnabled = value;
                    });
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'Account',
              children: [
                _buildNavigationTile(
                  title: 'Profile Settings',
                  subtitle: 'Edit your personal information',
                  icon: Icons.person_outline,
                  onTap: () {
                    // Navigate to profile
                  },
                ),
                _buildNavigationTile(
                  title: 'Security',
                  subtitle: 'Change password and security options',
                  icon: Icons.security_outlined,
                  onTap: () {
                    // Navigate to security settings
                  },
                ),
                _buildNavigationTile(
                  title: 'Sync Options',
                  subtitle: 'Manage cloud sync for your data',
                  icon: Icons.sync_outlined,
                  onTap: () {
                    // Navigate to sync settings
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'App',
              children: [
                _buildNavigationTile(
                  title: 'Language',
                  subtitle: 'Change app language',
                  icon: Icons.language_outlined,
                  trailing: const Text('English'),
                  onTap: () {
                    // Show language options
                  },
                ),
                _buildNavigationTile(
                  title: 'Storage & Data',
                  subtitle: 'Manage cache and downloaded content',
                  icon: Icons.storage_outlined,
                  onTap: () {
                    // Navigate to storage settings
                  },
                ),
                _buildNavigationTile(
                  title: 'View All Ratings',
                  subtitle: 'See average and total app ratings',
                  icon: Icons.star_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AverageRatingPage(),
                      ),
                    );
                  },
                ),
                _buildNavigationTile(
                  title: 'Download App via QR Code',
                  subtitle: 'Share with friends and family',
                  icon: Icons.qr_code_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRDownloadPage(),
                        ));
                  },
                ),
              ],
            ),

            _buildSection(
              title: 'Support & About',
              children: [
                _buildNavigationTile(
                  title: 'Help & Support',
                  subtitle: 'Get assistance and answers to common questions',
                  icon: Icons.help_outline,
                  onTap: () {
                    // Navigate to help
                  },
                ),
                _buildNavigationTile(
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts on improving the app',
                  icon: Icons.feedback_outlined,
                  onTap: () {
                    // Show feedback form
                  },
                ),
                _buildNavigationTile(
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    // Show privacy policy
                  },
                ),
                _buildNavigationTile(
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  icon: Icons.description_outlined,
                  onTap: () {
                    // Show terms
                  },
                ),
                _buildNavigationTile(
                  title: 'About Cocoa Insect Detection',
                  subtitle: 'Version 1.2.3',
                  icon: Icons.info_outline,
                  onTap: () {
                    // Show about page
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
      onTap: onTap,
    );
  }
}
