import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/models/app_currency.dart';
import '../../../../shared/models/budget_overview.dart';
import '../../../../shared/models/category_spending.dart';
import '../../domain/models/statistics_summary.dart';

class StatisticsHeatmapCard extends StatelessWidget {
  final StatisticsSummary summary;
  final AppCurrency currency;

  const StatisticsHeatmapCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final maxExpense = summary.dailySpending.fold<int>(
      0,
      (maximum, day) => math.max(maximum, day.expenseCents),
    );
    final firstDayOffset = DateTime(summary.year, 1, 1).weekday - 1;
    final weekCount = (firstDayOffset + summary.dailySpending.length + 6) ~/ 7;

    return _ChartCard(
      title: 'Daily spending',
      subtitle: 'A calendar view of your expenses during ${summary.year}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (maxExpense == 0)
            const _ChartEmptyState(message: 'No expenses recorded this year')
          else
            Semantics(
              label: 'Daily spending heatmap for ${summary.year}',
              child: _HeatmapCurrentMonthScroll(
                year: summary.year,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 17),
                        for (final day in const [
                          'M',
                          'T',
                          'W',
                          'T',
                          'F',
                          'S',
                          'S',
                        ])
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Text(
                              day,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var week = 0; week < weekCount; week++)
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 13,
                                  height: 17,
                                  child: Text(
                                    _monthLabelForWeek(
                                      summary,
                                      firstDayOffset,
                                      week,
                                    ),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 8,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                for (var weekday = 0; weekday < 7; weekday++)
                                  _heatmapCell(
                                    summary: summary,
                                    firstDayOffset: firstDayOffset,
                                    week: week,
                                    weekday: weekday,
                                    maxExpense: maxExpense,
                                    color: color,
                                    emptyColor: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    currency: currency,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          _HeatmapLegend(color: color),
        ],
      ),
    );
  }

  String _monthLabelForWeek(
    StatisticsSummary summary,
    int firstDayOffset,
    int week,
  ) {
    for (var weekday = 0; weekday < 7; weekday++) {
      final dayIndex = week * 7 + weekday - firstDayOffset;
      if (dayIndex < 0 || dayIndex >= summary.dailySpending.length) continue;
      final date = summary.dailySpending[dayIndex].date;
      if (date.day == 1) return _monthAbbreviation(date.month);
    }
    return '';
  }

