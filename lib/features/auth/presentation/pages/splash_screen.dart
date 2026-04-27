import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _nameOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _loadingOpacity;
  late Animation<double> _loadingProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.267, curve: Curves.elasticOut), // 0-800ms
    );

    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.133, 0.333, curve: Curves.easeIn), // 400-1000ms
    );

    _taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.233, 0.433, curve: Curves.easeIn), // 700-1300ms
    );

    _loadingOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.333, 0.433, curve: Curves.easeIn), // 1000-1300ms
    );

    _loadingProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.333, 1.0, curve: Curves.linear), // 1000-3000ms
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -50,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE8D6).withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE8D6).withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. App logo/icon
                ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1B17).withValues(alpha: 0.08),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.history_edu_rounded,
                      size: 80,
                      color: AppTheme.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // 2. App name
                FadeTransition(
                  opacity: _nameOpacity,
                  child: Text(
                    'Time Explorer',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // 3. Tagline
                FadeTransition(
                  opacity: _taglineOpacity,
                  child: Text(
                    'Explore History Like Never Before',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 4. Loading bar at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _loadingOpacity,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E1DA),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: AnimatedBuilder(
                        animation: _loadingProgress,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _loadingProgress.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryContainer,
                                    Color(0xFF818CF8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
