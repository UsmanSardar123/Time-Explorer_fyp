import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/notifications/domain/entities/notification_entity.dart';
import 'package:timeexplorer/features/notifications/presentation/providers/notification_provider.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

  @override
  State<NotificationHistoryPage> createState() =>
      _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationProvider>().markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _NotifAppBar(hasUnread: provider.unreadCount > 0),
              if (provider.isLoading)
                const SliverFillRemaining(
                    child: _LoadingView())
              else if (provider.notifications.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
              else
                _NotificationList(
                  notifications: provider.notifications,
                  onTap: (n) => _handleTap(context, provider, n),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleTap(
    BuildContext context,
    NotificationProvider provider,
    NotificationEntity notification,
  ) {
    provider.markAsRead(notification.id);
    if (notification.actionRoute != null) {
      context.push(notification.actionRoute!);
    }
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _NotifAppBar extends StatelessWidget {
  final bool hasUnread;
  const _NotifAppBar({required this.hasUnread});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
      ),
      title: Text(
        'Notifications',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppTheme.onSurface,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppTheme.outlineVariant),
      ),
    );
  }
}

// ── Notification List ─────────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final void Function(NotificationEntity) onTap;

  const _NotificationList(
      {required this.notifications, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) return const SizedBox(height: 12);
          if (index == notifications.length + 1) return const SizedBox(height: 32);
          final n = notifications[index - 1];
          return _NotificationCard(notification: n, onTap: () => onTap(n));
        },
        childCount: notifications.length + 2,
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread
              ? AppTheme.primaryContainer.withValues(alpha: 0.07)
              : AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unread
                ? AppTheme.primaryContainer.withValues(alpha: 0.28)
                : AppTheme.outlineVariant,
          ),
          boxShadow: unread
              ? [
                  BoxShadow(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TypeIcon(type: notification.type),
            const SizedBox(width: 14),
            Expanded(child: _CardContent(notification: notification)),
            if (unread) const _UnreadDot(),
          ],
        ),
      ),
    );
  }
}

// ── Type Icon ─────────────────────────────────────────────────────────────────

class _TypeIcon extends StatelessWidget {
  final NotificationType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final icon = _icon();
    final color = _color();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  IconData _icon() {
    switch (type) {
      case NotificationType.streakReminder:
        return Icons.local_fire_department_rounded;
      case NotificationType.xpReward:
        return Icons.star_rounded;
      case NotificationType.eraUnlocked:
        return Icons.explore_rounded;
      case NotificationType.dailyMission:
        return Icons.assignment_outlined;
      case NotificationType.adminAnnouncement:
        return Icons.campaign_rounded;
    }
  }

  Color _color() {
    switch (type) {
      case NotificationType.streakReminder:
        return AppTheme.amber;
      case NotificationType.xpReward:
        return AppTheme.amber;
      case NotificationType.eraUnlocked:
        return AppTheme.primaryContainer;
      case NotificationType.dailyMission:
        return AppTheme.accentGreen;
      case NotificationType.adminAnnouncement:
        return AppTheme.primaryContainer;
    }
  }
}

// ── Card Content ──────────────────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  final NotificationEntity notification;
  const _CardContent({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight:
                notification.isRead ? FontWeight.w600 : FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          notification.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            color: AppTheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _timeAgo(notification.createdAt),
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            color: AppTheme.outlineVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}

// ── Unread Dot ────────────────────────────────────────────────────────────────

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      margin: const EdgeInsets.only(top: 3, left: 6),
      decoration: const BoxDecoration(
        color: AppTheme.primaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 52,
                color: AppTheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'All caught up!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Earn XP, complete missions, and explore eras to get updates here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppTheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading State ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryContainer),
    );
  }
}
