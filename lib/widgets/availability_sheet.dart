import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import 'status_badge.dart';

Future<void> reportAvailability(
  BuildContext context,
  MenuStore store,
  CampusMenu menu,
) async {
  final selected = await showModalBottomSheet<MenuAvailability>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disponibilidad de ${menu.restaurant}',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Selecciona el estado que observaste en el local.'),
            const SizedBox(height: 16),
            for (final status in MenuAvailability.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(availabilityIcon(status), color: availabilityColor(status)),
                title: Text(status.label),
                trailing: menu.availability == status
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.pop(sheetContext, status),
              ),
            const SizedBox(height: 6),
            Text(
              'Prototipo: el cambio se guarda solo mientras la app está abierta.',
              style: Theme.of(sheetContext).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
  if (selected == null || !context.mounted) return;
  store.updateAvailability(menu.id, selected);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Disponibilidad actualizada en esta sesión.')),
  );
}
