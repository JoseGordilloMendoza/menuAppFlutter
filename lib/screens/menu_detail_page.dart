import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../theme/app_theme.dart';
import '../widgets/availability_sheet.dart';
import '../widgets/food_art.dart';
import '../widgets/status_badge.dart';

class MenuDetailPage extends StatelessWidget {
  const MenuDetailPage({super.key, required this.store, required this.menuId});

  final MenuStore store;
  final String menuId;

  static const double _expandedHeight = 280;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final menu = store.findMenu(menuId);
      final style = categoryStyle(menu.category);
      final top = MediaQuery.paddingOf(context).top;
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: _expandedHeight,
              backgroundColor: style.bottom,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.all(6),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(70),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final collapsed = kToolbarHeight + top;
                  final t = ((constraints.maxHeight - collapsed) /
                          (_expandedHeight + top - collapsed))
                      .clamp(0.0, 1.0);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'banner-${menu.id}',
                        child: FoodBanner(category: menu.category),
                      ),
                      Positioned(
                        top: top + 15,
                        left: 64,
                        right: 16,
                        child: Opacity(
                          opacity: 1 - t,
                          child: Text(
                            menu.restaurant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.display(22, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -1,
                        child: Container(
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.restaurant,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.navy,
                        fontSize: 34,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'S/ ${menu.price.toStringAsFixed(2)}',
                          style: AppText.display(36, color: AppColors.orange),
                        ),
                        const SizedBox(width: 12),
                        StatusBadge(status: menu.availability),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: Icons.directions_walk_rounded,
                            value: '${menu.walkMinutes} min',
                            label: 'a pie',
                            color: style.top,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.place_rounded,
                            value: menu.area,
                            label: 'referencia',
                            color: style.top,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatTile(
                            icon: categoryIcon(menu.category),
                            value: menu.category,
                            label: 'cocina',
                            color: style.top,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            _CourseRow(
                              icon: Icons.soup_kitchen_rounded,
                              title: 'Entrada',
                              items: menu.starters,
                              color: style.top,
                            ),
                            const _Divider(),
                            _CourseRow(
                              icon: Icons.restaurant_rounded,
                              title: 'Plato de fondo',
                              items: menu.mainDishes,
                              color: style.top,
                            ),
                            const _Divider(),
                            _CourseRow(
                              icon: Icons.local_drink_rounded,
                              title: 'Bebida',
                              items: [menu.drink],
                              color: style.top,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: Colors.black45),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Confirma precio y stock en el local.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: () => reportAvailability(context, store, menu),
            icon: const Icon(Icons.campaign_rounded),
            label: const Text('Avisar disponibilidad'),
          ),
        ),
      );
    },
  );
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    decoration: BoxDecoration(
      color: color.withAlpha(30),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({
    required this.icon,
    required this.title,
    required this.items,
    required this.color,
  });

  final IconData icon;
  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: color.withAlpha(32),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Divider(height: 1),
  );
}
