import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auto_capture/data/repositories/capture_repository_impl.dart';
import '../../features/auto_capture/data/repositories/capture_control_repository_impl.dart';
import '../../features/auto_capture/data/services/capture_preferences_service.dart';
import '../../features/auto_capture/data/services/notification_capture_service.dart';
import '../../features/auto_capture/data/services/auto_capture_scheduler.dart';
import '../../features/auto_capture/domain/repositories/capture_repository.dart';
import '../../features/auto_capture/domain/repositories/capture_control_repository.dart';
import '../../features/backup/data/services/auto_backup_scheduler.dart';
import '../../features/backup/data/services/backup_preferences_service.dart';
import '../../features/backup/data/services/backup_file_service.dart';
import '../../data/db/app_database.dart';
import '../../features/budget/data/services/budget_dao.dart';
import '../../features/budget/data/repositories/budget_repository_impl.dart';
import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/backup/data/repositories/backup_repository_impl.dart';
import '../../features/backup/data/repositories/backup_workflow_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';
import '../../features/backup/domain/repositories/backup_workflow_repository.dart';
import '../services/currency_service.dart';
import '../services/app_startup_coordinator.dart';
import '../../features/categories/data/services/category_dao.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../data/repositories/dashboard_overview_repository_impl.dart';
import '../../shared/domain/repositories/dashboard_overview_repository.dart';
import '../../data/repositories/category_catalog_repository_impl.dart';
import '../../shared/domain/repositories/category_catalog_repository.dart';
import '../../data/repositories/transaction_entry_repository_impl.dart';
import '../../shared/domain/repositories/transaction_entry_repository.dart';
import '../../data/repositories/transaction_list_repository_impl.dart';
import '../../shared/domain/repositories/transaction_list_repository.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../shared/domain/repositories/currency_repository.dart';
import '../../features/transactions/data/services/transaction_dao.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final captureRepositoryProvider = Provider<CaptureRepository>((ref) {
  return CaptureRepositoryImpl(
    db: ref.watch(databaseProvider),
    prefs: ref.watch(capturePreferencesServiceProvider),
  );
});

final captureControlRepositoryProvider = Provider<CaptureControlRepository>((
  ref,
) {
  return CaptureControlRepositoryImpl(
    ref.watch(capturePreferencesServiceProvider),
    ref.watch(notificationCaptureServiceProvider),
    ref.watch(autoCaptureSchedulerProvider),
  );
});

final capturePreferencesServiceProvider = Provider<CapturePreferencesService>((
  ref,
) {
  return CapturePreferencesService(ref.watch(sharedPreferencesProvider));
});

final notificationCaptureServiceProvider = Provider<NotificationCaptureService>(
  (ref) {
    return NotificationCaptureServiceImpl();
  },
);

final autoCaptureSchedulerProvider = Provider<AutoCaptureScheduler>((ref) {
  return AutoCaptureScheduler(
    ref.watch(notificationCaptureServiceProvider),
    ref.watch(captureRepositoryProvider),
    preferences: ref.watch(capturePreferencesServiceProvider),
  );
});

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(currencyServiceProvider),
  );
});

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return CurrencyRepositoryImpl(ref.watch(currencyServiceProvider));
});

final backupPreferencesServiceProvider = Provider<BackupPreferencesService>((
  ref,
) {
  return BackupPreferencesService(ref.watch(sharedPreferencesProvider));
});

final autoBackupSchedulerProvider = Provider<AutoBackupScheduler>((ref) {
  return AutoBackupScheduler(ref.watch(backupPreferencesServiceProvider));
});

final backupFileServiceProvider = Provider<BackupFileService>((ref) {
  return BackupFileService();
});

final backupWorkflowRepositoryProvider = Provider<BackupWorkflowRepository>((
  ref,
) {
  return BackupWorkflowRepositoryImpl(
    ref.watch(backupRepositoryProvider),
    ref.watch(backupPreferencesServiceProvider),
    ref.watch(autoBackupSchedulerProvider),
    ref.watch(backupFileServiceProvider),
  );
});

final appStartupCoordinatorProvider = Provider<AppStartupCoordinator>((ref) {
  return AppStartupCoordinator(
    backupScheduler: ref.watch(autoBackupSchedulerProvider),
    backupRepository: ref.watch(backupRepositoryProvider),
    captureScheduler: ref.watch(autoCaptureSchedulerProvider),
  );
});

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return ref.watch(databaseProvider).categoryDao;
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return ref.watch(databaseProvider).transactionDao;
});

final budgetDaoProvider = Provider<BudgetDao>((ref) {
  return ref.watch(databaseProvider).budgetDao;
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(categoryDaoProvider));
});

final categoryCatalogRepositoryProvider = Provider<CategoryCatalogRepository>((
  ref,
) {
  return CategoryCatalogRepositoryImpl(
    ref.watch(categoryRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(ref.watch(transactionDaoProvider));
});

final transactionEntryRepositoryProvider = Provider<TransactionEntryRepository>(
  (ref) {
    return TransactionEntryRepositoryImpl(
      ref.watch(transactionRepositoryProvider),
      ref.watch(captureRepositoryProvider),
    );
  },
);

final transactionListRepositoryProvider = Provider<TransactionListRepository>((
  ref,
) {
  return TransactionListRepositoryImpl(
    ref.watch(transactionRepositoryProvider),
    ref.watch(captureRepositoryProvider),
    ref.watch(captureControlRepositoryProvider),
  );
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(budgetDaoProvider));
});

final dashboardOverviewRepositoryProvider =
    Provider<DashboardOverviewRepository>((ref) {
      return DashboardOverviewRepositoryImpl(
        ref.watch(transactionRepositoryProvider),
        ref.watch(categoryRepositoryProvider),
        ref.watch(budgetRepositoryProvider),
        ref.watch(captureRepositoryProvider),
        ref.watch(captureControlRepositoryProvider),
      );
    });
