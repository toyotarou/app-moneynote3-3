import 'package:isar/isar.dart';

import '../collections/spend_item.dart';

class SpendItemsRepository {
  ///
  IsarCollection<SpendItem> getCollection({required Isar isar}) => isar.spendItems;

  ///
  Future<SpendItem?> getSpendItem({required Isar isar, required int id}) async {
    final spendItemsCollection = getCollection(isar: isar);
    return spendItemsCollection.get(id);
  }

  ///
  Future<List<SpendItem>?> getSpendItemList({required Isar isar}) async {
    final spendItemsCollection = getCollection(isar: isar);
    return spendItemsCollection.where().sortByOrder().findAll();
  }

  ///
  Future<void> inputSpendItem({required Isar isar, required SpendItem spendItem}) async {
    final spendItemsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => spendItemsCollection.put(spendItem));
  }

  ///
  Future<void> updateBankName({required Isar isar, required SpendItem spendItem}) async {
    final spendItemsCollection = getCollection(isar: isar);
    await spendItemsCollection.put(spendItem);
  }
}
