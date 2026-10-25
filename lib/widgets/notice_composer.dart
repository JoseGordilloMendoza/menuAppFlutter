import 'package:flutter/material.dart';

import '../data/menu_store.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import 'food_art.dart';
import 'status_badge.dart';

/// Abre la hoja para publicar un aviso en Comunidad. Devuelve `true` si se
/// publicó.
Future<bool> showNoticeComposer(BuildContext context, MenuStore store) async {
  final published = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _NoticeComposer(store: store),
  );
  return published ?? false;
}

class _NoticeComposer extends StatefulWidget {
  const _NoticeComposer({required this.store});

  final MenuStore store;

  @override
  State<_NoticeComposer> createState() => _NoticeComposerState();
}

class _NoticeComposerState extends State<_NoticeComposer> {
  final _formKey = GlobalKey<FormState>();
  final _alias = TextEditingController();
  final _comment = TextEditingController();
  String? _menuId;
  MenuAvailability _status = MenuAvailability.limited;
  bool _missingMenu = false;

  bool get _needsAlias => widget.store.alias == null;

  @override
  void dispose() {
    _alias.dispose();
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    setState(() => _missingMenu = _menuId == null);
    if (!valid || _menuId == null) return;
    if (_needsAlias) widget.store.setAlias(_alias.text);
    widget.store.updateAvailability(_menuId!, _status, comment: _comment.text);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final menus = widget.store.menus;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nuevo aviso', style: AppText.display(28)),
                const SizedBox(height: 4),
                Text(
                  'Cuéntale a otros qué viste en el local.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                if (_needsAlias) ...[
                  TextFormField(
                    controller: _alias,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      labelText: 'Tu apodo',
                      hintText: 'Ej. Valeria R.',
                      prefixIcon: Icon(Icons.badge_outlined),
                      helperText: 'Sin cuenta ni correo: solo se muestra el apodo.',
                    ),
                    validator: (value) => (value ?? '').trim().length < 2
                        ? 'Usa al menos 2 letras.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
                const _Label(icon: Icons.storefront_rounded, text: '¿Dónde?'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final menu in menus)
                      ChoiceChip(
                        avatar: Icon(categoryIcon(menu.category), size: 18),
                        label: Text(menu.restaurant),
                        showCheckmark: false,
                        selected: _menuId == menu.id,
                        onSelected: (_) => setState(() {
                          _menuId = menu.id;
                          _missingMenu = false;
                        }),
                      ),
                  ],
                ),
                if (_missingMenu)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Elige un local.',
                      style: TextStyle(color: AppColors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 18),
                const _Label(icon: Icons.restaurant_rounded, text: '¿Cómo está?'),
                const SizedBox(height: 8),
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
                        selected: {_status},
                        onSelectionChanged: (values) =>
                            setState(() => _status = values.first),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _comment,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Comentario (opcional)',
                    hintText: 'Ej. Ya no hay lomo, solo ají de gallina',
                    prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Publicar aviso'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: AppColors.orange),
      const SizedBox(width: 8),
      Text(text, style: AppText.display(18)),
    ],
  );
}
