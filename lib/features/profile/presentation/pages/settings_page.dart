import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/settings_provider.dart';

// Official release version & build
const String _kAppVersion = '1.0.0';
const String _kBuildNumber = '1';
const String _kPlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.timeexplorer.app';
const String _kSupportEmail = 'usmansardar037@gmail.com';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAiCardExpanded = false;
  bool _isClearingCache = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>().profile;

    final bgColor = isDark ? const Color(0xFF0D0C18) : const Color(0xFFF7F6FC);
    final cardBg = isDark ? const Color(0xFF181728) : Colors.white;
    final borderColor = isDark ? const Color(0xFF28263E) : const Color(0xFFE6E4F0);
    final textColor = isDark ? const Color(0xFFF3F2FA) : const Color(0xFF171725);
    final textMuted = isDark ? const Color(0xFF9896AE) : const Color(0xFF6B6982);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Material(
              color: isDark ? const Color(0xFF222036) : const Color(0xFFEDEBF5),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  settings.triggerHaptic();
                  context.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: textColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text(
                  'v$_kAppVersion',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
        children: [
          // ── App & User Profile Card ──────────────────────────────────────
          _buildUserHeroCard(context, auth, profile, isDark, cardBg, borderColor, textColor, textMuted),
          const SizedBox(height: 24),

          // ── Appearance & Display ─────────────────────────────────────────
          _buildSectionHeader('Appearance & Display', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildInteractiveTile(
                title: 'Theme Mode',
                subtitle: 'Customize light, dark or follow system',
                icon: Icons.palette_rounded,
                iconGradient: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                textColor: textColor,
                textMuted: textMuted,
                trailing: _buildBadgePill(settings.themeModeLabel, isDark),
                onTap: () => _showThemeSelector(context, settings, isDark),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Sound & Tactile ──────────────────────────────────────────────
          _buildSectionHeader('Sound & Sensory', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildSwitchTile(
                title: 'Ambient History Sound',
                subtitle: 'Immersive background audio in timeline scenes',
                icon: Icons.waves_rounded,
                iconGradient: const [Color(0xFF059669), Color(0xFF10B981)],
                value: settings.ambientAudioEnabled,
                textColor: textColor,
                textMuted: textMuted,
                onChanged: (val) => settings.toggleAmbientAudio(val),
              ),
              _buildDivider(borderColor),
              _buildSwitchTile(
                title: 'Sound Effects',
                subtitle: 'Audio feedback for quizzes and milestones',
                icon: Icons.volume_up_rounded,
                iconGradient: const [Color(0xFFD97706), Color(0xFFF59E0B)],
                value: settings.soundEffectsEnabled,
                textColor: textColor,
                textMuted: textMuted,
                onChanged: (val) => settings.toggleSoundEffects(val),
              ),
              _buildDivider(borderColor),
              _buildSwitchTile(
                title: 'Haptic Feedback',
                subtitle: 'Tactile vibrations on interactive timeline clicks',
                icon: Icons.vibration_rounded,
                iconGradient: const [Color(0xFF0284C7), Color(0xFF38BDF8)],
                value: settings.hapticsEnabled,
                textColor: textColor,
                textMuted: textMuted,
                onChanged: (val) => settings.toggleHaptics(val),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Notifications ────────────────────────────────────────────────
          _buildSectionHeader('Notifications & Reminders', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Enable all notifications and daily streak updates',
                icon: Icons.notifications_active_rounded,
                iconGradient: const [Color(0xFFE11D48), Color(0xFFFB7185)],
                value: settings.notificationsEnabled,
                textColor: textColor,
                textMuted: textMuted,
                onChanged: (val) => settings.toggleNotifications(val),
              ),
              if (settings.notificationsEnabled) ...[
                _buildDivider(borderColor),
                _buildSwitchTile(
                  title: 'Daily Streak Alerts',
                  subtitle: 'Reminders before learning streak expires',
                  icon: Icons.local_fire_department_rounded,
                  iconGradient: const [Color(0xFFEA580C), Color(0xFFF97316)],
                  value: settings.streakAlertsEnabled,
                  textColor: textColor,
                  textMuted: textMuted,
                  onChanged: (val) => settings.toggleStreakAlerts(val),
                ),
                _buildDivider(borderColor),
                _buildSwitchTile(
                  title: 'New Discoveries & Content',
                  subtitle: 'Alerts when fresh historical eras & places arrive',
                  icon: Icons.auto_awesome_rounded,
                  iconGradient: const [Color(0xFF7C3AED), Color(0xFFA855F7)],
                  value: settings.contentAlertsEnabled,
                  textColor: textColor,
                  textMuted: textMuted,
                  onChanged: (val) => settings.toggleContentAlerts(val),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // ── Content & Storage ────────────────────────────────────────────
          _buildSectionHeader('Content & Storage', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildInteractiveTile(
                title: 'Era & Period Preferences',
                subtitle: 'Tailor timelines to your historical eras of interest',
                icon: Icons.history_edu_rounded,
                iconGradient: const [Color(0xFF4338CA), Color(0xFF6366F1)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push('/profile/era-preference'),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Local Cache & Media',
                subtitle: 'Clear cached places, maps, and character offline data',
                icon: Icons.cleaning_services_rounded,
                iconGradient: const [Color(0xFF0891B2), Color(0xFF06B6D4)],
                textColor: textColor,
                textMuted: textMuted,
                trailing: _isClearingCache
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _buildBadgePill('Clear', isDark, isAction: true),
                onTap: _isClearingCache ? null : () => _showClearCacheDialog(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Privacy & Account Security ───────────────────────────────────
          _buildSectionHeader('Privacy & Account Security', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              if (profile != null) ...[
                _buildInteractiveTile(
                  title: 'Profile Privacy',
                  subtitle: 'Control public discovery and leaderboard visibility',
                  icon: Icons.admin_panel_settings_rounded,
                  iconGradient: const [Color(0xFF2563EB), Color(0xFF60A5FA)],
                  textColor: textColor,
                  textMuted: textMuted,
                  onTap: () => context.push('/profile/privacy', extra: profile),
                ),
                _buildDivider(borderColor),
              ],
              _buildInteractiveTile(
                title: 'Change Password',
                subtitle: 'Update your account sign-in password',
                icon: Icons.lock_reset_rounded,
                iconGradient: const [Color(0xFF4B5563), Color(0xFF9CA3AF)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push('/profile/change-password'),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Update Email Address',
                subtitle: auth.currentUser?.email.isNotEmpty == true
                    ? auth.currentUser!.email
                    : 'Manage verified email address',
                icon: Icons.alternate_email_rounded,
                iconGradient: const [Color(0xFF0D9488), Color(0xFF14B8A6)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push(
                  '/profile/update-email',
                  extra: auth.currentUser?.email ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── AI Disclosure & Governance (Play Store Requirement) ──────────
          _buildSectionHeader('AI Transparency & Safety', textMuted),
          _buildAiTransparencyCard(isDark, cardBg, borderColor, textColor, textMuted),
          const SizedBox(height: 24),

          // ── Support, Legal & Community ───────────────────────────────────
          _buildSectionHeader('Support & Legal', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildInteractiveTile(
                title: 'Help Center & Feedback',
                subtitle: 'FAQs, bug reports, and support via $_kSupportEmail',
                icon: Icons.support_agent_rounded,
                iconGradient: const [Color(0xFF059669), Color(0xFF34D399)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push('/help-support'),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Rate Time Explorer',
                subtitle: 'Share your 5-star experience on Google Play',
                icon: Icons.star_rate_rounded,
                iconGradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => _openPlayStoreRating(context),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Share with Friends',
                subtitle: 'Invite fellow historians and time travelers',
                icon: Icons.share_rounded,
                iconGradient: const [Color(0xFF6366F1), Color(0xFF818CF8)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => _shareApp(context),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Privacy Policy',
                subtitle: 'How your data is protected and managed',
                icon: Icons.policy_rounded,
                iconGradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push('/policy', extra: 'Privacy Policy'),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Terms of Service',
                subtitle: 'Rules and terms of using Time Explorer',
                icon: Icons.description_rounded,
                iconGradient: const [Color(0xFF64748B), Color(0xFF94A3B8)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => context.push('/policy', extra: 'Terms of Service'),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Open Source Licenses',
                subtitle: 'Third-party software notices and attribution',
                icon: Icons.code_rounded,
                iconGradient: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                textColor: textColor,
                textMuted: textMuted,
                onTap: () => _showAppLicenses(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Danger Zone ──────────────────────────────────────────────────
          _buildSectionHeader('Account Management', textMuted),
          _buildSettingsContainer(
            cardBg: cardBg,
            borderColor: borderColor,
            children: [
              _buildInteractiveTile(
                title: 'Sign Out',
                subtitle: 'Safely log out of your explorer profile',
                icon: Icons.logout_rounded,
                iconGradient: const [Color(0xFFDC2626), Color(0xFFEF4444)],
                textColor: const Color(0xFFDC2626),
                textMuted: textMuted,
                isDestructive: true,
                onTap: () => _showSignOutDialog(context, auth),
              ),
              _buildDivider(borderColor),
              _buildInteractiveTile(
                title: 'Delete Account',
                subtitle: 'Permanently remove account, badges & historical progress',
                icon: Icons.delete_forever_rounded,
                iconGradient: const [Color(0xFF991B1B), Color(0xFFDC2626)],
                textColor: const Color(0xFFDC2626),
                textMuted: textMuted,
                isDestructive: true,
                onTap: () => _showDeleteAccountDialog(context, auth),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── Footer Branding & Version ────────────────────────────────────
          _buildFooterBranding(context, isDark, textMuted),
        ],
      ),
    );
  }

  // ── User Snapshot Card ────────────────────────────────────────────────────
  Widget _buildUserHeroCard(
    BuildContext context,
    AuthProvider auth,
    dynamic profile,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMuted,
  ) {
    final user = auth.currentUser;
    final displayName = profile?.name ?? user?.displayName ?? 'Time Explorer';
    final email = user?.email ?? 'Explorer Account';
    final avatarUrl = profile?.photoUrl ?? user?.photoUrl;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFF59E0B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: isDark ? const Color(0xFF1E1D32) : const Color(0xFFECEAF8),
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF4F46E5),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: Color(0xFF4F46E5),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (profile != null)
            Material(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push('/profile/personal-info', extra: profile),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: textMuted,
        ),
      ),
    );
  }

  // ── Settings Container ────────────────────────────────────────────────────
  Widget _buildSettingsContainer({
    required Color cardBg,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  // ── Interactive List Tile ─────────────────────────────────────────────────
  Widget _buildInteractiveTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> iconGradient,
    required Color textColor,
    required Color textMuted,
    VoidCallback? onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.first.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDestructive ? const Color(0xFFDC2626) : textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (trailing != null)
                trailing
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: textMuted.withValues(alpha: 0.6),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Switch Tile ───────────────────────────────────────────────────────────
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> iconGradient,
    required bool value,
    required Color textColor,
    required Color textMuted,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: iconGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: iconGradient.first.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF4F46E5),
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // ── AI Transparency & Disclosure Card ─────────────────────────────────────
  Widget _buildAiTransparencyCard(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMuted,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E163B), const Color(0xFF161528)]
              : [const Color(0xFFF3E8FF), const Color(0xFFFAF5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                context.read<SettingsProvider>().triggerHaptic();
                setState(() => _isAiCardExpanded = !_isAiCardExpanded);
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'AI-Powered Chronicles',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Gemini AI',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Historical persona conversations & place stories are powered by Google Gemini AI.',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12.5,
                              color: textMuted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isAiCardExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isAiCardExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                    height: 1,
                  ),
                  const SizedBox(height: 14),
                  _buildAiBullet(
                    Icons.school_rounded,
                    'Educational Purpose',
                    'AI persona simulations are designed for engagement and educational exploration. Always cross-reference primary historical sources.',
                    textColor,
                    textMuted,
                  ),
                  const SizedBox(height: 10),
                  _buildAiBullet(
                    Icons.security_rounded,
                    'Privacy & Data Safety',
                    'Conversations with historical figures do not store personal identifiable data. Prompts are filtered for family-friendly interaction.',
                    textColor,
                    textMuted,
                  ),
                  const SizedBox(height: 10),
                  _buildAiBullet(
                    Icons.verified_user_rounded,
                    'Google Play AI Policy Compliant',
                    'Complies with Google Play generative AI content and safety policies with active moderation.',
                    textColor,
                    textMuted,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAiBullet(
    IconData icon,
    String title,
    String body,
    Color textColor,
    Color textMuted,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF7C3AED)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11.5,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Divider ───────────────────────────────────────────────────────────────
  Widget _buildDivider(Color borderColor) {
    return Divider(height: 1, color: borderColor, indent: 70, endIndent: 18);
  }

  // ── Badge Pill ────────────────────────────────────────────────────────────
  Widget _buildBadgePill(String label, bool isDark, {bool isAction = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isAction
            ? const Color(0xFF0891B2).withValues(alpha: 0.12)
            : (isDark ? const Color(0xFF25233D) : const Color(0xFFEEEBF8)),
        borderRadius: BorderRadius.circular(10),
        border: isAction
            ? Border.all(color: const Color(0xFF0891B2).withValues(alpha: 0.3))
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isAction
              ? const Color(0xFF0891B2)
              : (isDark ? const Color(0xFFC7C5DF) : const Color(0xFF4F46E5)),
        ),
      ),
    );
  }

  // ── Footer Branding ───────────────────────────────────────────────────────
  Widget _buildFooterBranding(BuildContext context, bool isDark, Color textMuted) {
    return Column(
      children: [
        // App Icon Emblem
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3525CD), Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3525CD).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.hourglass_top_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Time Explorer',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF1E1B4B),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
              const ClipboardData(text: 'Time Explorer v$_kAppVersion ($_kBuildNumber) - Production'),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Version build copied to clipboard',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF3525CD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1A2E) : const Color(0xFFEEEDF7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.copy_rounded, size: 12, color: textMuted),
                const SizedBox(width: 4),
                Text(
                  'Version $_kAppVersion (Build $_kBuildNumber)',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '© 2026 Time Explorer. All rights reserved.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            color: textMuted.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ── Theme Selector Bottom Sheet ───────────────────────────────────────────
  void _showThemeSelector(BuildContext context, SettingsProvider settings, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF181728) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose Theme',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1A1B21),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your preferred visual style or sync with device settings',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF9896AE) : const Color(0xFF6B6982),
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption(
                  context: sheetContext,
                  title: 'System Default',
                  subtitle: 'Match your device operating system theme',
                  icon: Icons.brightness_auto_rounded,
                  mode: ThemeMode.system,
                  currentMode: settings.themeMode,
                  isDark: isDark,
                  onSelect: () {
                    settings.setThemeMode(ThemeMode.system);
                    Navigator.pop(sheetContext);
                  },
                ),
                const SizedBox(height: 12),
                _buildThemeOption(
                  context: sheetContext,
                  title: 'Light Mode',
                  subtitle: 'Clean warm canvas with high readability',
                  icon: Icons.light_mode_rounded,
                  mode: ThemeMode.light,
                  currentMode: settings.themeMode,
                  isDark: isDark,
                  onSelect: () {
                    settings.setThemeMode(ThemeMode.light);
                    Navigator.pop(sheetContext);
                  },
                ),
                const SizedBox(height: 12),
                _buildThemeOption(
                  context: sheetContext,
                  title: 'Dark Mode',
                  subtitle: 'Deep OLED space contrast for low light',
                  icon: Icons.dark_mode_rounded,
                  mode: ThemeMode.dark,
                  currentMode: settings.themeMode,
                  isDark: isDark,
                  onSelect: () {
                    settings.setThemeMode(ThemeMode.dark);
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required bool isDark,
    required VoidCallback onSelect,
  }) {
    final isSelected = mode == currentMode;
    return Material(
      color: isSelected
          ? const Color(0xFF4F46E5).withValues(alpha: 0.1)
          : (isDark ? const Color(0xFF222036) : const Color(0xFFF4F3FB)),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onSelect,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4F46E5)
                  : (isDark ? const Color(0xFF33304E) : const Color(0xFFE2E0EE)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : (isDark ? const Color(0xFF2D2B44) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF171725),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF9896AE) : const Color(0xFF6B6982),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF4F46E5), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ── Clear Cache Action ────────────────────────────────────────────────────
  void _showClearCacheDialog(BuildContext context, SettingsProvider settings) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1F1D33)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.cleaning_services_rounded, color: Color(0xFF0891B2), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Clear App Cache',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'This will clear temporary offline maps, cached imagery, and query memory to free up device storage. Your bookmarks, badges, and progress are securely preserved in the cloud.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFB0ADC5)
                : const Color(0xFF5A5870),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B6982),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              setState(() => _isClearingCache = true);
              await settings.clearAppCache();
              await Future.delayed(const Duration(milliseconds: 400));
              if (!mounted) return;
              setState(() => _isClearingCache = false);
              messenger.showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Temporary cache cleared successfully!',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF059669),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Text(
              'Clear Cache',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Share App ─────────────────────────────────────────────────────────────
  Future<void> _shareApp(BuildContext context) async {
    context.read<SettingsProvider>().triggerHaptic();
    const shareText =
        '🌟 Step into living history with Time Explorer!\n\n'
        'Chat with legendary historical figures using AI, embark on virtual timeline quests, and challenge your historical knowledge.\n\n'
        'Download on Google Play:\n$_kPlayStoreUrl';

    try {
      await Share.share(shareText, subject: 'Discover Time Explorer on Google Play');
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  // ── Rate on Google Play ───────────────────────────────────────────────────
  Future<void> _openPlayStoreRating(BuildContext context) async {
    context.read<SettingsProvider>().triggerHaptic();
    final uri = Uri.parse(_kPlayStoreUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Opening Google Play Store...'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch Play Store: $e');
    }
  }

  // ── Open Source Licenses ──────────────────────────────────────────────────
  void _showAppLicenses(BuildContext context) {
    context.read<SettingsProvider>().triggerHaptic();
    showLicensePage(
      context: context,
      applicationName: 'Time Explorer',
      applicationVersion: 'v$_kAppVersion (Build $_kBuildNumber)',
      applicationLegalese: '© 2026 Time Explorer. Built with Flutter & Google Gemini AI.',
      applicationIcon: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3525CD), Color(0xFF7C3AED)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.hourglass_top_rounded, color: Colors.white, size: 36),
      ),
    );
  }

  // ── Sign Out Dialog ───────────────────────────────────────────────────────
  void _showSignOutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1F1D33)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Sign Out',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out? Your streaks and achievements will remain securely saved to your account.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFB0ADC5)
                : const Color(0xFF5A5870),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B6982),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await auth.signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete Account Dialog ─────────────────────────────────────────────────
  void _showDeleteAccountDialog(BuildContext context, AuthProvider auth) {
    final isGoogleUser = FirebaseAuth.instance.currentUser?.providerData
            .any((p) => p.providerId == 'google.com') ??
        false;
    final passwordCtrl = TextEditingController();
    bool obscure = true;
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1F1D33)
              : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action is irreversible and permanently removes:',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 8),
                _buildDeleteWarningPoint('All XP, milestones, and timeline leaderboard ranks'),
                _buildDeleteWarningPoint('Your collected badges, bookmarks, and quiz scores'),
                _buildDeleteWarningPoint('Your profile data and cloud synchronization'),
                const SizedBox(height: 16),
                if (!isGoogleUser) ...[
                  Text(
                    'Confirm your password to proceed:',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFC7C5DF)
                          : const Color(0xFF33304E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: obscure,
                    style: GoogleFonts.beVietnamPro(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Current Password',
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF151424)
                          : const Color(0xFFF3F2FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          size: 18,
                        ),
                        onPressed: () => setDialogState(() => obscure = !obscure),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B6982),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: isDeleting
                  ? null
                  : () async {
                      final password = isGoogleUser ? '' : passwordCtrl.text.trim();
                      if (!isGoogleUser && password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please enter your password to confirm deletion'),
                            backgroundColor: const Color(0xFFDC2626),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isDeleting = true);
                      await auth.deleteAccount(password);
                      if (!dialogContext.mounted) return;

                      if (auth.error != null) {
                        setDialogState(() => isDeleting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed: ${auth.error}'),
                            backgroundColor: const Color(0xFFDC2626),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      } else {
                        Navigator.pop(dialogContext);
                        if (context.mounted) {
                          context.go('/');
                        }
                      }
                    },
              child: isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Permanently Delete',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFFDC2626)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: const Color(0xFF8B88A5),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
