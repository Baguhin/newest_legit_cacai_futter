import 'package:cacai/ui/views/average_rating_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green[100]!,
              Colors.green[300]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Preferences'),
            _buildSettingsCard([
              _buildSwitchTile(
                title: 'Enable Notifications',
                subtitle: 'Receive updates and alerts about pests',
                icon: Icons.notifications_active,
                value: true,
                onChanged: (value) {
                  // Handle notification toggle
                },
              ),
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Enable dark theme for better visibility',
                icon: Icons.dark_mode,
                value: false,
                onChanged: (value) {
                  // Handle dark mode toggle
                },
              ),
              _buildSwitchTile(
                title: 'Enable Location Services',
                subtitle: 'Allow the app to detect insects in your area',
                icon: Icons.location_on,
                value: true,
                onChanged: (value) {
                  // Handle location toggle
                },
              ),
            ]),
            _buildSectionTitle('Account Settings'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.person,
                title: 'User Profile',
                subtitle: 'Manage your account details',
                onTap: () {
                  // Navigate to user profile page
                },
              ),
              _buildListTile(
                icon: Icons.password,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  // Handle password change
                },
              ),
              _buildListTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Select app language',
                onTap: () {
                  // Handle language selection
                },
              ),
            ]),
            _buildSectionTitle('Support'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your experience with us',
                onTap: () {
                  // Handle feedback submission
                },
              ),
              _buildListTile(
                icon: Icons.info_outline,
                title: 'About the App',
                subtitle: 'Learn more about Cocoa Insect Detection',
                onTap: () {
                  // Show app info
                },
              ),
            ]),
            _buildSectionTitle('App Ratings'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.star,
                title: 'View All Ratings',
                subtitle: 'See the average and total ratings',
                onTap: () {
                  // Navigate to the AverageRatingPage to view all ratings
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AverageRatingPage(), // Navigate to AverageRatingPage
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 100), // Adds extra space for FAB clearance
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: Colors.green.shade700),
      activeColor: Colors.green.shade700,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
