import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../theme/app_theme.dart';
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
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.restaurant,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${menu.area} · ${menu.walkMinutes} min a pie · ${menu.category}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'S/ ${menu.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatusBadge(status: menu.availability),
            const SizedBox(height: 14),
            Text('PLATOS DE FONDO', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(menu.mainDishes.join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: const Text('Ver menu'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onReport,
                    icon: const Icon(Icons.campaign_outlined, size: 18),
                    label: const Text('Avisar stock'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
