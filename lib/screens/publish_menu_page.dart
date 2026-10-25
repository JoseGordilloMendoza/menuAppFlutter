import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/food_art.dart';
import '../widgets/status_badge.dart';

class PublishMenuPage extends StatefulWidget {
  const PublishMenuPage({super.key, required this.store});

  final MenuStore store;

  @override
  State<PublishMenuPage> createState() => _PublishMenuPageState();
}

class _PublishMenuPageState extends State<PublishMenuPage> {
  static const _categories = ['Criollo', 'Vegetariano', 'Chifa', 'Otro'];

  final _formKey = GlobalKey<FormState>();
  final _restaurant = TextEditingController();
  final _price = TextEditingController();
  final _walk = TextEditingController();
  final _area = TextEditingController();
  final _starter = TextEditingController();
  final _dish = TextEditingController();
  final _drink = TextEditingController();
  String _category = 'Criollo';
  MenuAvailability _availability = MenuAvailability.available;

  @override
  void dispose() {
    for (final controller in [
      _restaurant, _price, _walk, _area, _starter, _dish, _drink,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? 'Completa este campo.'
      : null;

  /// Elige el ángulo del radar más alejado de los pines que ya existen, para
  /// que un menú nuevo no se encime con otro.
  double _freeAngle(int walk) {
    final mine = radarFraction(walk);
    final taken = [
      for (final menu in widget.store.menus)
        Offset.fromDirection(
          math.atan2(menu.positionY - 0.5, menu.positionX - 0.5),
          radarFraction(menu.walkMinutes),
        ),
    ];
    var best = 0.0;
    var bestGap = -1.0;
    for (var k = 0; k < 24; k++) {
      final angle = k * math.pi / 12;
      final point = Offset.fromDirection(angle, mine);
      final gap = taken.isEmpty
          ? 1.0
          : taken.map((other) => (other - point).distance).reduce(math.min);
      if (gap > bestGap) {
        best = angle;
        bestGap = gap;
      }
    }
    return best;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    final walk = int.parse(_walk.text.trim());
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final angle = _freeAngle(walk);
    widget.store.addMenu(
      CampusMenu(
        id: id,
        restaurant: _restaurant.text.trim(),
        price: price,
        walkMinutes: walk,
        area: _area.text.trim(),
        category: _category,
        starters: [_starter.text.trim()],
        mainDishes: [_dish.text.trim()],
        drink: _drink.text.trim(),
        availability: _availability,
        positionX: 0.5 + 0.35 * math.cos(angle),
        positionY: 0.5 + 0.35 * math.sin(angle),
      ),
    );
    Navigator.pop(context, id);
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? prefixText,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool last = false,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    textInputAction: last ? TextInputAction.done : TextInputAction.next,
    textCapitalization: keyboardType == null
        ? TextCapitalization.sentences
        : TextCapitalization.none,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      prefixText: prefixText,
      suffixText: suffixText,
    ),
    validator: validator ?? _required,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Publicar menú')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            _Preview(
              category: _category,
              restaurant: _restaurant,
              price: _price,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ChoiceChip(
                    avatar: Icon(categoryIcon(category), size: 18),
                    label: Text(category),
                    showCheckmark: false,
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              number: 1,
              title: 'El local',
              children: [
                _field(
                  controller: _restaurant,
                  label: 'Nombre del local',
                  hint: 'Ej. La Tía Rosa',
                  icon: Icons.storefront_rounded,
                ),
                _field(
                  controller: _area,
                  label: 'Referencia cercana',
                  hint: 'Ej. Puerta 3',
                  icon: Icons.place_outlined,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        controller: _walk,
                        label: 'A pie',
                        icon: Icons.directions_walk_rounded,
                        suffixText: 'min',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final parsed = int.tryParse((value ?? '').trim());
                          return parsed == null || parsed < 1 || parsed > 60
                              ? '1 a 60.'
                              : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        controller: _price,
                        label: 'Precio',
                        icon: Icons.payments_outlined,
                        prefixText: 'S/ ',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          final parsed = double.tryParse(
                            (value ?? '').trim().replaceAll(',', '.'),
                          );
                          return parsed == null || parsed <= 0 ? 'Precio inválido.' : null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            _Section(
              number: 2,
              title: 'El menú de hoy',
              children: [
                _field(
                  controller: _starter,
                  label: 'Entrada',
                  hint: 'Ej. Sopa del día',
                  icon: Icons.soup_kitchen_rounded,
                ),
                _field(
                  controller: _dish,
                  label: 'Plato de fondo',
                  hint: 'Ej. Lomo saltado',
                  icon: Icons.restaurant_rounded,
                ),
                _field(
                  controller: _drink,
                  label: 'Bebida',
                  hint: 'Ej. Chicha morada',
                  icon: Icons.local_drink_rounded,
                  last: true,
                ),
              ],
            ),
            const SizedBox(height: 22),
            _Section(
              number: 3,
              title: '¿Cuánto queda?',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<MenuAvailability>(
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        segments: [
                          for (final (status, label) in const [
                            (MenuAvailability.available, 'Hay'),
                            (MenuAvailability.limited, 'Pocas'),
                            (MenuAvailability.soldOut, 'Agotado'),
                          ])
                            ButtonSegment(
                              value: status,
                              icon: Icon(availabilityIcon(status), size: 18),
                              label: Text(label),
                            ),
                        ],
                        selected: {_availability},
                        onSelectionChanged: (values) =>
                            setState(() => _availability = values.first),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.publish_rounded),
              label: const Text('Publicar menú'),
            ),
            const SizedBox(height: 10),
            Text(
              'Se guarda solo mientras la app está abierta.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}

/// Vista previa en vivo del banner que verán los demás estudiantes.
class _Preview extends StatelessWidget {
  const _Preview({
    required this.category,
    required this.restaurant,
    required this.price,
  });

  final String category;
  final TextEditingController restaurant;
  final TextEditingController price;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    child: FoodBanner(
      category: category,
      radius: BorderRadius.circular(28),
      child: ListenableBuilder(
        listenable: Listenable.merge([restaurant, price]),
        builder: (context, _) {
          final name = restaurant.text.trim();
          final value = price.text.trim();
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Así se verá',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value.isEmpty ? 'S/ --' : 'S/ $value',
                  style: AppText.display(34, color: Colors.white),
                ),
                SizedBox(
                  width: 190,
                  child: Text(
                    name.isEmpty ? 'Tu local' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.display(18, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.number,
    required this.title,
    required this.children,
  });

  final int number;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
            child: Text('$number', style: AppText.display(16, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Text(title, style: AppText.display(22)),
        ],
      ),
      const SizedBox(height: 14),
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) const SizedBox(height: 12),
        children[i],
      ],
    ],
  );
}
