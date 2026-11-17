import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynza/shared/widgets/fading_scroll_boundary.dart';

import '../../../../core/constants/capture_constants.dart';
import '../../../../shared/providers/currency_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/navigation/app_route_names.dart';
import '../../../../shared/providers/global_month_provider.dart';
import '../../../../shared/widgets/month_selector.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../view_models/dashboard_notifier.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/summary_cards.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback? onNavigateToTransactions;

  const DashboardScreen({super.key, this.onNavigateToTransactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final selectedMonth = ref.watch(globalMonthProvider);
    final monthNotifier = ref.read(globalMonthProvider.notifier);
    final currency = ref.watch(selectedCurrencyProvider);

    final summary = dashboardState.summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          if (CaptureConstants.isEnabled && summary.autoCaptureEnabled)
            IconButton(
              tooltip: 'Capture Inbox',
              icon: Badge(
                isLabelVisible: summary.pendingCaptureCount > 0,
                label: Text('${summary.pendingCaptureCount}'),
                backgroundColor: AppTheme.expenseAccent,
                child: const Icon(Icons.inbox_outlined),
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed<void>(AppRouteNames.captureInbox);
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MonthSelector(
            selectedDate: selectedMonth,
            onPrevious: monthNotifier.previousMonth,
            onNext: monthNotifier.nextMonth,
          ),
        ),
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
                onRefresh: () async {
                  if (CaptureConstants.isEnabled &&
                      summary.autoCaptureEnabled) {
                    await ref
                        .read(dashboardNotifierProvider.notifier)
                        .refreshCaptureQueue();
                  }
                },
                child: FadingScrollBoundary(
                  child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Friendly Greeting Header
                      _StaggeredDashboardSection(
                        index: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your finances at a glance',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? theme.colorScheme.onSurfaceVariant
                                        : AppTheme.textTaupe,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Financial Overview',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Financial Overview Cards (Net Balance + Blush Expense & Mint Income)
                      _StaggeredDashboardSection(
                        index: 1,
                        child: SummaryCards(
                          totalIncomeCents: summary.totalIncomeCents,
                          totalExpenseCents: summary.totalExpenseCents,
                          netBalanceCents: summary.netBalanceCents,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _StaggeredDashboardSection(
                        index: 2,
                        child: SpendingOverviewCard(
                          spendings: summary.categorySpendings,
                          totalExpenseCents: summary.totalExpenseCents,
                          onDetails: () {
                            Navigator.of(context).pushNamed<void>(
                              AppRouteNames.spendingBreakdown,
                              arguments: SpendingBreakdownRouteArgs(
                                spendings: summary.categorySpendings,
                                totalExpenseCents: summary.totalExpenseCents,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      _StaggeredDashboardSection(
                        index: 3,
                        child: Column(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                                leading: const Icon(Icons.pie_chart_outline),
                                title: const Text('Budgets'),
                                subtitle: Text(
                                  'Monthly limit: ${CurrencyFormatter.formatCents(summary.totalBudgetedCents, currency)}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.of(
                                  context,
                                ).pushNamed<void>(AppRouteNames.budget),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                                leading: const Icon(Icons.category_outlined),
                                title: const Text('Categories'),
                                subtitle: Text(
                                  '${summary.expenseCategoryCount} expense categories ? ${summary.incomeCategoryCount} income categories',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.of(
                                  context,
                                ).pushNamed<void>(AppRouteNames.categories),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recent Transactions Header
                      _StaggeredDashboardSection(
                        index: 4,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Recent transactions',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            if (onNavigateToTransactions != null)
                              TextButton(
                                onPressed: onNavigateToTransactions,
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  minimumSize: const Size(48, 48),
                                ),
                                child: const Text('View all'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Recent Transactions List or Warm Empty State
                      if (summary.recentTransactions.isEmpty) ...[
                        _StaggeredDashboardSection(
                          index: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? theme.colorScheme.surfaceContainerLow
                                  : AppTheme.cardWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? theme.colorScheme.outlineVariant
                                          .withValues(alpha: 0.25)
                                    : AppTheme.borderCream,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryAmber.withValues(
                                      alpha: isDark ? 0.2 : 0.12,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.savings_outlined,
                                    color: AppTheme.primaryAmber,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No transactions yet.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? theme.colorScheme.onSurface
                                        : AppTheme.textCharcoal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap + below to add your first transaction',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? theme.colorScheme.onSurfaceVariant
                                        : AppTheme.textTaupe,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        _StaggeredDashboardSection(
                          index: 5,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: summary.recentTransactions.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = summary.recentTransactions[index];
                              return TransactionTile(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).pushNamed<void>(
                                    AppRouteNames.transactionForm,
                                    arguments: TransactionFormRouteArgs(
                                      initial: item,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ),
              ),
    );
  }
}

class _StaggeredDashboardSection extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredDashboardSection({required this.index, required this.child});

  @override
  State<_StaggeredDashboardSection> createState() =>
      _StaggeredDashboardSectionState();
}

class _StaggeredDashboardSectionState extends State<_StaggeredDashboardSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = curved;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.045),
      end: Offset.zero,
    ).animate(curved);

    Future<void>.delayed(Duration(milliseconds: widget.index * 75), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
