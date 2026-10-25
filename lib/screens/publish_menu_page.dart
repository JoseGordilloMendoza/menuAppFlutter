import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';

class PublishMenuPage extends StatefulWidget {
  const PublishMenuPage({super.key, required this.store});

  final MenuStore store;

  @override
  State<PublishMenuPage> createState() => _PublishMenuPageState();
}

class _PublishMenuPageState extends State<PublishMenuPage> {
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    final walk = int.parse(_walk.text.trim());
    final id = DateTime.now().microsecondsSinceEpoch.toString();
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
        positionX: 0.45,
        positionY: 0.72,
      ),
    );
    Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Publicar menú')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Comparte un menú',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Ayuda a otros estudiantes a elegir antes de salir del campus.'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _restaurant,
              decoration: const InputDecoration(labelText: 'Restaurante o huarique'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    decoration: const InputDecoration(labelText: 'Precio S/'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
                      return parsed == null || parsed <= 0
                          ? 'Ingresa un precio válido.'
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _walk,
                    decoration: const InputDecoration(labelText: 'Minutos a pie'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsed = int.tryParse((value ?? '').trim());
                      return parsed == null || parsed < 1 || parsed > 60
                          ? 'Usa entre 1 y 60.'
                          : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _area,
              decoration: const InputDecoration(labelText: 'Referencia cercana'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Tipo de cocina'),
              items: ['Criollo', 'Vegetariano', 'Chifa', 'Otro']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _category = value ?? 'Criollo'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _starter,
              decoration: const InputDecoration(labelText: 'Entrada'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dish,
              decoration: const InputDecoration(labelText: 'Plato de fondo'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _drink,
              decoration: const InputDecoration(labelText: 'Bebida'),
              validator: _required,
            ),
            const SizedBox(height: 20),
            Text('Disponibilidad observada', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<MenuAvailability>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: MenuAvailability.available, label: Text('Disponible')),
                ButtonSegment(value: MenuAvailability.limited, label: Text('Pocas')),
                ButtonSegment(value: MenuAvailability.soldOut, label: Text('Agotado')),
              ],
              selected: {_availability},
              onSelectionChanged: (values) => setState(() => _availability = values.first),
            ),
            const SizedBox(height: 18),
            const Text(
              'Prototipo académico: los datos publicados no se sincronizan con otros dispositivos.',
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.publish_rounded),
              label: const Text('Publicar menú'),
            ),
          ],
        ),
      ),
    ),
  );
}
