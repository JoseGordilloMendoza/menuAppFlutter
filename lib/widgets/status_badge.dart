import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../theme/app_theme.dart';

Color availabilityColor(MenuAvailability status) => switch (status) {
  MenuAvailability.available => AppColors.green,
  MenuAvailability.limited => AppColors.amber,
  MenuAvailability.soldOut => AppColors.red,
};

IconData availabilityIcon(MenuAvailability status) => switch (status) {
  MenuAvailability.available => Icons.check_circle_outline,
  MenuAvailability.limited => Icons.warning_amber_rounded,
  MenuAvailability.soldOut => Icons.cancel_outlined,
};

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.solid = false});

  final MenuAvailability status;

  /// Fondo blanco con sombra, para colocarlo sobre imágenes.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final color = availabilityColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: solid ? Colors.white : color.withAlpha(22),
        borderRadius: BorderRadius.circular(100),
        boxShadow: solid
            ? const [BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2))]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(availabilityIcon(status), size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
