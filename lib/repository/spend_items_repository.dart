import 'package:isar/isar.dart';

import '../collections/spend_item.dart';

class SpendItemsRepository {
  ///
  IsarCollection<SpendItem> getCollection({required Isar isar}) =>
      isar.spendItems;

  ///
  Future<SpendItem?> getSpendItem({required Isar isar, required int id}) async {
    final IsarCollection<SpendItem> spendItemsCollection =
        getCollection(isar: isar);
    return spendItemsCollection.get(id);
  }

  ///
  Future<List<SpendItem>?> getSpendItemList({required Isar isar}) async {
    final IsarCollection<SpendItem> spendItemsCollection =
        getCollection(isar: isar);
    return spendItemsCollection.where().sortByOrder().findAll();
  }

  ///
  Future<void> inputSpendItemList(
      {required Isar isar, required List<SpendItem> spendItemList}) async {
    for (final SpendItem element in spendItemList) {
      inputSpendItem(isar: isar, spendItem: element);
    }
  }

  ///
  Future<void> inputSpendItem(
      {required Isar isar, required SpendItem spendItem}) async {
    final IsarCollection<SpendItem> spendItemsCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => spendItemsCollection.put(spendItem));
  }

  ///
  Future<void> updateSpendItem(
      {required Isar isar, required SpendItem spendItem}) async {
    final IsarCollection<SpendItem> spendItemsCollection =
        getCollection(isar: isar);
    await spendItemsCollection.put(spendItem);
  }

  ///
  Future<void> deleteSpendItem({required Isar isar, required int id}) async {
    final IsarCollection<SpendItem> spendItemsCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => spendItemsCollection.delete(id));
  }
}
