import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_card.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({
    super.key,
    required this.store,
    required this.onOpen,
    required this.onReport,
  });

  final MenuStore store;
  final ValueChanged<CampusMenu> onOpen;
  final ValueChanged<CampusMenu> onReport;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final TextEditingController _search = TextEditingController();
  String _filter = 'Todos';

  static const _filters = [
    ('Todos', Icons.apps_rounded),
    ('Hasta S/ 10', Icons.savings_outlined),
    ('S/ 11–14', Icons.payments_outlined),
    ('Vegetariano', Icons.eco_outlined),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(CampusMenu menu) {
    final query = _search.text.trim().toLowerCase();
    final text = [
      menu.restaurant,
      menu.category,
      ...menu.starters,
      ...menu.mainDishes,
    ].join(' ').toLowerCase();
    if (query.isNotEmpty && !text.contains(query)) return false;
    return switch (_filter) {
      'Hasta S/ 10' => menu.price <= 10,
      'S/ 11–14' => menu.price >= 11 && menu.price <= 14,
      'Vegetariano' => menu.category == 'Vegetariano',
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final menus = widget.store.menus.where(_matches).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.ramen_dining_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MenúRadar',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.navy,
                              fontSize: 28,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            '¿Dónde almuerzas hoy?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    _AvailablePill(count: widget.store.availableCount),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar local o plato',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final (label, icon) = _filters[index];
                return FilterChip(
                  avatar: Icon(icon, size: 18),
                  label: Text(label),
                  showCheckmark: false,
                  selected: _filter == label,
                  onSelected: (_) => setState(() => _filter = label),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: menus.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: menus.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => MenuCard(
                      menu: menus[index],
                      onOpen: () => widget.onOpen(menus[index]),
                      onReport: () => widget.onReport(menus[index]),
                    ),
                  ),
          ),
        ],
      );
    },
  );
}

/// Indicador de menús libres: un punto que late como un eco de radar junto al
/// número, en la tipografía de titulares.
class _AvailablePill extends StatefulWidget {
  const _AvailablePill({required this.count});

  final int count;

  @override
  State<_AvailablePill> createState() => _AvailablePillState();
}

class _AvailablePillState extends State<_AvailablePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 6, 14, 6),
    decoration: BoxDecoration(
      color: AppColors.navy,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
        bottomRight: Radius.circular(22),
        bottomLeft: Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.navy.withAlpha(60),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: CustomPaint(painter: _EchoPainter(_pulse)),
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.count}',
          style: AppText.display(28, color: AppColors.sun, height: 1),
        ),
        const SizedBox(width: 6),
        const Text(
          'menús\nlibres',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            height: 1.15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _EchoPainter extends CustomPainter {
  _EchoPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    const dot = Color(0xFF3DDC97);
    final center = size.center(Offset.zero);
    final t = animation.value;
    canvas
      ..drawCircle(
        center,
        4 + t * 10,
        Paint()
          ..color = dot.withAlpha(((1 - t) * 180).round())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      )
      ..drawCircle(center, 4.5, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(covariant _EchoPainter oldDelegate) => false;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.search_off_rounded, size: 56, color: Colors.black26),
        SizedBox(height: 8),
        Text('Sin resultados'),
      ],
    ),
  );
}
