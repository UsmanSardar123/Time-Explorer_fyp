import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _supportEmail = 'usmansardar037@gmail.com';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Help & Feedback',
          style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800, color: AppTheme.onSurface),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSupportHeader(),
          const SizedBox(height: 32),
          _buildOption(
            context: context,
            cardColor: cardColor,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Report issues or suggest improvements',
            color: AppTheme.primaryContainer,
            onTap: () => _showFeedbackDialog(context),
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            cardColor: cardColor,
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Something not working? Let us know',
            color: AppTheme.error,
            onTap: () => _showFeedbackDialog(context, isBug: true),
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            cardColor: cardColor,
            icon: Icons.mail_outline_rounded,
            title: 'Contact Support',
            subtitle: 'Email us at $_supportEmail',
            color: Colors.green,
            onTap: () => _launchEmail(context, subject: 'Time Explorer Support'),
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            cardColor: cardColor,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy & AI Disclosure',
            subtitle: 'How we handle your data and AI content',
            color: const Color(0xFF7C3AED),
            onTap: () => Navigator.of(context).pushNamed('/policy'),
          ),
          const SizedBox(height: 32),
          _buildBetaBanner(),
        ],
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.headset_mic_outlined,
              size: 48, color: AppTheme.primaryContainer),
        ),
        const SizedBox(height: 16),
        Text(
          'How can we help you?',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          'This is a beta release. Your feedback helps us improve.',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
              color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required Color cardColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700,
                color: AppTheme.onSurface)),
        subtitle: Text(subtitle,
            style: GoogleFonts.beVietnamPro(
                fontSize: 12, color: AppTheme.onSurfaceVariant)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppTheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildBetaBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.science_outlined, color: AppTheme.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beta Release',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  'You are using a pre-release version of Time Explorer. Some features may be unstable. Your feedback is essential to improving the experience.',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, {bool isBug = false}) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isBug ? Icons.bug_report_outlined : Icons.feedback_outlined,
              color: isBug ? AppTheme.error : AppTheme.primaryContainer,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              isBug ? 'Report a Bug' : 'Send Feedback',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800, color: AppTheme.onSurface),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isBug
                  ? 'Describe what happened and the steps to reproduce it:'
                  : 'Share your thoughts, suggestions, or what you love:',
              style: GoogleFonts.beVietnamPro(
                  fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 4,
              maxLength: 500,
              style: GoogleFonts.beVietnamPro(fontSize: 14),
              decoration: InputDecoration(
                hintText: isBug
                    ? 'e.g. App crashed when I opened the quiz...'
                    : 'e.g. The character voices feel really immersive...',
                hintStyle:
                    GoogleFonts.beVietnamPro(color: AppTheme.onSurfaceVariant),
                filled: true,
                fillColor: AppTheme.surfaceLow,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel',
                style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isBug ? AppTheme.error : AppTheme.primaryContainer,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isEmpty) return;
              Navigator.of(dialogContext).pop();
              final subject = isBug
                  ? 'Bug Report — Time Explorer Beta'
                  : 'Feedback — Time Explorer Beta';
              _launchEmail(context, subject: subject, body: text);
            },
            child: Text(
              'Send',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context,
      {required String subject, String body = ''}) async {
    final encoded = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=${Uri.encodeComponent(subject)}'
          '${body.isNotEmpty ? '&body=${Uri.encodeComponent(body)}' : ''}',
    );
    if (!await launchUrl(encoded)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email app. Contact us at $_supportEmail'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
