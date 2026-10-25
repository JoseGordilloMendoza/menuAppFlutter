import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Colores asociados a cada tipo de cocina.
class CategoryStyle {
  const CategoryStyle({
    required this.top,
    required this.bottom,
    required this.accent,
  });

  final Color top;
  final Color bottom;
  final Color accent;
}

CategoryStyle categoryStyle(String category) => switch (category) {
  'Vegetariano' => const CategoryStyle(
    top: Color(0xFF34B386),
    bottom: Color(0xFF0B6B52),
    accent: Color(0xFFC6F5DC),
  ),
  'Chifa' => const CategoryStyle(
    top: Color(0xFFEE5A45),
    bottom: Color(0xFF9E1F2B),
    accent: Color(0xFFFFD98A),
  ),
  'Criollo' => const CategoryStyle(
    top: Color(0xFFF8A02E),
    bottom: Color(0xFFD4510B),
    accent: Color(0xFFFFE6B8),
  ),
  _ => const CategoryStyle(
    top: Color(0xFF6A7BA2),
    bottom: Color(0xFF14233A),
    accent: Color(0xFFDDE5F7),
  ),
};

IconData categoryIcon(String category) => switch (category) {
  'Vegetariano' => Icons.eco_rounded,
  'Chifa' => Icons.ramen_dining_rounded,
  'Criollo' => Icons.restaurant_rounded,
  _ => Icons.lunch_dining_rounded,
};

/// Fondo con degradado y la ilustración del plato asomando por una esquina.
/// Si [height] es nulo, ocupa el alto que le entregue el padre.
class FoodBanner extends StatelessWidget {
  const FoodBanner({
    super.key,
    required this.category,
    this.height,
    this.radius = BorderRadius.zero,
    this.child,
  });

  final String category;
  final double? height;
  final BorderRadius radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(category);
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [style.top, style.bottom],
                ),
              ),
            ),
            CustomPaint(painter: _BackdropPainter(style.accent)),
            LayoutBuilder(
              builder: (context, constraints) {
                final side =
                    math.min(constraints.maxHeight, constraints.maxWidth) * 1.1;
                return Stack(
                  children: [
                    Positioned(
                      right: -side * 0.06,
                      bottom: -side * 0.14,
                      width: side,
                      height: side,
                      child: FoodArt(category: category),
                    ),
                  ],
                );
              },
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

/// Ilustración vectorial del plato típico de cada cocina.
class FoodArt extends StatelessWidget {
  const FoodArt({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(painter: _FoodPainter(category)),
  );
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.25),
      size.height * 0.62,
      Paint()..color = accent.withAlpha(38),
    );
    canvas.drawCircle(
      Offset(size.width * 0.04, size.height),
      size.height * 0.55,
      Paint()..color = Colors.white.withAlpha(22),
    );
    final dot = Paint()..color = Colors.white.withAlpha(70);
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 3; j++) {
        canvas.drawCircle(Offset(18 + i * 12.0, 18 + j * 12.0), 1.7, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

Paint _fill(Color color) => Paint()..color = color;

Paint _stroke(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round;

void _bar(
  Canvas canvas,
  Offset center,
  double width,
  double height,
  double angle,
  Color color,
) {
  canvas
    ..save()
    ..translate(center.dx, center.dy)
    ..rotate(angle)
    ..drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: width, height: height),
        Radius.circular(math.min(width, height) * 0.45),
      ),
      _fill(color),
    )
    ..restore();
}

class _FoodPainter extends CustomPainter {
  _FoodPainter(this.category);

