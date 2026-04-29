import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class BridgeToChatButton extends StatelessWidget {
  final String placeId;

  const BridgeToChatButton({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.push('/personalities'),
        icon: const Icon(Icons.chat_bubble_rounded),
        label: Text(
          'Ask a Time Legend',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryElectric,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
