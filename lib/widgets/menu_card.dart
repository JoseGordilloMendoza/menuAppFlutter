import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../theme/app_theme.dart';
import 'food_art.dart';
import 'status_badge.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.menu,
    required this.onOpen,
    required this.onReport,
  });

  final CampusMenu menu;
  final VoidCallback onOpen;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(menu.category);
    final soldOut = menu.availability == MenuAvailability.soldOut;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'banner-${menu.id}',
                  child: FoodBanner(category: menu.category, height: 156),
                ),
                if (soldOut) const Positioned.fill(child: _SoldOutVeil()),
                Positioned(
                  top: 12,
                  left: 12,
                  child: StatusBadge(status: menu.availability, solid: true),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Text(
                    'S/ ${menu.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: Color(0x55000000), blurRadius: 8)],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          menu.restaurant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Avisar stock',
                        onPressed: onReport,
                        icon: const Icon(Icons.campaign_rounded),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      children: [
                        _Meta(icon: Icons.directions_walk_rounded, text: '${menu.walkMinutes} min'),
                        _Meta(icon: Icons.place_outlined, text: menu.area),
                        _Meta(icon: categoryIcon(menu.category), text: menu.category),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final dish in menu.mainDishes)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: style.top.withAlpha(30),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              dish,
                              style: TextStyle(
                                color: style.bottom,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: Colors.black54),
      const SizedBox(width: 4),
      Text(text, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _SoldOutVeil extends StatelessWidget {
  const _SoldOutVeil();

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black.withAlpha(110),
    alignment: Alignment.center,
    child: Transform.rotate(
      angle: -0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'AGOTADO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
      ),
    ),
  );
}
