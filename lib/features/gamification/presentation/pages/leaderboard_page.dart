import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/fade_slide_in.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/leaderboard_provider.dart';
import '../../domain/entities/leaderboard_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static const _primary = AppTheme.primaryContainer;
  static const _bg = AppTheme.background;
  static const _surfaceLow = AppTheme.surfaceLow;
  static const _textDark = AppTheme.onSurface;
  static const _textMuted = AppTheme.onSurfaceVariant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().listenToLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Leaderboard',
            style: GoogleFonts.plusJakartaSans(
                color: _textDark, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<LeaderboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ThemedLoading(context: 'leaderboard');
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.users.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              _buildTopThree(provider.users.take(3).toList()),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    itemCount: provider.users.length > 3 ? provider.users.length - 3 : 0,
                    itemBuilder: (context, index) {
                      final user = provider.users[index + 3];
                      return FadeSlideIn(
                        index: index,
                        child: _buildUserListTile(user, index + 3, provider),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopThree(List<LeaderboardUser> topUsers) {
    if (topUsers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (topUsers.length > 1) _buildPodiumItem(topUsers[1], 1, 140),
          if (topUsers.isNotEmpty) _buildPodiumItem(topUsers[0], 0, 180, isWinner: true),
          if (topUsers.length > 2) _buildPodiumItem(topUsers[2], 2, 120),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Joined Unknown';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Joined ${months[date.month - 1]} ${date.year}';
  }

  Widget _getBadge(int position) {
    switch (position) {
      case 0:
        return const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD700), size: 24);
      case 1:
        return const Icon(Icons.workspace_premium_rounded, color: Color(0xFFC0C0C0), size: 20);
      case 2:
        return const Icon(Icons.workspace_premium_rounded, color: Color(0xFFCD7F32), size: 18);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPodiumItem(LeaderboardUser user, int index, double height, {bool isWinner = false}) {
    final size = isWinner ? 85.0 : 70.0;
    final borderColor = index == 0
        ? const Color(0xFFFFD700)
        : index == 1
            ? const Color(0xFFC0C0C0)
            : const Color(0xFFCD7F32);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 3),
              ),
              child: ClipOval(child: _UserAvatar(user: user, size: size)),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: _getBadge(index),
            ),
            Positioned(
              bottom: -4,
              left: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: index == 0 ? const Color(0xFFFFD700) : (index == 1 ? const Color(0xFFC0C0C0) : (index == 2 ? const Color(0xFFCD7F32) : Colors.white)),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: _textDark,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Lvl ${user.level}',
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              color: _primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${user.xp} XP',
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            color: _primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_outlined, size: 10, color: _textMuted),
            const SizedBox(width: 4),
            Text(
              '${user.placesExploredCount} Explored',
              style: GoogleFonts.beVietnamPro(
                fontSize: 9,
                color: _textMuted,
              ),
            ),
          ],
        ),
        Text(
          _formatDate(user.createdAt),
          style: GoogleFonts.beVietnamPro(
            fontSize: 8,
            color: _textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildUserListTile(LeaderboardUser user, int index, LeaderboardProvider provider) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCurrentUser = user.id == currentUser?.uid;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? _primary.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrentUser ? _primary.withOpacity(0.3) : _surfaceLow,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  provider.getPositionLabel(index),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: _textMuted,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: ClipOval(child: _UserAvatar(user: user, size: 48)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Level ${user.level}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: _primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${user.xp}',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: _textDark,
                    ),
                  ),
                  Text(
                    'XP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.explore_outlined, size: 14, color: _textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${user.placesExploredCount} Places Explored',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),
              Text(
                _formatDate(user.createdAt),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11,
                  color: _textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Avatar with network photo + initials fallback ─────────────────────────────

class _UserAvatar extends StatelessWidget {
  final LeaderboardUser user;
  final double size;

  const _UserAvatar({required this.user, required this.size});

  String get _initials {
    final parts = user.name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
  }

  Color get _bgColor {
    const colors = [
      Color(0xFF4F46E5),
      Color(0xFF7C3AED),
      Color(0xFF0891B2),
      Color(0xFF059669),
      Color(0xFFD97706),
      Color(0xFFDC2626),
    ];
    return colors[user.name.codeUnits.fold(0, (a, b) => a + b) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final url = user.photoUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _InitialsAvatar(
          initials: _initials,
          bgColor: _bgColor,
          size: size,
        ),
        placeholder: (_, __) => _InitialsAvatar(
          initials: _initials,
          bgColor: _bgColor,
          size: size,
        ),
      );
    }
    return _InitialsAvatar(initials: _initials, bgColor: _bgColor, size: size);
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color bgColor;
  final double size;

  const _InitialsAvatar({
    required this.initials,
    required this.bgColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: bgColor,
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.plusJakartaSans(
            fontSize: size * 0.32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
