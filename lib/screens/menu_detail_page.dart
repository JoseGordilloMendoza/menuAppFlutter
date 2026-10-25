import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../theme/app_theme.dart';
import '../widgets/availability_sheet.dart';
import '../widgets/status_badge.dart';

class MenuDetailPage extends StatelessWidget {
  const MenuDetailPage({super.key, required this.store, required this.menuId});

  final MenuStore store;
  final String menuId;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final menu = store.findMenu(menuId);
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del menú')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            children: [
              Text(
                menu.restaurant,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text('${menu.area} · ${menu.walkMinutes} min a pie · ${menu.category}'),
              const SizedBox(height: 16),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(
                    'S/ ${menu.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                  StatusBadge(status: menu.availability),
                ],
              ),
              const SizedBox(height: 24),
              _DetailSection(title: 'Entradas', icon: Icons.soup_kitchen_outlined, items: menu.starters),
              const SizedBox(height: 12),
              _DetailSection(title: 'Platos de fondo', icon: Icons.restaurant_outlined, items: menu.mainDishes),
              const SizedBox(height: 12),
              _DetailSection(title: 'Bebida', icon: Icons.local_drink_outlined, items: [menu.drink]),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Información de demostración. Confirma precio y disponibilidad en el local antes de desplazarte.',
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: () => reportAvailability(context, store, menu),
            icon: const Icon(Icons.campaign_outlined),
            label: const Text('Avisar disponibilidad'),
          ),
        ),
      );
    },
  );
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.orange),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text('• $item'),
            ),
        ],
      ),
    ),
  );
}
