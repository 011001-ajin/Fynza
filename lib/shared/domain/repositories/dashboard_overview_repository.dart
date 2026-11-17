import '../../models/category_spending.dart';
import '../../models/transaction_with_category.dart';

class DashboardSummary {
  final int totalIncomeCents;
  final int totalExpenseCents;
  final int netBalanceCents;
  final List<TransactionWithCategory> recentTransactions;
  final List<CategorySpending> categorySpendings;
  final int expenseCategoryCount;
  final int incomeCategoryCount;
  final int totalBudgetedCents;
  final int pendingCaptureCount;
  final bool autoCaptureEnabled;

  const DashboardSummary({
    required this.totalIncomeCents,
    required this.totalExpenseCents,
    required this.netBalanceCents,
    required this.recentTransactions,
    required this.categorySpendings,
    this.expenseCategoryCount = 0,
    this.incomeCategoryCount = 0,
    this.totalBudgetedCents = 0,
    this.pendingCaptureCount = 0,
    this.autoCaptureEnabled = false,
  });

  const DashboardSummary.empty()
    : totalIncomeCents = 0,
      totalExpenseCents = 0,
      netBalanceCents = 0,
      recentTransactions = const [],
      categorySpendings = const [],
      expenseCategoryCount = 0,
      incomeCategoryCount = 0,
      totalBudgetedCents = 0,
      pendingCaptureCount = 0,
      autoCaptureEnabled = false;
}

abstract interface class DashboardOverviewRepository {
  Stream<DashboardSummary> watchDashboardSummary({
    required int month,
    required int year,
  });

  Future<void> drainCaptureQueue();
}
