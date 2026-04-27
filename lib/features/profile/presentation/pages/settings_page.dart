import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/settings_provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ── Design Tokens ─────────────────────────────────────────────────────────
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
            _buildActionTile('Privacy Policy', Icons.privacy_tip_rounded, () => context.push('/policy', extra: 'Privacy Policy')),
            _buildActionTile('Help Center', Icons.help_center_rounded, () => context.push('/help-support')),
          ]),
          
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
          ]),
        ],
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

  Widget _buildSwitchTile(BuildContext context, String title, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: _surfaceLow, borderRadius: BorderRadius.circular(10)),
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

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: _surfaceLow, borderRadius: BorderRadius.circular(10)),
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
}
