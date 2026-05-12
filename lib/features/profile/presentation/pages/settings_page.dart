import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/settings_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

// Keep in sync with pubspec.yaml version field.
const _kAppVersion = '1.0.0';
const _kBuildNumber = '1';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            color: _textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSettingsGroup([
            _buildSwitchTile(
              context,
              'Dark Mode',
              Icons.dark_mode_rounded,
              context.watch<SettingsProvider>().isDarkMode,
              (val) => context.read<SettingsProvider>().toggleTheme(val),
            ),
            _buildSwitchTile(
              context,
              'Notifications',
              Icons.notifications_active_rounded,
              context.watch<SettingsProvider>().notificationsEnabled,
              (val) => context.read<SettingsProvider>().toggleNotifications(val),
            ),
          ]),

          const SizedBox(height: 32),
          _buildSectionHeader('Account'),
          _buildSettingsGroup([
            _buildActionTile('Privacy Policy', Icons.privacy_tip_rounded,
                () => context.push('/policy', extra: 'Privacy Policy')),
            _buildActionTile('Help & Feedback', Icons.help_center_rounded,
                () => context.push('/help-support')),
          ]),

          const SizedBox(height: 32),
          _buildSectionHeader('AI Disclosure'),
          _buildAiDisclosureTile(),

          const SizedBox(height: 32),
          _buildSectionHeader('About'),
          _buildAboutGroup(context),

          const SizedBox(height: 32),
          _buildSectionHeader('Danger Zone'),
          _buildSettingsGroup([
            _buildActionTile(
              'Sign Out',
              Icons.logout_rounded,
              () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) context.go('/');
              },
              isDestructive: true,
            ),
            _buildActionTile(
              'Delete Account',
              Icons.delete_forever_rounded,
              () => _showDeleteAccountDialog(context),
              isDestructive: true,
            ),
          ]),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final isGoogleUser = authProvider.currentUser?.email != null &&
        !authProvider.currentUser!.email.contains('@');
    final passwordCtrl = TextEditingController();
    bool obscure = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          backgroundColor: AppTheme.surfaceLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Delete Account',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will permanently delete your account and all your data (progress, badges, bookmarks). This action cannot be undone.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: AppTheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              if (!isGoogleUser) ...[
                const SizedBox(height: 16),
                Text(
                  'Enter your password to confirm:',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordCtrl,
                  obscureText: obscure,
                  style: GoogleFonts.beVietnamPro(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.beVietnamPro(color: AppTheme.onSurfaceVariant),
                    filled: true,
                    fillColor: AppTheme.surfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: AppTheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final password = isGoogleUser ? '' : passwordCtrl.text;
                await authProvider.deleteAccount(password);
                if (authProvider.error != null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed: ${authProvider.error}'),
                        backgroundColor: AppTheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) context.go('/');
                }
              },
              child: Text(
                'Delete',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: _textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            BoxDecoration(color: _surfaceLow, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: _primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _primary,
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            BoxDecoration(color: _surfaceLow, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: isDestructive ? Colors.red : _primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: isDestructive ? Colors.red : _textDark,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
    );
  }

  Widget _buildAiDisclosureTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-Generated Content',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  'Historical character conversations and place insights are generated by Google Gemini AI. Responses are for educational purposes and may not be fully accurate. Do not treat AI-generated content as authoritative historical fact.',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 12, color: _textMuted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutGroup(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _textDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: _surfaceLow, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.info_outline_rounded, color: _primary, size: 20),
            ),
            title: Text(
              'App Version',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            trailing: GestureDetector(
              onLongPress: () {
                Clipboard.setData(const ClipboardData(
                    text: 'Time Explorer v$_kAppVersion ($_kBuildNumber)'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Version copied to clipboard'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'v$_kAppVersion ($_kBuildNumber)',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: _textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
