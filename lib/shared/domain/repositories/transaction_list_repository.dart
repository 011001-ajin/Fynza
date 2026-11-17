import '../../models/transaction_with_category.dart';
import '../../models/transaction_type.dart';

abstract interface class TransactionListRepository {
  Stream<List<TransactionWithCategory>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    TransactionType? type,
  });

  Future<int> deleteTransaction(int id);
  Stream<int> watchPendingCaptureCount();
  Stream<bool> watchCaptureEnabled();
}
