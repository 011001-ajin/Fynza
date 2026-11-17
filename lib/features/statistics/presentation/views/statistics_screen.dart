import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/models/app_currency.dart';
import '../../../../shared/models/budget_overview.dart';
import '../../../../shared/providers/currency_provider.dart';
import '../../../../shared/widgets/fading_scroll_boundary.dart';
import '../../domain/models/statistics_summary.dart';
import '../view_models/statistics_providers.dart';
import '../widgets/statistics_chart_cards.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final currency = ref.watch(selectedCurrencyProvider);
    final summary = ref.watch(statisticsSummaryProvider(now.year));
    final budgets = ref.watch(
      statisticsBudgetsProvider(DateTime(now.year, now.month)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: FadingScrollBoundary(
        child: summary.when(
          data: (summary) => _StatisticsContent(
            summary: summary,
            currency: currency,
            budgets: budgets,
          ),
          error: (error, stackTrace) => _StatisticsError(
            error: error,
            onRetry: () => ref.invalidate(statisticsSummaryProvider(now.year)),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _StatisticsContent extends StatelessWidget {
  final StatisticsSummary summary;
  final AppCurrency currency;
  final AsyncValue<List<BudgetOverview>> budgets;

  const _StatisticsContent({
    required this.summary,
    required this.currency,
    required this.budgets,
  });

  @override
  Widget build(BuildContext context) {
    final yearNetCents = summary.incomeCents - summary.expenseCents;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Your finances in ${summary.year}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricCard(
                  width: width,
                  label: 'Income',
                  value: CurrencyFormatter.formatCents(
                    summary.incomeCents,
                    currency,
                  ),
                  color: theme.colorScheme.tertiary,
                ),
                _MetricCard(
                  width: width,
                  label: 'Expenses',
                  value: CurrencyFormatter.formatCents(
                    summary.expenseCents,
                    currency,
                  ),
                  color: theme.colorScheme.error,
                ),
                _MetricCard(
                  width: width,
                  label: 'Net',
                  value: CurrencyFormatter.formatCents(yearNetCents, currency),
                  color: yearNetCents < 0
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                _MetricCard(
                  width: width,
                  label: 'Transactions',
                  value: '${summary.transactionCount}',
                  color: theme.colorScheme.secondary,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        StatisticsHeatmapCard(summary: summary, currency: currency),
        const SizedBox(height: 12),
        MonthlyCashFlowChartCard(summary: summary, currency: currency),
        const SizedBox(height: 12),
        ExpenseTrendChartCard(summary: summary, currency: currency),
        const SizedBox(height: 12),
        CategoryBreakdownChartCard(summary: summary, currency: currency),
        const SizedBox(height: 12),
        WeekdayRadarChartCard(summary: summary),
        const SizedBox(height: 12),
        DailySpendScatterChartCard(summary: summary),
        const SizedBox(height: 12),
        budgets.when(
          data: (items) => BudgetUtilizationChartCard(
            budgets: items,
            currency: currency,
          ),
          error: (error, stackTrace) => _StatisticsError(
            error: error,
            title: 'Unable to load budget statistics',
          ),
          loading: () => const _StatisticsLoadingCard(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.width,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsLoadingCard extends StatelessWidget {
  const _StatisticsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _StatisticsError extends StatelessWidget {
  final Object error;
  final String title;
  final VoidCallback? onRetry;

  const _StatisticsError({
    required this.error,
    this.title = 'Unable to load statistics',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 36),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
