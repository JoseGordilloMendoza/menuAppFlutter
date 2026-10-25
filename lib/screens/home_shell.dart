import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../widgets/availability_sheet.dart';
import '../widgets/notice_composer.dart';
import 'community_tab.dart';
import 'explore_tab.dart';
import 'menu_detail_page.dart';
import 'publish_menu_page.dart';
import 'radar_tab.dart';

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

  Future<void> _newNotice() async {
    final published = await showNoticeComposer(context, widget.store);
    if (!published || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aviso publicado en esta sesión.')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    // Comunidad dibuja su cabecera hasta el borde superior de la pantalla,
    // por eso allí la barra de estado lleva íconos claros.
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: (_selectedIndex == 2
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: SafeArea(
        top: _selectedIndex != 2,
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
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _selectedIndex == 2 ? _newNotice : _publishMenu,
      icon: Icon(_selectedIndex == 2 ? Icons.edit_note_rounded : Icons.add_rounded),
      label: Text(_selectedIndex == 2 ? 'Nuevo aviso' : 'Publicar menú'),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: 'Menús',
        ),
        NavigationDestination(
          icon: Icon(Icons.radar_outlined),
          selectedIcon: Icon(Icons.radar),
          label: 'Radar',
        ),
        NavigationDestination(
          icon: Icon(Icons.forum_outlined),
          selectedIcon: Icon(Icons.forum),
          label: 'Comunidad',
        ),
      ],
    ),
  );
}
