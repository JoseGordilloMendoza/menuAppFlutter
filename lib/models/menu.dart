enum MenuAvailability { available, limited, soldOut }

extension MenuAvailabilityLabel on MenuAvailability {
  String get label => switch (this) {
    MenuAvailability.available => 'Disponible',
    MenuAvailability.limited => 'Últimas raciones',
    MenuAvailability.soldOut => 'Agotado',
  };
}

class CampusMenu {
  const CampusMenu({
    required this.id,
    required this.restaurant,
    required this.price,
    required this.walkMinutes,
    required this.area,
    required this.category,
    required this.starters,
    required this.mainDishes,
    required this.drink,
    required this.availability,
    required this.positionX,
    required this.positionY,
  });

  final String id;
  final String restaurant;
  final double price;
  final int walkMinutes;
  final String area;
  final String category;
  final List<String> starters;
  final List<String> mainDishes;
  final String drink;
  final MenuAvailability availability;
  final double positionX;
  final double positionY;

  CampusMenu copyWith({MenuAvailability? availability}) => CampusMenu(
    id: id,
    restaurant: restaurant,
    price: price,
    walkMinutes: walkMinutes,
    area: area,
    category: category,
    starters: starters,
    mainDishes: mainDishes,
    drink: drink,
    availability: availability ?? this.availability,
    positionX: positionX,
    positionY: positionY,
  );
}

class CommunityNotice {
  const CommunityNotice({
    required this.author,
    required this.message,
    required this.availability,
    required this.createdAt,
  });

  final String author;
  final String message;
  final MenuAvailability availability;
  final DateTime createdAt;
}
