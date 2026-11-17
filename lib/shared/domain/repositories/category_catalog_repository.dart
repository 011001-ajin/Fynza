import '../../models/category.dart';
import '../../models/transaction_type.dart';

abstract interface class CategoryCatalogRepository {
  Stream<List<Category>> watchAllCategories();
  Stream<List<Category>> watchCategoriesByType({required bool isIncome});
  Stream<List<int>> watchRecentCategoryIds(TransactionType type);
}
