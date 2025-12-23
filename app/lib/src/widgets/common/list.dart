import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class CommonList<T> extends StatelessWidget {
  const CommonList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding = .zero,
    this.separatorBox = const SizedBox(height: 12),
    this.scrollDirection = .vertical,
    this.emptyText = 'No items available',
    this.shrinkWrap = false,
  });

  final IList<T> items;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final EdgeInsetsGeometry padding;
  final SizedBox separatorBox;
  final Axis scrollDirection;
  final String emptyText;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Center(
            child: Text(
              emptyText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        : ListView.separated(
            itemBuilder: (ctx, i) => itemBuilder(ctx, i, items[i]),
            separatorBuilder: (ctx, i) => separatorBox,
            itemCount: items.length,
            padding: padding,
            scrollDirection: scrollDirection,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: shrinkWrap,
          );
  }
}
