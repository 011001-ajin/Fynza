import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/database_provider.dart';
import '../../../../shared/models/budget_overview.dart';
import '../../../../shared/providers/global_month_provider.dart';
import '../../../../shared/domain/repositories/category_catalog_repository.dart';
import '../../../../shared/models/category.dart';
import '../../../../shared/models/transaction_type.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetState {
  final List<BudgetOverview> overviews;
  final List<Category> categories;
  final List<int> recentExpenseCategoryIds;
  final int selectedMonth;
  final int selectedYear;
  final bool isLoading;

  const BudgetState({
    required this.overviews,
    this.categories = const [],
    this.recentExpenseCategoryIds = const [],
    required this.selectedMonth,
    required this.selectedYear,
    required this.isLoading,
  });

  factory BudgetState.initial({DateTime? initialMonth}) {
    final now = initialMonth ?? DateTime.now();
    return BudgetState(
      overviews: const [],
      selectedMonth: now.month,
      selectedYear: now.year,
      isLoading: true,
    );
  }

  BudgetState copyWith({
    List<BudgetOverview>? overviews,
    List<Category>? categories,
    List<int>? recentExpenseCategoryIds,
    int? selectedMonth,
    int? selectedYear,
    bool? isLoading,
  }) {
    return BudgetState(
      overviews: overviews ?? this.overviews,
      categories: categories ?? this.categories,
      recentExpenseCategoryIds:
          recentExpenseCategoryIds ?? this.recentExpenseCategoryIds,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalBudgetedCents =>
      overviews.fold<int>(0, (sum, item) => sum + item.budget.amountLimit);

  int get totalSpentCents =>
      overviews.fold<int>(0, (sum, item) => sum + item.spentCents);

  double get overallProgress {
    if (totalBudgetedCents <= 0) return 0.0;
    return (totalSpentCents / totalBudgetedCents).clamp(0.0, 1.0);
  }
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  final BudgetRepository _repository;
  final CategoryCatalogRepository? _categoryCatalogRepository;
  StreamSubscription<List<BudgetOverview>>? _subscription;
  StreamSubscription<List<Category>>? _categoriesSubscription;
  StreamSubscription<List<int>>? _recentCategoriesSubscription;

  BudgetNotifier(
    this._repository, [
    DateTime? initialMonth,
    this._categoryCatalogRepository,
  ]) : super(BudgetState.initial(initialMonth: initialMonth)) {
    _subscribeToBudgets();
    _subscribeToCategories();
  }

  void _subscribeToCategories() {
    final catalog = _categoryCatalogRepository;
    if (catalog == null) return;
    _categoriesSubscription = catalog.watchAllCategories().listen(
      (categories) => state = state.copyWith(categories: categories),
      onError: (_, _) {},
    );
    _recentCategoriesSubscription = catalog
        .watchRecentCategoryIds(TransactionType.expense)
        .listen(
          (ids) => state = state.copyWith(recentExpenseCategoryIds: ids),
          onError: (_, _) {},
        );
  }

  void _subscribeToBudgets() {
    _subscription?.cancel();
    state = state.copyWith(isLoading: true);

    _subscription = _repository
        .watchBudgetOverviews(
          month: state.selectedMonth,
          year: state.selectedYear,
        )
        .listen(
          (data) {
            state = state.copyWith(overviews: data, isLoading: false);
          },
          onError: (_, _) {
            state = state.copyWith(isLoading: false);
          },
        );
  }

  void setMonth(int month, int year) {
    if (state.selectedMonth == month && state.selectedYear == year) return;
    state = state.copyWith(selectedMonth: month, selectedYear: year);
    _subscribeToBudgets();
  }

  Future<void> setBudget({
    required int categoryId,
    required int amountLimitCents,
  }) async {
    await _repository.setBudget(
      categoryId: categoryId,
      amountLimitCents: amountLimitCents,
      month: state.selectedMonth,
      year: state.selectedYear,
    );
  }

  Future<void> deleteBudget(int id) async {
    await _repository.deleteBudget(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _categoriesSubscription?.cancel();
    _recentCategoriesSubscription?.cancel();
    super.dispose();
  }
}

final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
      final repository = ref.watch(budgetRepositoryProvider);
      final categoryCatalog = ref.watch(categoryCatalogRepositoryProvider);
      final initialMonth = ref.read(globalMonthProvider);
      final notifier = BudgetNotifier(
        repository,
        initialMonth,
        categoryCatalog,
      );
      ref.listen<DateTime>(globalMonthProvider, (_, next) {
        notifier.setMonth(next.month, next.year);
      });
      return notifier;
    });
