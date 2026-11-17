import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fynza/shared/widgets/fading_scroll_boundary.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/category_icon.dart';
import '../../../../shared/widgets/fluid_segmented_control.dart';

class CategoryFormData {
  final String name;
  final String icon;
  final int color;
  final bool isIncome;

  const CategoryFormData({
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
  });
}

class CategoryFormScreen extends StatefulWidget {
  final bool initialIsIncome;

  const CategoryFormScreen({super.key, this.initialIsIncome = false});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedIcon;
  late int _selectedColor;
  late bool _isIncome;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedIcon = CategoryIcon.availableIcons.first.key;
    _selectedColor = CategoryIcon.availableColors.first;
    _isIncome = widget.initialIsIncome;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(
        CategoryFormData(
          name: _nameController.text.trim(),
          icon: _selectedIcon,
          color: _selectedColor,
          isIncome: _isIncome,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New category'),
        actions: [
          IconButton(
            tooltip: 'Save category',
            icon: const Icon(Icons.check_rounded),
            onPressed: _submit,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FadingScrollBoundary(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fluid Segmented Type Control
                FluidSegmentedControl<bool>(
                  padding: EdgeInsets.zero,
                  items: const [false, true],
                  selectedItem: _isIncome,
                  onSelectedItemChanged: (val) {
                    setState(() {
                      _isIncome = val;
                    });
                  },
                  labelBuilder: (isInc) => isInc ? 'Income' : 'Expense',
                  iconBuilder: (isInc) => isInc
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                ),
                const SizedBox(height: 24),

                // Category Name Input
                Text(
                  'Category Name',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.35,
                          )
                        : theme.colorScheme.surfaceContainerHigh.withValues(
                            alpha: 0.45,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.04),
                    ),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      letterSpacing: -0.1,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'e.g. Subscriptions, Groceries...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      icon: Icon(
                        Icons.label_outline_rounded,
                        size: 22,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Icon Picker Section
                Text(
                  'Select Icon',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: CategoryIcon.availableIcons.map((item) {
                    final isSelected = item.key == _selectedIcon;
                    return IconButton(
                      tooltip: item.key,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedIcon = item.key);
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        backgroundColor: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHigh,
                        foregroundColor: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      icon: Icon(item.value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Color Picker Section
                Text(
                  'Select Color',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: CategoryIcon.availableColors.indexed.map((entry) {
                    final index = entry.$1;
                    final colorValue = entry.$2;
                    final isSelected = colorValue == _selectedColor;
                    final color = Color(colorValue);

                    return IconButton(
                      tooltip: 'Color option ${index + 1}',
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedColor = colorValue);
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        backgroundColor: color,
                        foregroundColor: color.computeLuminance() > 0.42
                            ? theme.colorScheme.onSurface
                            : AppTheme.pureWhite,
                      ),
                      icon: Icon(isSelected ? Icons.check : Icons.circle),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 36),

                // Save Category Button
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Save category'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
