import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ThemedLoading extends StatelessWidget {
  final String context;
  final String? message;

  const ThemedLoading({
    super.key,
    required this.context,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    switch (this.context) {
      case 'events':
        return _buildEventsLoading();
      case 'leaderboard':
        return _buildLeaderboardLoading();
      case 'chat':
        return _buildChatLoading();
      case 'categories':
        return _buildCategoriesLoading();
      default:
        return _buildGenericLoading();
    }
  }

  Widget _buildEventsLoading() {
    return Column(
      children: List.generate(3, (index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      )),
    );
  }

  Widget _buildLeaderboardLoading() {
    return Column(
      children: [
        const SizedBox(height: 32),
        // Podium Shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Container(
                  width: index == 1 ? 80 : 64,
                  height: index == 1 ? 80 : 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 12),
                Container(width: 60, height: 12, color: Colors.white),
              ],
            ),
          )),
        ),
        const SizedBox(height: 48),
        // List Shimmer
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 6,
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _PulsingIcon(icon: Icons.chat_bubble_outline_rounded),
          const SizedBox(height: 16),
          Text(
            message ?? 'Parchment unfolding...',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildGenericLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _RotatingCompass(),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  const _PulsingIcon({required this.icon});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.icon, size: 48, color: AppTheme.primary),
    );
  }
}

class _RotatingCompass extends StatefulWidget {
  const _RotatingCompass();

  @override
  State<_RotatingCompass> createState() => _RotatingCompassState();
}

class _RotatingCompassState extends State<_RotatingCompass> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.explore_outlined, size: 56, color: AppTheme.primary),
    );
  }
}
