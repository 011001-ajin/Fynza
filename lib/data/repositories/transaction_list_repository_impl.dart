import '../../features/auto_capture/domain/repositories/capture_control_repository.dart';
import '../../features/auto_capture/domain/repositories/capture_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../shared/domain/repositories/transaction_list_repository.dart';
import '../../shared/models/transaction_type.dart';
import '../../shared/models/transaction_with_category.dart';

class TransactionListRepositoryImpl implements TransactionListRepository {
  final TransactionRepository _transactions;
  final CaptureRepository _captures;
  final CaptureControlRepository _captureControl;

  const TransactionListRepositoryImpl(
    this._transactions,
    this._captures,
    this._captureControl,
  );

  @override
  Stream<List<TransactionWithCategory>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    TransactionType? type,
  }) {
    return _transactions.watchTransactions(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      type: type,
    );
  }

  @override
  Future<int> deleteTransaction(int id) =>
      _transactions.deleteTransaction(id);

  @override
  Stream<int> watchPendingCaptureCount() => _captures.watchPendingCount();

  @override
  Stream<bool> watchCaptureEnabled() =>
      _captureControl.watchMasterEnabled();
}
