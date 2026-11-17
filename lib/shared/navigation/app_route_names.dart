import '../models/category_spending.dart';
import '../models/transaction_type.dart';
import '../models/transaction_with_category.dart';

abstract final class AppRouteNames {
  static const transactionForm = '/transaction-form';
  static const budget = '/budget';
  static const categories = '/categories';
  static const captureInbox = '/capture-inbox';
  static const autoCaptureSettings = '/auto-capture-settings';
  static const dataAndStorage = '/data-and-storage';
  static const spendingBreakdown = '/spending-breakdown';
}

class TransactionFormRouteArgs {
  final TransactionWithCategory? initial;
  final int? captureIdToConfirm;
  final int? prefilledAmountCents;
  final TransactionType? prefilledType;
  final int? prefilledCategoryId;
  final DateTime? prefilledDate;
  final String? prefilledNote;

  const TransactionFormRouteArgs({
    this.initial,
    this.captureIdToConfirm,
    this.prefilledAmountCents,
    this.prefilledType,
    this.prefilledCategoryId,
    this.prefilledDate,
    this.prefilledNote,
  });
}

class SpendingBreakdownRouteArgs {
  final List<CategorySpending> spendings;
  final int totalExpenseCents;

  const SpendingBreakdownRouteArgs({
    required this.spendings,
    required this.totalExpenseCents,
  });
}
