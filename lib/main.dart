import 'package:flutter/material.dart';

import 'data/menu_store.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MenuRadarApp());

class MenuRadarApp extends StatefulWidget {
  const MenuRadarApp({super.key});

  @override
  State<MenuRadarApp> createState() => _MenuRadarAppState();
}

class _MenuRadarAppState extends State<MenuRadarApp> {
  final MenuStore _store = MenuStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MenúRadar',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: HomeShell(store: _store),
  );
}
