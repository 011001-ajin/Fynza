import 'package:flutter/material.dart';

import '../../shared/navigation/app_route_names.dart';
import '../auto_capture/presentation/views/auto_capture_settings_view.dart';
import '../auto_capture/presentation/views/capture_inbox_view.dart';
import '../backup/presentation/views/data_and_storage_view.dart';
import '../budget/presentation/views/budget_screen.dart';
import '../categories/presentation/views/categories_screen.dart';
import '../dashboard/presentation/views/spending_breakdown_screen.dart';
import '../transactions/presentation/views/transaction_form_screen.dart';

class AppRouteFactory {
  const AppRouteFactory._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget? page = switch (settings.name) {
      AppRouteNames.transactionForm => _transactionForm(settings.arguments),
      AppRouteNames.budget => const BudgetScreen(),
      AppRouteNames.categories => const CategoriesScreen(),
      AppRouteNames.captureInbox => const CaptureInboxView(),
      AppRouteNames.autoCaptureSettings => const AutoCaptureSettingsView(),
      AppRouteNames.dataAndStorage => const DataAndStorageView(),
      AppRouteNames.spendingBreakdown => _spendingBreakdown(settings.arguments),
      _ => null,
    };

    if (page == null) return null;
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }

  static Widget _transactionForm(Object? arguments) {
    final args = arguments is TransactionFormRouteArgs
        ? arguments
        : const TransactionFormRouteArgs();

    return TransactionFormScreen(
      initial: args.initial,
      captureIdToConfirm: args.captureIdToConfirm,
      prefilledAmountCents: args.prefilledAmountCents,
      prefilledType: args.prefilledType,
      prefilledCategoryId: args.prefilledCategoryId,
      prefilledDate: args.prefilledDate,
      prefilledNote: args.prefilledNote,
    );
  }

  static Widget? _spendingBreakdown(Object? arguments) {
    if (arguments is! SpendingBreakdownRouteArgs) return null;
    return SpendingBreakdownScreen(
      spendings: arguments.spendings,
      totalExpenseCents: arguments.totalExpenseCents,
    );
  }
}
