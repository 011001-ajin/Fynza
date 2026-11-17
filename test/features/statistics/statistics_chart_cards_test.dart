import 'package:fl_chart/fl_chart.dart';
import 'package:fynza/features/statistics/domain/models/statistics_summary.dart';
import 'package:fynza/features/statistics/presentation/widgets/statistics_chart_cards.dart';
import 'package:fynza/features/transactions/domain/models/transaction.dart';
import 'package:fynza/shared/models/app_currency.dart';
import 'package:fynza/shared/models/category.dart';
import 'package:fynza/shared/models/transaction_type.dart';
import 'package:fynza/shared/models/transaction_with_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders populated yearly analytics charts', (tester) async {
    final year = DateTime.now().year;
    const food = Category(
      id: 1,
      name: 'Food',
      icon: 'restaurant',
      color: 0xFFF49E8C,
      isIncome: false,
    );
    const salary = Category(
      id: 2,
      name: 'Salary',
      icon: 'work',
      color: 0xFF7FDCB8,
      isIncome: true,
    );
    final summary = StatisticsSummary.fromTransactions(
      year: year,
      transactions: [
        _transaction(
          id: 1,
          amount: 12500,
          type: TransactionType.expense,
          date: DateTime(year, 1, 4),
          category: food,
        ),
        _transaction(
          id: 2,
          amount: 8500,
          type: TransactionType.expense,
          date: DateTime(year, 2, 8),
          category: food,
        ),
        _transaction(
          id: 3,
          amount: 350000,
          type: TransactionType.income,
          date: DateTime(year, 1, 1),
          category: salary,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                StatisticsHeatmapCard(
                  summary: summary,
                  currency: AppCurrency.usd,
                ),
                MonthlyCashFlowChartCard(
                  summary: summary,
                  currency: AppCurrency.usd,
                ),
                ExpenseTrendChartCard(
                  summary: summary,
                  currency: AppCurrency.usd,
                ),
                CategoryBreakdownChartCard(
                  summary: summary,
                  currency: AppCurrency.usd,
                ),
                WeekdayRadarChartCard(summary: summary),
                DailySpendScatterChartCard(summary: summary),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heatmapScrollView = tester.widget<SingleChildScrollView>(
      find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      ),
    );
    final now = DateTime.now();
    final firstDayOffset = DateTime(year, 1, 1).weekday - 1;
    final monthStartIndex = DateTime.utc(
      year,
      now.month,
      1,
    ).difference(DateTime.utc(year, 1, 1)).inDays;
    final monthStartWeek = (firstDayOffset + monthStartIndex) ~/ 7;
    final scrollPosition = heatmapScrollView.controller!.position;

    expect(
      scrollPosition.pixels,
      closeTo(
        (monthStartWeek * 18)
            .clamp(0, scrollPosition.maxScrollExtent)
            .toDouble(),
        0.1,
      ),
    );
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    expect(find.byType(RadarChart), findsOneWidget);
    expect(find.byType(ScatterChart), findsOneWidget);
    expect(find.text('No expenses recorded this year'), findsNothing);
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
