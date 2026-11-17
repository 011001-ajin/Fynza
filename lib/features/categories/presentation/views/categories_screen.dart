import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynza/shared/widgets/fading_scroll_boundary.dart';

import '../../../../shared/widgets/category_icon.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/fluid_segmented_control.dart';
import '../view_models/categories_notifier.dart';
import 'category_form_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  bool _isIncome = false;

  Future<void> _showAddCategoryDialog(bool isIncome) async {
    final result = await Navigator.of(context).push<CategoryFormData>(
      MaterialPageRoute(
        builder: (context) => CategoryFormScreen(initialIsIncome: isIncome),
      ),
    );

    if (result != null && mounted) {
      await ref
          .read(categoriesNotifierProvider.notifier)
          .addCategory(
            name: result.name,
            icon: result.icon,
            color: result.color,
            isIncome: result.isIncome,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesState = ref.watch(categoriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Apple-style Fluid Segmented Control
          FluidSegmentedControl<bool>(
            items: const [false, true],
            selectedItem: _isIncome,
            onSelectedItemChanged: (val) {
              setState(() {
                _isIncome = val;
              });
            },
            labelBuilder: (isInc) => isInc ? 'Income' : 'Expenses',
            iconBuilder: (isInc) => isInc
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
          ),
          const SizedBox(height: 8),

          // Categories List
          Expanded(
            child: categoriesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Could not load categories',
                  subtitle: 'Try again in a moment.',
                  action: FilledButton.tonal(
                    onPressed: () => ref.invalidate(categoriesNotifierProvider),
                    child: const Text('Try again'),
                  ),
                ),
                data: (categories) {
                  final filtered = categories
                      .where((c) => c.isIncome == _isIncome)
                      .toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.category_outlined,
                      title: 'No Categories Found',
                      subtitle: _isIncome
                          ? 'Add income categories like Salary, Freelance, etc.'
                          : 'Add expense categories like Groceries, Rent, etc.',
                      action: FilledButton.tonalIcon(
                        onPressed: () => _showAddCategoryDialog(_isIncome),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Category'),
                      ),
                    );
                  }

                  return FadingScrollBoundary(
                    child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final category = filtered[index];
                      final catColor = Color(category.color);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: catColor.withValues(alpha: 0.16),
                            child: CategoryIcon(
                              iconKey: category.icon,
                              colorValue: category.color,
                              size: 22,
                            ),
                          ),
                          title: Text(category.name),
                          trailing: IconButton(
                            tooltip: 'Delete ${category.name}',
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete category?'),
                                  content: Text(
                                    'Delete "${category.name}" and its associated transactions?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                HapticFeedback.mediumImpact();
                                await ref
                                    .read(categoriesNotifierProvider.notifier)
                                    .deleteCategory(category.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'categories_fab',
        onPressed: () => _showAddCategoryDialog(_isIncome),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }
}
