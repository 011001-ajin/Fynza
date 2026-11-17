import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/currency_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Modern cute finance summary cards featuring tactile touch feedback,
/// side-by-side Blush Expense & Matcha Mint Income cards, and warm optical typography.
class SummaryCards extends ConsumerWidget {
  final int totalIncomeCents;
  final int totalExpenseCents;
  final int netBalanceCents;

  const SummaryCards({
    super.key,
    required this.totalIncomeCents,
    required this.totalExpenseCents,
    required this.netBalanceCents,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = ref.watch(selectedCurrencyProvider);

    final expenseCardBg = isDark
        ? AppTheme.expenseCardBgDark
        : AppTheme.expenseCardBg;
    final expenseTextColor = isDark
        ? AppTheme.expenseAccentDark
        : AppTheme.expenseAccent;

    final incomeCardBg = isDark
        ? AppTheme.incomeCardBgDark
        : AppTheme.incomeCardBg;
    final incomeTextColor = isDark
        ? AppTheme.incomeAccentDark
        : AppTheme.incomeAccent;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Net balance',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  CurrencyFormatter.formatCents(netBalanceCents, currency),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : AppTheme.textCharcoal,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            // Expense Card (Soft Rose Blush)
            Expanded(
              child: Card(
                color: expenseCardBg,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: expenseTextColor.withValues(
                                alpha: isDark ? 0.22 : 0.12,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: expenseTextColor,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Expense',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: expenseTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '-${CurrencyFormatter.formatCents(totalExpenseCents, currency)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: expenseTextColor,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Income Card (Matcha Mint)
            Expanded(
              child: Card(
                color: incomeCardBg,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: incomeTextColor.withValues(
                                alpha: isDark ? 0.22 : 0.14,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              color: incomeTextColor,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Income',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: incomeTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '+${CurrencyFormatter.formatCents(totalIncomeCents, currency)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: incomeTextColor,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
