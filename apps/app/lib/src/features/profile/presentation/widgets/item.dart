import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Item extends ConsumerWidget {
  const Item({
    super.key,
    required this.text,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String text;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 16)],
              Text(text, style: theme.textTheme.bodyLarge),
              const Spacer(),
              trailing ?? const FaIcon(FontAwesomeIcons.chevronRight),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemSection extends StatelessWidget {
  const ItemSection({super.key, required this.section});

  final Map<String, Object> section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemsData = section['children'] as List<Map<String, Object>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['title'] as String,
          style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        for (final itemData in itemsData)
          Item(
            text: itemData['title'] as String,
            leading: itemData['leading'] as Widget?,
            trailing: itemData['trailing'] as Widget?,
            onTap: itemData['onTap'] as VoidCallback?,
          ),
      ],
    );
  }
}
