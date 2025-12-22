import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketa/src/features/account/models/types.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
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
  Widget build(BuildContext context) {
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
          padding: const .symmetric(vertical: 16, horizontal: 8),
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

class ProfileItemsSection extends StatelessWidget {
  const ProfileItemsSection({super.key, required this.section});

  final ({String title, List<ProfileSection> children}) section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          section.title,
          style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        for (final itemData in section.children)
          ProfileItem(
            text: itemData.title,
            leading: itemData.leading,
            trailing: itemData.trailing,
            onTap: itemData.onTap,
          ),
      ],
    );
  }
}
