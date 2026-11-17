import 'package:flutter/material.dart';

class FluidSegmentedControl<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T> onSelectedItemChanged;
  final String Function(T item) labelBuilder;
  final IconData? Function(T item)? iconBuilder;
  final EdgeInsetsGeometry padding;

  const FluidSegmentedControl({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelectedItemChanged,
    required this.labelBuilder,
    this.iconBuilder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final selected = items.where((item) => item == selectedItem).toSet();

    return Padding(
      padding: padding,
      child: SegmentedButton<T>(
        segments: items.map(_buildSegment).toList(growable: false),
        selected: selected,
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onSelectedItemChanged(selection.first);
          }
        },
      ),
    );
  }

  ButtonSegment<T> _buildSegment(T item) {
    final icon = iconBuilder?.call(item);
    return ButtonSegment<T>(
      value: item,
      label: Text(labelBuilder(item)),
      icon: icon == null ? null : Icon(icon),
    );
  }
}