  Widget _heatmapCell({
    required StatisticsSummary summary,
    required int firstDayOffset,
    required int week,
    required int weekday,
    required int maxExpense,
    required Color color,
    required Color emptyColor,
    required AppCurrency currency,
  }) {
    final dayIndex = week * 7 + weekday - firstDayOffset;
    if (dayIndex < 0 || dayIndex >= summary.dailySpending.length) {
      return const SizedBox(width: 15, height: 15);
    }

    final day = summary.dailySpending[dayIndex];
    final intensity = maxExpense == 0
        ? 0
        : ((day.expenseCents / maxExpense) * 4).ceil().clamp(1, 4);
    final fill = day.expenseCents == 0
        ? emptyColor.withValues(alpha: 0.6)
        : color.withValues(alpha: 0.18 + intensity * 0.2);

    return Tooltip(
      message:
          '${day.date.month}/${day.date.day}: '
          '${CurrencyFormatter.formatCents(day.expenseCents, currency)}',
      child: Semantics(
        label:
            '${day.date.month}/${day.date.day}, '
            '${CurrencyFormatter.formatCents(day.expenseCents, currency)} spent',
        child: Container(
          width: 15,
          height: 15,
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _HeatmapCurrentMonthScroll extends StatefulWidget {
  final int year;
  final Widget child;

  const _HeatmapCurrentMonthScroll({required this.year, required this.child});

  @override
  State<_HeatmapCurrentMonthScroll> createState() =>
      _HeatmapCurrentMonthScrollState();
}

class _HeatmapCurrentMonthScrollState
    extends State<_HeatmapCurrentMonthScroll> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final month = now.year == widget.year ? now.month : 1;
    final firstDayOffset = DateTime(widget.year, 1, 1).weekday - 1;
    final monthStartIndex = DateTime.utc(
      widget.year,
      month,
      1,
    ).difference(DateTime.utc(widget.year, 1, 1)).inDays;
    final monthStartWeek = (firstDayOffset + monthStartIndex) ~/ 7;

    _scrollController = ScrollController(
      initialScrollOffset: monthStartWeek * 18,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );
  }
}

class MonthlyCashFlowChartCard extends StatelessWidget {
  final StatisticsSummary summary;
  final AppCurrency currency;

  const MonthlyCashFlowChartCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = _maxOf([
      ...summary.monthlyIncomeCents,
      ...summary.monthlyExpenseCents,
    ]);

    return _ChartCard(
      title: 'Income vs expenses',
      subtitle: 'Monthly cash flow',
      child: Column(
        children: [
          if (maxValue == 0)
            const _ChartEmptyState(
              message: 'No transactions recorded this year',
            )
          else
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxValue * 1.15,
                  barGroups: [
                    for (var month = 0; month < 12; month++)
                      BarChartGroupData(
                        x: month,
                        barsSpace: 3,
                        barRods: [
                          BarChartRodData(
                            toY: summary.monthlyIncomeCents[month].toDouble(),
                            color: theme.colorScheme.tertiary,
                            width: 7,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          BarChartRodData(
                            toY: summary.monthlyExpenseCents[month].toDouble(),
                            color: theme.colorScheme.error,
                            width: 7,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                  ],
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: _monthTitles(theme),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final type = rodIndex == 0 ? 'Income' : 'Expenses';
                        return BarTooltipItem(
                          '$type\n${CurrencyFormatter.formatCents(rod.toY.round(), currency)}',
                          TextStyle(color: theme.colorScheme.onInverseSurface),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          _ChartLegend(
            items: [
              _LegendEntry('Income', theme.colorScheme.tertiary),
              _LegendEntry('Expenses', theme.colorScheme.error),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseTrendChartCard extends StatelessWidget {
  final StatisticsSummary summary;
  final AppCurrency currency;

  const ExpenseTrendChartCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = _maxOf(summary.monthlyExpenseCents);
    final color = theme.colorScheme.primary;

    return _ChartCard(
      title: 'Expense trend',
      subtitle: 'How your monthly spending changes over the year',
      child: maxValue == 0
          ? const _ChartEmptyState(message: 'No expenses recorded this year')
          : SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: maxValue * 1.2,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: _monthTitles(theme),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var month = 0; month < 12; month++)
                          FlSpot(
                            month.toDouble(),
                            summary.monthlyExpenseCents[month].toDouble(),
                          ),
                      ],
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) => spots
                          .map(
                            (spot) => LineTooltipItem(
                              CurrencyFormatter.formatCents(
                                spot.y.round(),
                                currency,
                              ),
                              TextStyle(
                                color: theme.colorScheme.onInverseSurface,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class CategoryBreakdownChartCard extends StatelessWidget {
  final StatisticsSummary summary;
  final AppCurrency currency;

  const CategoryBreakdownChartCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spendings = summary.categorySpending;

    return _ChartCard(
      title: 'Spending by category',
      subtitle: 'Where your money went this year',
      child: spendings.isEmpty
          ? const _ChartEmptyState(message: 'No category spending recorded')
          : Column(
              children: [
                SizedBox(
                  height: 210,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 48,
                          borderData: FlBorderData(show: false),
                          sections: [
                            for (final item in spendings)
                              PieChartSectionData(
                                value: item.totalCents.toDouble(),
                                color: Color(item.category.color),
                                title: '',
                                radius: 25,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            CurrencyFormatter.formatCents(
                              summary.expenseCents,
                              currency,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text('Total', style: theme.textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in spendings)
                  _CategoryLegendRow(
                    item: item,
                    totalCents: summary.expenseCents,
                    currency: currency,
                  ),
              ],
            ),
    );
  }
}

class WeekdayRadarChartCard extends StatelessWidget {
  final StatisticsSummary summary;

  const WeekdayRadarChartCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final maxValue = _maxOf(summary.averageExpenseByWeekdayCents);

    return _ChartCard(
      title: 'Spending by weekday',
      subtitle: 'Average daily expense for each day of the week',
      child: maxValue == 0
          ? const _ChartEmptyState(message: 'No weekday spending pattern yet')
          : SizedBox(
              height: 270,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: color.withValues(alpha: 0.18),
                      borderColor: color,
                      entryRadius: 2,
                      dataEntries: [
                        for (final value
                            in summary.averageExpenseByWeekdayCents)
                          RadarEntry(value: value.toDouble()),
                      ],
                    ),
                  ],
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  titlePositionPercentageOffset: 0.18,
                  titleTextStyle: theme.textTheme.labelSmall,
                  getTitle: (index, angle) => RadarChartTitle(
                    text: const [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ][index],
                    angle: angle,
                  ),
                  ticksTextStyle: theme.textTheme.labelSmall,
                  gridBorderData: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                  radarBorderData: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
    );
  }
}

class DailySpendScatterChartCard extends StatelessWidget {
  final StatisticsSummary summary;

  const DailySpendScatterChartCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = summary.dailySpending
        .where((day) => day.expenseCents > 0)
        .toList();
    final maxTransactions = days.fold<int>(
      0,
      (maximum, day) => math.max(maximum, day.transactionCount),
    );
    final maxExpense = days.fold<int>(
      0,
      (maximum, day) => math.max(maximum, day.expenseCents),
    );
    final color = theme.colorScheme.primary;

    return _ChartCard(
      title: 'Daily spending pattern',
      subtitle: 'Each point compares daily transaction count with spending',
      child: days.isEmpty
          ? const _ChartEmptyState(message: 'No daily spending to compare')
          : SizedBox(
              height: 240,
              child: ScatterChart(
                ScatterChartData(
                  minX: 0,
                  maxX: (maxTransactions + 1).toDouble(),
                  minY: 0,
                  maxY: maxExpense * 1.15,
                  scatterSpots: [
                    for (final day in days)
                      ScatterSpot(
                        day.transactionCount.toDouble(),
                        day.expenseCents.toDouble(),
                        dotPainter: FlDotCirclePainter(
                          color: color.withValues(alpha: 0.7),
                          radius: 4,
                        ),
                      ),
                  ],
                  gridData: FlGridData(
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  scatterTouchData: ScatterTouchData(enabled: false),
                ),
              ),
            ),
    );
  }
}

class BudgetUtilizationChartCard extends StatelessWidget {
  final List<BudgetOverview> budgets;
  final AppCurrency currency;

  const BudgetUtilizationChartCard({
    super.key,
    required this.budgets,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _ChartCard(
      title: 'Budget utilization',
      subtitle: 'Your current month budgets',
      child: budgets.isEmpty
          ? const _ChartEmptyState(message: 'No budgets set for this month')
          : Column(
              children: [
                for (final item in budgets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.category.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${CurrencyFormatter.formatCents(item.spentCents, currency)} / '
                              '${CurrencyFormatter.formatCents(item.budget.amountLimit, currency)}',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: item.progress,
                          color: item.isOverBudget
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        if (item.isOverBudget)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Over by ${CurrencyFormatter.formatCents(item.spentCents - item.budget.amountLimit, currency)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  final String message;

  const _ChartEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}

class _CategoryLegendRow extends StatelessWidget {
  final CategorySpending item;
  final int totalCents;
  final AppCurrency currency;

  const _CategoryLegendRow({
    required this.item,
    required this.totalCents,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = totalCents == 0 ? 0 : item.totalCents / totalCents * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Color(item.category.color),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${percent.toStringAsFixed(1)}%',
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyFormatter.formatCents(item.totalCents, currency),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final List<_LegendEntry> items;

  const _ChartLegend({required this.items});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(item.label, style: style),
            ],
          ),
      ],
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  final Color color;

  const _HeatmapLegend({required this.color});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less', style: style),
        const SizedBox(width: 6),
        for (final alpha in const [0.18, 0.38, 0.58, 0.78])
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: alpha),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        Text('More', style: style),
      ],
    );
  }
}

class _LegendEntry {
  final String label;
  final Color color;

  const _LegendEntry(this.label, this.color);
}

FlTitlesData _monthTitles(ThemeData theme) {
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 24,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index < 0 || index >= 12) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            child: Text(
              _monthAbbreviation(index + 1),
              style: theme.textTheme.labelSmall,
            ),
          );
        },
      ),
    ),
  );
}

double _maxOf(Iterable<int> values) {
  return values
      .fold<int>(0, (maximum, value) => maximum > value ? maximum : value)
      .toDouble();
}

String _monthAbbreviation(int month) {
  return const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}
