import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/food_art.dart';
import '../widgets/status_badge.dart';

double _radarRadius(Size size) =>
    math.max(40, math.min(size.width, size.height) / 2 - 36);

/// La distancia al centro equivale a los minutos a pie; el ángulo sale de la
/// posición ilustrativa del menú.
Offset _pinCenter(CampusMenu menu, Size size) {
  final angle = math.atan2(menu.positionY - 0.5, menu.positionX - 0.5);
  return size.center(Offset.zero) +
      Offset(math.cos(angle), math.sin(angle)) *
          (radarFraction(menu.walkMinutes) * _radarRadius(size));
}

class RadarTab extends StatefulWidget {
  const RadarTab({super.key, required this.store, required this.onOpen});

  final MenuStore store;
  final ValueChanged<CampusMenu> onOpen;

  @override
  State<RadarTab> createState() => _RadarTabState();
}

class _RadarTabState extends State<RadarTab> with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();
  String? _selectedId;

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final menus = widget.store.menus;
      final selected = menus.where((menu) => menu.id == _selectedId).firstOrNull;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
                        'Radar',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.navy,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        'Locales a minutos del campus',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${menus.length} locales',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.biggest;
                    final center = size.center(Offset.zero);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _selectedId = null),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: _RadarPainter(_sweep)),
                          ),
                          Positioned(
                            left: center.dx - 28,
                            top: center.dy - 24,
                            width: 56,
                            child: const _CampusMarker(),
                          ),
                          for (final menu in menus)
                            Positioned(
                              left: _pinCenter(menu, size).dx - 32,
                              top: _pinCenter(menu, size).dy - 23,
                              width: 64,
                              child: _RadarPin(
                                menu: menu,
                                selected: menu.id == _selectedId,
                                onTap: () => setState(() => _selectedId = menu.id),
                              ),
                            ),
                          const Positioned(top: 14, left: 16, right: 16, child: _Legend()),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 12,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, 0.25),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                              child: selected == null
                                  ? const _Hint(key: ValueKey('hint'))
                                  : _PreviewCard(
                                      key: ValueKey(selected.id),
                                      menu: selected,
                                      onOpen: () => widget.onOpen(selected),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _RadarPainter extends CustomPainter {
  _RadarPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  static const _glow = Color(0xFFFF8A3D);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = _radarRadius(size);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF26507A), Color(0xFF0C192B)],
        ).createShader(Rect.fromCircle(center: center, radius: size.longestSide * 0.7)),
    );

    final line = Paint()
      ..color = Colors.white.withAlpha(46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas
      ..drawLine(Offset(center.dx, center.dy - radius - 14), Offset(center.dx, center.dy + radius + 14), line)
      ..drawLine(Offset(center.dx - radius - 14, center.dy), Offset(center.dx + radius + 14, center.dy), line);
    for (final minutes in const [2, 4, radarMaxMinutes]) {
      final r = radius * radarFraction(minutes);
      canvas.drawCircle(center, r, line);
      _label(canvas, '$minutes min', Offset(center.dx + 6, center.dy - r + 3));
    }

    final angle = animation.value * 2 * math.pi;
    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..shader = SweepGradient(
            colors: const [Color(0x00FF8A3D), Color(0x00FF8A3D), Color(0x70FF8A3D)],
            stops: const [0, 0.7, 1],
            transform: GradientRotation(angle),
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      )
      ..drawLine(
        center,
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        Paint()
          ..color = _glow.withAlpha(190)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

    final pulse = (animation.value * 3) % 1;
    canvas.drawCircle(
      center,
      22 + pulse * 46,
      Paint()
        ..color = _glow.withAlpha(((1 - pulse) * 150).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _label(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withAlpha(140),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => false;
}

class _CampusMarker extends StatelessWidget {
  const _CampusMarker();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.orange,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Color(0x99FF8A3D), blurRadius: 16, spreadRadius: 2)],
        ),
        child: const Icon(Icons.school_rounded, color: Colors.white),
      ),
    ],
  );
}

class _RadarPin extends StatelessWidget {
  const _RadarPin({
    required this.menu,
    required this.selected,
    required this.onTap,
  });

  final CampusMenu menu;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = availabilityColor(menu.availability);
    return Semantics(
      button: true,
      label: '${menu.restaurant}, ${menu.walkMinutes} minutos, ${menu.availability.label}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.2 : 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(selected ? 210 : 120),
                      blurRadius: selected ? 20 : 10,
                      spreadRadius: selected ? 4 : 1,
                    ),
                  ],
                ),
                child: Icon(categoryIcon(menu.category), color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'S/ ${menu.price.toStringAsFixed(0)}',
                style: AppText.display(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 4,
    children: [
      for (final status in MenuAvailability.values)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 9, color: availabilityColor(status)),
            const SizedBox(width: 5),
            Text(
              status.label,
              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
    ],
  );
}

class _Hint extends StatelessWidget {
  const _Hint({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(30),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.touch_app_rounded, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Text(
          'Toca un local',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({super.key, required this.menu, required this.onOpen});

  final CampusMenu menu;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: FoodBanner(
                category: menu.category,
                radius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    menu.restaurant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.display(19),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${menu.walkMinutes} min · S/ ${menu.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  StatusBadge(status: menu.availability),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange,
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
