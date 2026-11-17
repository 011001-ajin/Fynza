import '../../features/auto_capture/domain/repositories/capture_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../shared/domain/repositories/transaction_entry_repository.dart';
import '../../shared/models/transaction_type.dart';

class TransactionEntryRepositoryImpl implements TransactionEntryRepository {
  final TransactionRepository _transactions;
  final CaptureRepository _captures;

  const TransactionEntryRepositoryImpl(this._transactions, this._captures);

  @override
  Future<void> saveTransaction({
    int? transactionId,
    int? captureIdToConfirm,
    required int amountCents,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
  }) async {
    final normalizedNote = note?.trim().isEmpty ?? true ? null : note!.trim();
    if (captureIdToConfirm != null) {
      await _captures.confirmCapture(
        captureIdToConfirm,
        categoryId: categoryId,
        note: normalizedNote,
        date: date,
        amountCents: amountCents,
        type: type,
      );
    } else if (transactionId != null) {
      await _transactions.updateTransaction(
        id: transactionId,
        amountCents: amountCents,
        type: type,
        categoryId: categoryId,
        date: date,
        note: normalizedNote,
      );
    } else {
      await _transactions.addTransaction(
        amountCents: amountCents,
        type: type,
        categoryId: categoryId,
        date: date,
        note: normalizedNote,
      );
    }
  }
}
