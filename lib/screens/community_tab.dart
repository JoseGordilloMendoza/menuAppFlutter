import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/food_art.dart';
import '../widgets/status_badge.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key, required this.store});

  final MenuStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final notices = store.notices;
      return ListView(
        padding: const EdgeInsets.only(bottom: 110),
        children: [
          _Header(count: notices.length),
          const SizedBox(height: 8),
          for (var i = 0; i < notices.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _NoticeBubble(notice: notices[i], alignRight: i.isOdd),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(
              'Avisos de ejemplo. Los nuevos duran solo esta sesión.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 244 + top,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 206 + top,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.orange, AppColors.ember],
                  ),
                ),
                child: CustomPaint(painter: _BlobPainter()),
              ),
            ),
          ),
          Positioned(
            right: -34,
            top: top + 6,
            child: Transform.rotate(
              angle: 0.35,
              child: const SizedBox(
                width: 170,
                height: 170,
                child: FoodArt(category: 'Chifa'),
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: top + 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comunidad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Avisos de otros estudiantes',
                  style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 15),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 12,
            child: Transform.rotate(
              angle: -0.06,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.sun,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.navy),
                    const SizedBox(width: 6),
                    Text(
                      '$count avisos recientes',
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
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

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height - 36)
    ..quadraticBezierTo(size.width * 0.25, size.height + 8, size.width * 0.52, size.height - 24)
    ..quadraticBezierTo(size.width * 0.80, size.height - 54, size.width, size.height - 14)
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final soft = Paint()..color = Colors.white.withAlpha(24);
    canvas
      ..drawCircle(Offset(size.width * 0.9, size.height * 0.1), 120, soft)
      ..drawCircle(Offset(size.width * 0.05, size.height * 0.85), 90, soft)
      ..drawCircle(Offset(size.width * 0.5, size.height * 0.05), 40, soft);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NoticeBubble extends StatelessWidget {
  const _NoticeBubble({required this.notice, required this.alignRight});

  final CommunityNotice notice;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final status = availabilityColor(notice.availability);
    final style = categoryStyle(notice.category);
    final bubble = Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
        decoration: BoxDecoration(
          color: Color.alphaBlend(status.withAlpha(24), Colors.white),
          border: Border.all(color: status.withAlpha(80), width: 1.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30),
            bottomLeft: Radius.circular(alignRight ? 30 : 6),
            bottomRight: Radius.circular(alignRight ? 6 : 30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.restaurant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '${notice.author} · ${_timeLabel(notice.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3)),
                    ],
                  ),
                  child: ClipOval(child: FoodBanner(category: notice.category)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.message,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Transform.rotate(
              angle: alignRight ? 0.04 : -0.04,
              child: StatusBadge(status: notice.availability, solid: true),
            ),
          ],
        ),
      ),
    );
    final avatar = Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [style.top, style.bottom],
              ),
            ),
            child: Text(
              notice.author.characters.first.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(availabilityIcon(notice.availability), size: 18, color: status),
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.only(left: alignRight ? 28 : 0, right: alignRight ? 0 : 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: alignRight
            ? [bubble, const SizedBox(width: 10), avatar]
            : [avatar, const SizedBox(width: 10), bubble],
      ),
    );
  }

  String _timeLabel(DateTime time) {
    final minutes = DateTime.now().difference(time).inMinutes;
    if (minutes < 1) return 'ahora';
    if (minutes < 60) return 'hace $minutes min';
    return 'hace ${minutes ~/ 60} h';
  }
}
