import 'package:flutter_test/flutter_test.dart';
import 'package:fynza/features/dashboard/presentation/view_models/dashboard_notifier.dart';
import 'package:fynza/shared/domain/repositories/dashboard_overview_repository.dart';

class FakeDashboardOverviewRepository implements DashboardOverviewRepository {
  final List<({int month, int year})> requestedMonths = [];
  final DashboardSummary summary = const DashboardSummary(
    totalIncomeCents: 50000,
    totalExpenseCents: 12000,
    netBalanceCents: 38000,
    recentTransactions: [],
    categorySpendings: [],
    expenseCategoryCount: 4,
    incomeCategoryCount: 2,
    totalBudgetedCents: 80000,
    pendingCaptureCount: 3,
    autoCaptureEnabled: true,
  );
  int drainCalls = 0;

  @override
  Stream<DashboardSummary> watchDashboardSummary({
    required int month,
    required int year,
  }) {
    requestedMonths.add((month: month, year: year));
    return Stream.value(summary);
  }

  @override
  Future<void> drainCaptureQueue() async {
    drainCalls++;
  }
}

void main() {
  test(
    'loads overview, follows month changes, and refreshes capture queue',
    () async {
      final repository = FakeDashboardOverviewRepository();
      final notifier = DashboardNotifier(
        repository,
        initialMonth: DateTime(2026, 11),
      );

      await Future<void>.delayed(Duration.zero);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.summary.totalBudgetedCents, 80000);
      expect(notifier.state.summary.pendingCaptureCount, 3);

      notifier.setMonth(12, 2026);
      await Future<void>.delayed(Duration.zero);
      expect(repository.requestedMonths.last, (month: 12, year: 2026));

      await notifier.refreshCaptureQueue();
      expect(repository.drainCalls, 1);
      notifier.dispose();
    },
  );
}