  final String category;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width, size.height);
    switch (category) {
      case 'Criollo':
        _criollo(canvas);
      case 'Vegetariano':
        _vegetariano(canvas);
      case 'Chifa':
        _chifa(canvas);
      default:
        _cloche(canvas);
    }
    canvas.restore();
  }

  /// Lomo saltado visto desde arriba: arroz, papas fritas y tiras de carne.
  void _criollo(Canvas c) {
    c
      ..drawCircle(const Offset(0.52, 0.58), 0.40, _fill(const Color(0x33000000)))
      ..drawCircle(const Offset(0.5, 0.52), 0.40, _fill(Colors.white))
      ..drawCircle(const Offset(0.5, 0.52), 0.31, _fill(const Color(0xFFF1EBE0)))
      ..drawOval(
        Rect.fromCenter(center: const Offset(0.37, 0.60), width: 0.30, height: 0.24),
        _fill(const Color(0xFFFFF7E0)),
      );
    final grain = _stroke(const Color(0xFFE6D5A8), 0.008);
    for (var i = 0; i < 10; i++) {
      final o = Offset(
        0.37 + 0.10 * math.cos(i * 1.7) * ((i % 3) + 1) / 3,
        0.60 + 0.07 * math.sin(i * 2.3) * ((i % 3) + 1) / 3,
      );
      c.drawLine(o, o.translate(0.022, 0.010), grain);
    }
    const fries = [
      (0.60, 0.66, 0.35),
      (0.65, 0.61, -0.20),
      (0.70, 0.67, 0.80),
      (0.63, 0.72, -0.45),
      (0.69, 0.58, 0.10),
      (0.58, 0.60, 1.20),
    ];
    for (final (x, y, a) in fries) {
      _bar(c, Offset(x, y), 0.15, 0.036, a, const Color(0xFFF4B73A));
    }
    const meat = [
      (0.46, 0.40, 0.4),
      (0.53, 0.37, -0.5),
      (0.60, 0.42, 0.9),
      (0.50, 0.46, -0.2),
      (0.40, 0.45, 1.1),
    ];
    for (final (x, y, a) in meat) {
      _bar(c, Offset(x, y), 0.12, 0.045, a, const Color(0xFF7A3F22));
    }
    final onion = _stroke(const Color(0xFFC77BBE), 0.018);
    c
      ..drawArc(
        Rect.fromCenter(center: const Offset(0.45, 0.35), width: 0.10, height: 0.07),
        0.2,
        2.6,
        false,
        onion,
      )
      ..drawArc(
        Rect.fromCenter(center: const Offset(0.58, 0.47), width: 0.10, height: 0.07),
        3.4,
        2.6,
        false,
        onion,
      )
      ..drawCircle(const Offset(0.40, 0.36), 0.032, _fill(const Color(0xFFE34B32)))
      ..drawCircle(const Offset(0.55, 0.50), 0.028, _fill(const Color(0xFFE34B32)))
      ..drawCircle(const Offset(0.65, 0.40), 0.026, _fill(const Color(0xFFE34B32)));
    for (final (x, y, a) in const [(0.47, 0.30, -0.6), (0.53, 0.29, 0.5)]) {
      _bar(c, Offset(x, y), 0.07, 0.035, a, const Color(0xFF3E9A4F));
    }
  }

  void _bowl(Canvas c, Color wall, Color band, Color inner) {
    final rim = Rect.fromCenter(center: const Offset(0.5, 0.50), width: 0.76, height: 0.20);
    c.drawOval(rim, _fill(inner));
    final body = Path()
      ..moveTo(0.12, 0.50)
      ..arcTo(rim, math.pi, -math.pi, false)
      ..arcTo(
        Rect.fromCenter(center: const Offset(0.5, 0.50), width: 0.76, height: 0.76),
        0,
        math.pi,
        false,
      )
      ..close();
    c
      ..save()
      ..clipPath(body)
      ..drawRect(const Rect.fromLTWH(0, 0.50, 1, 0.5), _fill(wall))
      ..drawRect(const Rect.fromLTWH(0, 0.70, 1, 0.05), _fill(band))
      ..restore()
      ..drawPath(body, _stroke(Colors.black.withAlpha(24), 0.008));
  }

  void _bowlFront(Canvas c) {
    // Labio frontal para que el contenido parezca estar dentro del bowl.
    c.drawArc(
      Rect.fromCenter(center: const Offset(0.5, 0.50), width: 0.76, height: 0.20),
      0,
      math.pi,
      false,
      _stroke(Colors.white.withAlpha(200), 0.012),
    );
  }

  void _vegetariano(Canvas c) {
    _bowl(c, Colors.white, const Color(0xFF34B386), const Color(0xFFD9EDE3));
    const leaves = [
      (0.30, 0.44, 0.16, 0.10, -0.5, Color(0xFF58C46E)),
      (0.42, 0.38, 0.18, 0.10, 0.3, Color(0xFF3FA95A)),
      (0.56, 0.36, 0.18, 0.10, -0.2, Color(0xFF6ED084)),
      (0.68, 0.43, 0.16, 0.10, 0.6, Color(0xFF3FA95A)),
      (0.50, 0.46, 0.20, 0.10, 0.0, Color(0xFF58C46E)),
    ];
    for (final (x, y, w, h, a, color) in leaves) {
      c
        ..save()
        ..translate(x, y)
        ..rotate(a)
        ..drawOval(Rect.fromCenter(center: Offset.zero, width: w, height: h), _fill(color))
        ..restore();
    }
    c
      ..drawCircle(const Offset(0.36, 0.40), 0.065, _fill(const Color(0xFFE5483A)))
      ..drawCircle(const Offset(0.34, 0.38), 0.016, _fill(Colors.white.withAlpha(150)))
      ..drawCircle(const Offset(0.62, 0.39), 0.058, _fill(const Color(0xFFE5483A)))
      ..drawCircle(const Offset(0.60, 0.37), 0.014, _fill(Colors.white.withAlpha(150)))
      ..drawCircle(const Offset(0.50, 0.40), 0.040, _fill(const Color(0xFFF59A2B)))
      ..drawCircle(const Offset(0.50, 0.40), 0.016, _fill(const Color(0xFFFFD08A)))
      ..drawCircle(const Offset(0.70, 0.47), 0.032, _fill(const Color(0xFFF59A2B)));
    _bowlFront(c);
    // Hojas decorativas sobre el fondo.
    c
      ..drawCircle(const Offset(0.86, 0.14), 0.035, _fill(Colors.white.withAlpha(120)))
      ..drawCircle(const Offset(0.12, 0.22), 0.022, _fill(Colors.white.withAlpha(120)));
  }

  void _chifa(Canvas c) {
    _bowl(c, const Color(0xFFFFF4E0), const Color(0xFFE5483A), const Color(0xFF7B1B24));
    final noodle = _stroke(const Color(0xFFF7D26A), 0.024);
    for (var k = 0; k < 7; k++) {
      final x = 0.26 + 0.08 * k;
      c.drawPath(
        Path()
          ..moveTo(x, 0.52)
          ..cubicTo(x - 0.05, 0.40, x + 0.07, 0.36, x + 0.02, 0.26)
          ..cubicTo(x - 0.02, 0.20, x + 0.05, 0.18, x + 0.04, 0.16),
        noodle,
      );
    }
    for (final (x, y) in const [(0.40, 0.40), (0.56, 0.34), (0.66, 0.44), (0.48, 0.47)]) {
      c
        ..drawCircle(Offset(x, y), 0.026, _fill(const Color(0xFF7BCB4A)))
        ..drawCircle(Offset(x, y), 0.012, _fill(const Color(0xFFD7F3B5)));
    }
    _bowlFront(c);
    final stick = _stroke(const Color(0xFFD9A15C), 0.020);
    c
      ..drawLine(const Offset(0.80, 0.06), const Offset(0.52, 0.50), stick)
      ..drawLine(const Offset(0.90, 0.12), const Offset(0.60, 0.52), stick);
    final steam = _stroke(Colors.white.withAlpha(130), 0.016);
    for (final x in const [0.30, 0.40]) {
      c.drawPath(
        Path()
          ..moveTo(x, 0.20)
          ..cubicTo(x - 0.05, 0.14, x + 0.05, 0.09, x, 0.03),
        steam,
      );
    }
  }

  void _cloche(Canvas c) {
    c
      ..drawOval(
        Rect.fromCenter(center: const Offset(0.5, 0.74), width: 0.84, height: 0.12),
        _fill(const Color(0x33000000)),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(0.10, 0.66, 0.80, 0.07),
          const Radius.circular(0.035),
        ),
        _fill(const Color(0xFFE9EEF8)),
      )
      ..drawArc(
        Rect.fromCenter(center: const Offset(0.5, 0.66), width: 0.70, height: 0.70),
        math.pi,
        math.pi,
        true,
        _fill(const Color(0xFFF5F8FF)),
      )
      ..drawArc(
        Rect.fromCenter(center: const Offset(0.5, 0.66), width: 0.54, height: 0.54),
        math.pi * 1.1,
        math.pi * 0.5,
        false,
        _stroke(Colors.white, 0.03),
      )
      ..drawCircle(const Offset(0.5, 0.28), 0.045, _fill(const Color(0xFFE9EEF8)));
    for (final (x, y, r) in const [(0.86, 0.22, 0.05), (0.14, 0.40, 0.035), (0.80, 0.40, 0.025)]) {
      c
        ..drawLine(Offset(x - r, y), Offset(x + r, y), _stroke(Colors.white, 0.012))
        ..drawLine(Offset(x, y - r), Offset(x, y + r), _stroke(Colors.white, 0.012));
    }
  }

  @override
  bool shouldRepaint(covariant _FoodPainter oldDelegate) =>
      oldDelegate.category != category;
}
