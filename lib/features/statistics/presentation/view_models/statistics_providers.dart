import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/database_provider.dart';
import '../../../../shared/models/budget_overview.dart';
import '../../domain/models/statistics_summary.dart';

final statisticsSummaryProvider =
    StreamProvider.autoDispose.family<StatisticsSummary, int>((ref, year) {
      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(
        year + 1,
        1,
        1,
      ).subtract(const Duration(microseconds: 1));

      return ref
          .watch(transactionRepositoryProvider)
          .watchTransactions(startDate: startDate, endDate: endDate)
          .map(
            (transactions) => StatisticsSummary.fromTransactions(
              year: year,
              transactions: transactions,
            ),
          );
    });

final statisticsBudgetsProvider =
    StreamProvider.autoDispose.family<List<BudgetOverview>, DateTime>((
      ref,
      month,
    ) {
      return ref
          .watch(budgetRepositoryProvider)
          .watchBudgetOverviews(month: month.month, year: month.year);
    });
