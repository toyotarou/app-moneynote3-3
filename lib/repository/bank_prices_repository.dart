import 'package:isar/isar.dart';

import '../collections/bank_price.dart';

class BankPricesRepository {
  ///
  IsarCollection<BankPrice> getCollection({required Isar isar}) =>
      isar.bankPrices;

  ///
  Future<List<BankPrice>?> getBankPriceList({required Isar isar}) async {
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);
    return bankPricesCollection.where().sortByDate().findAll();
  }

  ///
  Future<List<BankPrice>?> getSelectedBankPriceList(
      {required Isar isar, required Map<String, dynamic> param}) async {
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);

    return bankPricesCollection
        .filter()
        .depositTypeEqualTo(param['depositType'] as String)
        .bankIdEqualTo(param['bankId'] as int)
        .sortByDate()
        .findAll();
  }

  ///
  Future<void> inputBankPriceList(
      {required Isar isar, required List<BankPrice> bankPriceList}) async {
    // 1件ずつ（await せずに）トランザクションを開いていたのを、1トランザクションの一括登録にする
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => bankPricesCollection.putAll(bankPriceList));
  }

  ///
  Future<void> inputBankPrice(
      {required Isar isar, required BankPrice bankPrice}) async {
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => bankPricesCollection.put(bankPrice));
  }

  ///
  Future<void> deleteBankPriceList(
      {required Isar isar, required List<BankPrice> bankPriceList}) async {
    // 削除完了を待たずに戻っていたため、直後の登録と順序が入れ替わる恐れがあった。1トランザクションで一括削除する
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async =>
        bankPricesCollection.deleteAll(bankPriceList.map((BankPrice e) => e.id).toList()));
  }

  ///
  Future<void> deleteBankPrice({required Isar isar, required int id}) async {
    final IsarCollection<BankPrice> bankPricesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => bankPricesCollection.delete(id));
  }
}
