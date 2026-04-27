import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';

class UpdateEmailPage extends StatefulWidget {
  final String currentEmail;
  const UpdateEmailPage({super.key, required this.currentEmail});

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();
      try {
        await provider.updateEmail(
          _emailController.text,
          currentPassword: _passwordController.text,
        );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent to new address')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error ?? 'Failed to update email')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        label: 'New Email Address',
                        icon: Icons.email_outlined,
                        cardColor: cardColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter an email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Current Password',
                        icon: Icons.lock_outline_rounded,
                        cardColor: cardColor,
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Password required for verification' : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _updateEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Update Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Note: You will need to verify your new email address before it becomes active.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color cardColor,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
