import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  // ── Design Tokens ─────────────────────────────────────────────────────────
  static const _primary = AppTheme.primaryContainer;
  static const _primaryLight = Color(0xFF818CF8);
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  
  bool _isButtonPressed = false;

  late AnimationController _mascotController;

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
            _dobController.text.trim(),
          );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              onPrimary: Colors.white,
              surface: _bg,
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 1. Floating Mascot
              AnimatedBuilder(
                animation: _mascotController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 10 * _mascotController.value),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: _surfaceLow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1AAB3500),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person_add_rounded, size: 50, color: _primary),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // 2. Header
              Text(
                'Join the Discovery',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your timeline account',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  color: _textMuted,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 3. Form Card
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _textDark.withValues(alpha: 0.04),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField('Full Name', Icons.person_outline, _nameController),
                      const SizedBox(height: 20),
                      _buildTextField('Email', Icons.email_outlined, _emailController),
                      const SizedBox(height: 20),
                      _buildTextField('Password', Icons.lock_outline, _passwordController, obscure: true),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField('Date of Birth', Icons.calendar_today_outlined, _dobController),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 4. Sign Up Button
              _buildSignUpButton(authProvider),
              
              const SizedBox(height: 24),
              // Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Already a traveler? ', style: GoogleFonts.beVietnamPro(color: _textMuted)),
                   GestureDetector(
                     onTap: () => context.pop(),
                     child: Text(
                       'Sign In',
                       style: GoogleFonts.plusJakartaSans(
                         color: _primary,
                         fontWeight: FontWeight.w800,
                       ),
                     ),
                   ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _surfaceLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.beVietnamPro(color: _textDark, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: _primary, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(AuthProvider authProvider) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) {
        setState(() => _isButtonPressed = false);
        _submit();
      },
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_primary, _primaryLight]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: authProvider.isLoading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  'Join the Adventure',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
