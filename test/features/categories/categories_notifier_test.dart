import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fynza/features/categories/domain/repositories/category_repository.dart';
import 'package:fynza/features/categories/presentation/view_models/categories_notifier.dart';
import 'package:fynza/shared/models/category.dart';

class FakeCategoryRepository implements CategoryRepository {
  final StreamController<List<Category>> controller =
      StreamController<List<Category>>.broadcast();
  final List<Category> added = [];
  int deletedId = -1;

  @override
  Stream<List<Category>> watchAllCategories() => controller.stream;

  @override
  Stream<List<Category>> watchCategoriesByType({required bool isIncome}) =>
      controller.stream;

  @override
  Future<List<Category>> getAllCategories() async => added;

  @override
  Future<Category?> getCategoryById(int id) async => null;

  @override
  Future<int> addCategory({
    required String name,
    required String icon,
    required int color,
    required bool isIncome,
  }) async {
    added.add(
      Category(
        id: added.length + 1,
        name: name,
        icon: icon,
        color: color,
        isIncome: isIncome,
      ),
    );
    return added.length;
  }

  @override
  Future<bool> updateCategory(Category category) async => true;

  @override
  Future<int> deleteCategory(int id) async {
    deletedId = id;
    return 1;
  }
}

void main() {
  test('tracks category stream and forwards category commands', () async {
    final repository = FakeCategoryRepository();
    final notifier = CategoriesNotifier(repository);
    const category = Category(
      id: 1,
      name: 'Food',
      icon: 'restaurant',
      color: 0xFFE65100,
      isIncome: false,
    );

    repository.controller.add([category]);
    await Future<void>.delayed(Duration.zero);
    expect(notifier.state.value, [category]);

    await notifier.addCategory(
      name: 'Travel',
      icon: 'directions_car',
      color: 0xFF123456,
      isIncome: false,
    );
    await notifier.deleteCategory(1);
    expect(repository.added.single.name, 'Travel');
    expect(repository.deletedId, 1);

    notifier.dispose();
    await repository.controller.close();
  });
}
