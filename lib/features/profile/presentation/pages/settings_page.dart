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
