import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  final ProfileEntity profile;
  const PersonalInfoPage({super.key, required this.profile});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _gender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: widget.profile.dob ?? '');
    _phoneController = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.profile.address ?? '');
    _gender = widget.profile.gender;
  }

  @override
  void dispose() {
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveInfo() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = widget.profile.copyWith(
        dob: _dobController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        gender: _gender,
      );

      await context.read<ProfileProvider>().updateProfile(updatedProfile);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personal information updated')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        elevation: 0,
        actions: [
          IconButton(onPressed: _saveInfo, icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _dobController,
                label: 'Date of Birth',
                icon: Icons.calendar_today_rounded,
                cardColor: cardColor,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dobController.text = "${date.day}/${date.month}/${date.year}";
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_android_rounded,
                cardColor: cardColor,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                cardColor: cardColor,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12),
                child: Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              _buildGenderSelector(cardColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(Color cardColor) {
    final genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: genders.map((g) => RadioListTile<String>(
          title: Text(g),
          value: g,
          groupValue: _gender,
          onChanged: (val) => setState(() => _gender = val),
          activeColor: Colors.teal.shade500,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        )).toList(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color cardColor,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal.shade500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
