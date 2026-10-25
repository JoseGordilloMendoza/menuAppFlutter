import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/availability_sheet.dart';
import '../widgets/menu_card.dart';
import '../widgets/status_badge.dart';
import 'menu_detail_page.dart';
import 'publish_menu_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.store});

  final MenuStore store;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  Future<void> _openMenu(CampusMenu menu) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MenuDetailPage(store: widget.store, menuId: menu.id),
      ),
    );
  }

  Future<void> _publishMenu() async {
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => PublishMenuPage(store: widget.store)),
    );
    if (id == null || !mounted) return;
    setState(() => _selectedIndex = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menú publicado en esta sesión.')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          ExploreTab(
            store: widget.store,
            onOpen: _openMenu,
            onReport: (menu) => reportAvailability(context, widget.store, menu),
          ),
          RadarTab(store: widget.store, onOpen: _openMenu),
          CommunityTab(store: widget.store),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _publishMenu,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Publicar menú'),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menús'),
        NavigationDestination(icon: Icon(Icons.radar), label: 'Radar'),
        NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Comunidad'),
      ],
    ),
  );
}

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
  static const _filters = ['Todos', 'Hasta S/ 10', 'S/ 11–14', 'Vegetariano'];

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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.ramen_dining, color: AppColors.orange, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'MenúRadar',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Encuentra tu almuerzo cerca del campus.'),
                const SizedBox(height: 16),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar local o plato',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${widget.store.availableCount} menús con disponibilidad · Datos de demostración',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
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
              itemBuilder: (context, index) => FilterChip(
                label: Text(_filters[index]),
                selected: _filter == _filters[index],
                onSelected: (_) => setState(() => _filter = _filters[index]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: menus.isEmpty
                ? const Center(child: Text('No hay menús para esta búsqueda.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: menus.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
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

class RadarTab extends StatelessWidget {
  const RadarTab({super.key, required this.store, required this.onOpen});

  final MenuStore store;
  final ValueChanged<CampusMenu> onOpen;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Radar de menús',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Vista referencial de locales cercanos al campus.'),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _RadarPainter())),
                    Positioned(
                      left: constraints.maxWidth / 2 - 24,
                      top: constraints.maxHeight / 2 - 24,
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.orange,
                        child: Icon(Icons.school, color: Colors.white),
                      ),
                    ),
                    for (final menu in store.menus)
                      Positioned(
                        left: (constraints.maxWidth * menu.positionX - 28)
                            .clamp(2.0, math.max(2.0, constraints.maxWidth - 58))
                            .toDouble(),
                        top: (constraints.maxHeight * menu.positionY - 28)
                            .clamp(2.0, math.max(2.0, constraints.maxHeight - 58))
                            .toDouble(),
                        child: Semantics(
                          label: '${menu.restaurant}, S/ ${menu.price.toStringAsFixed(2)}, ${menu.availability.label}',
                          button: true,
                          child: InkWell(
                            onTap: () => onOpen(menu),
                            borderRadius: BorderRadius.circular(30),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: availabilityColor(menu.availability),
                              child: Text(
                                'S/ ${menu.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final status in MenuAvailability.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: availabilityColor(status)),
                    const SizedBox(width: 5),
                    Text(status.label, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Las posiciones son ilustrativas; este prototipo no usa GPS.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.navy,
    );
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.47;
    final ringPaint = Paint()
      ..color = const Color(0xFF526379)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 3, ringPaint);
    }
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      ringPaint,
    );
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key, required this.store});

  final MenuStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
      children: [
        Text(
          'Comunidad',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Avisos compartidos para evitar viajes innecesarios.'),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Los avisos iniciales son ejemplos. Los nuevos reportes solo se conservan durante esta sesión.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (final notice in store.notices) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notice.author,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      StatusBadge(status: notice.availability),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(notice.message),
                  const SizedBox(height: 6),
                  Text(
                    _timeLabel(notice.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    ),
  );

  String _timeLabel(DateTime time) {
    final minutes = DateTime.now().difference(time).inMinutes;
    if (minutes < 1) return 'Ahora';
    if (minutes < 60) return 'Hace $minutes min';
    return 'Hace ${minutes ~/ 60} h';
  }
}
