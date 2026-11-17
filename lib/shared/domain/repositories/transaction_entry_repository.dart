import '../../models/transaction_type.dart';

abstract interface class TransactionEntryRepository {
  Future<void> saveTransaction({
    int? transactionId,
    int? captureIdToConfirm,
    required int amountCents,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
  });
}
