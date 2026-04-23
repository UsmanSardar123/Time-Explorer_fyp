import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String? _privacyPreference;

  @override
  void initState() {
    super.initState();
    // Assuming privacySettings is a JSON string or simple string for now
    _isPublic = widget.profile.privacySettings != 'private';
    _privacyPreference = widget.profile.privacySettings ?? 'standard';
  }

  Future<void> _savePrivacy() async {
    final updatedProfile = widget.profile.copyWith(
      privacySettings: _isPublic ? _privacyPreference : 'private',
    );

    await context.read<ProfileProvider>().updateProfile(updatedProfile);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Privacy settings updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Privacy'),
        elevation: 0,
        actions: [
          IconButton(onPressed: _savePrivacy, icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildCard(
            cardColor: cardColor,
            child: SwitchListTile(
              title: const Text('Public Profile', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Allow others to find and view your explorer profile'),
              value: _isPublic,
              onChanged: (val) => setState(() => _isPublic = val),
              activeColor: Colors.orange.shade500,
            ),
          ),
          if (_isPublic) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12),
              child: Text('Privacy Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            _buildCard(
              cardColor: cardColor,
              child: Column(
                children: [
                  _buildRadioTile('Standard', 'Visible to all explorers', 'standard'),
                  _buildRadioTile('Limited', 'Hide sensitive stats', 'limited'),
                  _buildRadioTile('Followers Only', 'Only approved followers see details', 'followers'),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Note: Even with a private profile, your basic info like display name might be visible in shared features like leaderboards if you participate.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Color cardColor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRadioTile(String title, String subtitle, String value) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: _privacyPreference,
      onChanged: (val) => setState(() => _privacyPreference = val),
      activeColor: Colors.orange.shade500,
    );
  }
}
