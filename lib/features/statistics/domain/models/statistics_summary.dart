import '../../../../shared/models/category_spending.dart';
import '../../../../shared/models/category.dart';
import '../../../../shared/models/transaction_with_category.dart';

class DailySpending {
  final DateTime date;
  final int expenseCents;
  final int transactionCount;

  const DailySpending({
    required this.date,
    required this.expenseCents,
    required this.transactionCount,
  });
}

class StatisticsSummary {
  final int year;
  final int incomeCents;
  final int expenseCents;
  final int transactionCount;
  final List<int> monthlyIncomeCents;
  final List<int> monthlyExpenseCents;
  final List<int> averageExpenseByWeekdayCents;
  final List<DailySpending> dailySpending;
  final List<CategorySpending> categorySpending;

  const StatisticsSummary({
    required this.year,
    required this.incomeCents,
    required this.expenseCents,
    required this.transactionCount,
    required this.monthlyIncomeCents,
    required this.monthlyExpenseCents,
    required this.averageExpenseByWeekdayCents,
    required this.dailySpending,
    required this.categorySpending,
  });

  factory StatisticsSummary.fromTransactions({
    required int year,
    required List<TransactionWithCategory> transactions,
  }) {
    final yearStart = DateTime(year, 1, 1);
    final daysInYear = DateTime(year + 1, 1, 1).difference(yearStart).inDays;
    final dailyExpenses = List<int>.filled(daysInYear, 0);
    final dailyTransactionCounts = List<int>.filled(daysInYear, 0);
    final monthlyIncome = List<int>.filled(12, 0);
    final monthlyExpenses = List<int>.filled(12, 0);
    final weekdayExpenses = List<int>.filled(7, 0);
    final weekdayCounts = List<int>.filled(7, 0);
    final categories = <int, _CategoryTotal>{};

    for (var dayIndex = 0; dayIndex < daysInYear; dayIndex++) {
      final date = yearStart.add(Duration(days: dayIndex));
      weekdayCounts[date.weekday - 1]++;
    }

    var incomeCents = 0;
    var expenseCents = 0;
    var transactionCount = 0;

    for (final item in transactions) {
      final transaction = item.transaction;
      final date = transaction.date;
      if (date.year != year) continue;

      final dayIndex = DateTime.utc(
        date.year,
        date.month,
        date.day,
      ).difference(DateTime.utc(year, 1, 1)).inDays;
      if (dayIndex < 0 || dayIndex >= daysInYear) continue;

      transactionCount++;
      dailyTransactionCounts[dayIndex]++;

      if (transaction.type.isIncome) {
        incomeCents += transaction.amount;
        monthlyIncome[date.month - 1] += transaction.amount;
        continue;
      }

      expenseCents += transaction.amount;
      monthlyExpenses[date.month - 1] += transaction.amount;
      dailyExpenses[dayIndex] += transaction.amount;
      weekdayExpenses[date.weekday - 1] += transaction.amount;

      final categoryTotal = categories.putIfAbsent(
        item.category.id,
        () => _CategoryTotal(item.category),
      );
      categoryTotal.totalCents += transaction.amount;
      categoryTotal.transactionCount++;
    }

    final dailySpending = List<DailySpending>.generate(daysInYear, (index) {
      return DailySpending(
        date: yearStart.add(Duration(days: index)),
        expenseCents: dailyExpenses[index],
        transactionCount: dailyTransactionCounts[index],
      );
    });

    final categorySpending =
        categories.values
            .map(
              (total) => CategorySpending(
                category: total.category,
                totalCents: total.totalCents,
                transactionCount: total.transactionCount,
              ),
            )
            .toList()
          ..sort((a, b) => b.totalCents.compareTo(a.totalCents));

    return StatisticsSummary(
      year: year,
      incomeCents: incomeCents,
      expenseCents: expenseCents,
      transactionCount: transactionCount,
      monthlyIncomeCents: List.unmodifiable(monthlyIncome),
      monthlyExpenseCents: List.unmodifiable(monthlyExpenses),
      averageExpenseByWeekdayCents: List.unmodifiable(
        List<int>.generate(
          7,
          (index) => weekdayExpenses[index] ~/ weekdayCounts[index],
        ),
      ),
      dailySpending: List.unmodifiable(dailySpending),
      categorySpending: List.unmodifiable(categorySpending),
    );
  }
}

class _CategoryTotal {
  final Category category;
  int totalCents = 0;
  int transactionCount = 0;

  _CategoryTotal(this.category);
}
