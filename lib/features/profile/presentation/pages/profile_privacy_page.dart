import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';

class ProfilePrivacyPage extends StatefulWidget {
  final ProfileEntity profile;
  const ProfilePrivacyPage({super.key, required this.profile});

  @override
  State<ProfilePrivacyPage> createState() => _ProfilePrivacyPageState();
}

class _ProfilePrivacyPageState extends State<ProfilePrivacyPage> {
  late bool _isPublic;
  late String _privacyPreference;

  static const _levels = [
    _PrivacyLevel(
      value: 'standard',
      label: 'Standard',
      description: 'Visible to all explorers',
    ),
    _PrivacyLevel(
      value: 'limited',
      label: 'Limited',
      description: 'Hide sensitive stats',
    ),
    _PrivacyLevel(
      value: 'followers',
      label: 'Followers Only',
      description: 'Only approved followers see details',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isPublic = widget.profile.privacySettings != 'private';
    _privacyPreference =
        (widget.profile.privacySettings == null ||
                widget.profile.privacySettings == 'private')
            ? 'standard'
            : widget.profile.privacySettings!;
  }

  Future<void> _savePrivacy() async {
    final newSetting = _isPublic ? _privacyPreference : 'private';
    final updatedProfile =
        widget.profile.copyWith(privacySettings: newSetting);

    try {
      final provider = context.read<ProfileProvider>();
      await provider.updateProfile(updatedProfile);

      if (!mounted) return;

      if (provider.error != null) {
        _showSnackbar(provider.error!, isError: true);
        return;
      }

      Navigator.pop(context);
      _showSnackbar('Privacy settings updated.');
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('Failed to save. Please try again.', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.beVietnamPro(color: Colors.white),
        ),
        backgroundColor:
            isError ? AppTheme.error : AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile Privacy',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppTheme.onSurface,
          ),
        ),
        actions: [
          Consumer<ProfileProvider>(
            builder: (_, pp, child) => pp.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryContainer,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _savePrivacy,
                    icon: const Icon(Icons.check_rounded,
                        color: AppTheme.primaryContainer),
                    tooltip: 'Save',
                  ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          _buildCard(
            child: SwitchListTile(
              title: Text(
                'Public Profile',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.onSurface),
              ),
              subtitle: Text(
                'Allow others to find and view your explorer profile',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant),
              ),
              value: _isPublic,
              onChanged: (val) => setState(() => _isPublic = val),
              thumbColor: WidgetStateProperty.resolveWith((s) =>
                  s.contains(WidgetState.selected) ? AppTheme.primaryContainer : null),
            ),
          ),
          if (_isPublic) ...[
            const SizedBox(height: 24),
            Text(
              'Privacy Level',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: RadioGroup<String>(
                groupValue: _privacyPreference,
                onChanged: (val) {
                  if (val != null) setState(() => _privacyPreference = val);
                },
                child: Column(
                  children: List.generate(_levels.length, (i) {
                    final level = _levels[i];
                    final isLast = i == _levels.length - 1;
                    return Column(
                      children: [
                        RadioListTile<String>(
                          value: level.value,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            level.label,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            level.description,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (!isLast)
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: AppTheme.outlineVariant,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Note: Even with a private profile, your display name may appear in shared features like leaderboards if you participate.',
            style: GoogleFonts.beVietnamPro(
              color: AppTheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _PrivacyLevel {
  final String value;
  final String label;
  final String description;
  const _PrivacyLevel(
      {required this.value,
      required this.label,
      required this.description});
}
