import 'dart:async';

import '../../features/auto_capture/domain/repositories/capture_control_repository.dart';
import '../../features/auto_capture/domain/repositories/capture_repository.dart';
import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../shared/domain/repositories/dashboard_overview_repository.dart';
import '../../shared/models/category_spending.dart';
import '../../shared/models/transaction_type.dart';
import '../../shared/models/transaction_with_category.dart';

class DashboardOverviewRepositoryImpl implements DashboardOverviewRepository {
  final TransactionRepository _transactions;
  final CategoryRepository _categories;
  final BudgetRepository _budgets;
  final CaptureRepository _captures;
  final CaptureControlRepository _captureControl;

  const DashboardOverviewRepositoryImpl(
    this._transactions,
    this._categories,
    this._budgets,
    this._captures,
    this._captureControl,
  );

  @override
  Future<void> drainCaptureQueue() => _captureControl.drainNow();

  @override
  Stream<DashboardSummary> watchDashboardSummary({
    required int month,
    required int year,
  }) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59, 999);

    late StreamController<DashboardSummary> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];
    var income = 0;
    var expenses = 0;
    var recent = <TransactionWithCategory>[];
    var spendings = <CategorySpending>[];
    var expenseCategoryCount = 0;
    var incomeCategoryCount = 0;
    var totalBudgetedCents = 0;
    var pendingCaptureCount = 0;
    var autoCaptureEnabled = false;

    void emit() {
      if (controller.isClosed) return;
      controller.add(
        DashboardSummary(
          totalIncomeCents: income,
          totalExpenseCents: expenses,
          netBalanceCents: income - expenses,
          recentTransactions: recent,
          categorySpendings: spendings,
          expenseCategoryCount: expenseCategoryCount,
          incomeCategoryCount: incomeCategoryCount,
          totalBudgetedCents: totalBudgetedCents,
          pendingCaptureCount: pendingCaptureCount,
          autoCaptureEnabled: autoCaptureEnabled,
        ),
      );
    }

    void listen<T>(Stream<T> stream, void Function(T value) update) {
      subscriptions.add(
        stream.listen(
          (value) {
            update(value);
            emit();
          },
          onError: controller.addError,
        ),
      );
    }

    controller = StreamController<DashboardSummary>(
      onListen: () {
        listen(
          _transactions.watchTotal(
            type: TransactionType.income,
            startDate: startDate,
            endDate: endDate,
          ),
          (value) => income = value,
        );
        listen(
          _transactions.watchTotal(
            type: TransactionType.expense,
            startDate: startDate,
            endDate: endDate,
          ),
          (value) => expenses = value,
        );
        listen(
          _transactions.watchRecentTransactions(limit: 5),
          (value) => recent = value,
        );
        listen(
          _transactions.watchCategorySpending(
            startDate: startDate,
            endDate: endDate,
          ),
          (value) => spendings = value,
        );
        listen(_categories.watchAllCategories(), (categories) {
          expenseCategoryCount = categories.where((c) => !c.isIncome).length;
          incomeCategoryCount = categories.where((c) => c.isIncome).length;
        });
        listen(
          _budgets.watchBudgetOverviews(month: month, year: year),
          (overviews) => totalBudgetedCents = overviews.fold<int>(
            0,
            (total, overview) => total + overview.budget.amountLimit,
          ),
        );
        listen(
          _captures.watchPendingCount(),
          (value) => pendingCaptureCount = value,
        );
        listen(
          _captureControl.watchMasterEnabled(),
          (value) => autoCaptureEnabled = value,
        );
      },
      onCancel: () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );

    return controller.stream;
  }
}
