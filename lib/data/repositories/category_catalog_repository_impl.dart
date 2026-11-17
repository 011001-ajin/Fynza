import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../shared/domain/repositories/category_catalog_repository.dart';
import '../../shared/models/category.dart';
import '../../shared/models/transaction_type.dart';

class CategoryCatalogRepositoryImpl implements CategoryCatalogRepository {
  final CategoryRepository _categories;
  final TransactionRepository _transactions;

  const CategoryCatalogRepositoryImpl(this._categories, this._transactions);

  @override
  Stream<List<Category>> watchAllCategories() =>
      _categories.watchAllCategories();

  @override
  Stream<List<Category>> watchCategoriesByType({required bool isIncome}) =>
      _categories.watchCategoriesByType(isIncome: isIncome);

  @override
  Stream<List<int>> watchRecentCategoryIds(TransactionType type) {
    return _transactions.watchRecentTransactions(limit: 100).map((transactions) {
      final categoryIds = <int>[];
      for (final item in transactions) {
        if (item.transaction.type == type &&
            !categoryIds.contains(item.transaction.categoryId)) {
          categoryIds.add(item.transaction.categoryId);
        }
        if (categoryIds.length == 3) break;
      }
      return categoryIds;
    });
  }
}
