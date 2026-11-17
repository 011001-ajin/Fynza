import 'package:fynza/features/statistics/domain/models/statistics_summary.dart';
import 'package:fynza/features/transactions/domain/models/transaction.dart';
import 'package:fynza/shared/models/category.dart';
import 'package:fynza/shared/models/transaction_type.dart';
import 'package:fynza/shared/models/transaction_with_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const food = Category(
    id: 1,
    name: 'Food',
    icon: 'restaurant',
    color: 0xFFFF0000,
    isIncome: false,
  );
  const salary = Category(
    id: 2,
    name: 'Salary',
    icon: 'work',
    color: 0xFF00FF00,
    isIncome: true,
  );

  test('aggregates a leap year by day, month, weekday, and category', () {
    final summary = StatisticsSummary.fromTransactions(
      year: 2024,
      transactions: [
        _transaction(
          id: 1,
          amount: 1250,
          type: TransactionType.expense,
          date: DateTime(2024, 2, 29),
          category: food,
        ),
        _transaction(
          id: 2,
          amount: 500,
          type: TransactionType.expense,
          date: DateTime(2024, 2, 29, 13),
          category: food,
        ),
        _transaction(
          id: 3,
          amount: 2500,
          type: TransactionType.income,
          date: DateTime(2024, 3, 1),
          category: salary,
        ),
        _transaction(
          id: 4,
          amount: 9999,
          type: TransactionType.expense,
          date: DateTime(2023, 12, 31),
          category: food,
        ),
        _transaction(
          id: 5,
          amount: 9999,
          type: TransactionType.expense,
          date: DateTime(2025, 1, 1),
          category: food,
        ),
      ],
    );

    final leapDay = summary.dailySpending.firstWhere(
      (day) => day.date.month == 2 && day.date.day == 29,
    );

    expect(summary.dailySpending, hasLength(366));
    expect(summary.incomeCents, 2500);
    expect(summary.expenseCents, 1750);
    expect(summary.transactionCount, 3);
    expect(summary.monthlyIncomeCents[2], 2500);
    expect(summary.monthlyExpenseCents[1], 1750);
    expect(leapDay.expenseCents, 1750);
    expect(leapDay.transactionCount, 2);
    expect(summary.categorySpending, hasLength(1));
    expect(summary.categorySpending.single.totalCents, 1750);
    expect(summary.categorySpending.single.transactionCount, 2);
  });
}

TransactionWithCategory _transaction({
  required int id,
  required int amount,
  required TransactionType type,
  required DateTime date,
  required Category category,
}) {
  return TransactionWithCategory(
    transaction: Transaction(
      id: id,
      amount: amount,
      type: type,
      categoryId: category.id,
      date: date,
      createdAt: date,
    ),
    category: category,
  );
}
