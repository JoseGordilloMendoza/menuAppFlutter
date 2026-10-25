import 'package:flutter/foundation.dart';

import '../models/menu.dart';

class MenuStore extends ChangeNotifier {
  final List<CampusMenu> _menus = [
    const CampusMenu(
      id: '1',
      restaurant: 'La Tía Rosa',
      price: 9.50,
      walkMinutes: 2,
      area: 'Puerta 3',
      category: 'Criollo',
      starters: ['Papa a la huancaína', 'Sopa del día'],
      mainDishes: ['Lomo saltado', 'Ají de gallina'],
      drink: 'Chicha morada',
      availability: MenuAvailability.available,
      positionX: 0.30,
      positionY: 0.32,
    ),
    const CampusMenu(
      id: '2',
      restaurant: 'Sazón de Casa',
      price: 11,
      walkMinutes: 4,
      area: 'Av. Independencia',
      category: 'Vegetariano',
      starters: ['Ensalada fresca'],
      mainDishes: ['Tallarines verdes', 'Guiso de lentejas'],
      drink: 'Limonada',
      availability: MenuAvailability.limited,
      positionX: 0.66,
      positionY: 0.28,
    ),
    const CampusMenu(
      id: '3',
      restaurant: 'Chifa Campus',
      price: 12,
      walkMinutes: 5,
      area: 'Puerta 1',
      category: 'Chifa',
      starters: ['Sopa wantan'],
      mainDishes: ['Arroz chaufa', 'Tallarín saltado'],
      drink: 'Refresco del día',
      availability: MenuAvailability.available,
      positionX: 0.18,
      positionY: 0.68,
    ),
    const CampusMenu(
      id: '4',
      restaurant: 'El Buen Sabor',
      price: 10,
      walkMinutes: 3,
      area: 'Puerta 3',
      category: 'Criollo',
      starters: ['Caldo de verduras'],
      mainDishes: ['Pollo al horno', 'Seco de res'],
      drink: 'Emoliente',
      availability: MenuAvailability.soldOut,
      positionX: 0.77,
      positionY: 0.62,
    ),
  ];

  final List<CommunityNotice> _notices = [
    CommunityNotice(
      author: 'Valeria R.',
      restaurant: 'Sazón de Casa',
      category: 'Vegetariano',
      message: 'Quedan pocas raciones.',
      availability: MenuAvailability.limited,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    CommunityNotice(
      author: 'Carlos M.',
      restaurant: 'El Buen Sabor',
      category: 'Criollo',
      message: 'Se agotó por hoy.',
      availability: MenuAvailability.soldOut,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
  ];

  List<CampusMenu> get menus => List.unmodifiable(_menus);
  List<CommunityNotice> get notices => List.unmodifiable(_notices);
  int get availableCount => _menus
      .where((menu) => menu.availability != MenuAvailability.soldOut)
      .length;

  CampusMenu findMenu(String id) => _menus.firstWhere((menu) => menu.id == id);

  void updateAvailability(String id, MenuAvailability availability) {
    final index = _menus.indexWhere((menu) => menu.id == id);
    if (index < 0 || _menus[index].availability == availability) return;
    final current = _menus[index];
    _menus[index] = current.copyWith(availability: availability);
    _notices.insert(
      0,
      CommunityNotice(
        author: 'Tú',
        restaurant: current.restaurant,
        category: current.category,
        message: availability.noticeText,
        availability: availability,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addMenu(CampusMenu menu) {
    _menus.insert(0, menu);
    _notices.insert(
      0,
      CommunityNotice(
        author: 'Tú',
        restaurant: menu.restaurant,
        category: menu.category,
        message: 'Publicó un menú por S/ ${menu.price.toStringAsFixed(2)}.',
        availability: menu.availability,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
