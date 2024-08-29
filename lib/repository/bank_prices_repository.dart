import 'package:isar/isar.dart';

import '../collections/bank_price.dart';

class BankPricesRepository {
  ///
  IsarCollection<BankPrice> getCollection({required Isar isar}) =>
      isar.bankPrices;

  ///
  Future<List<BankPrice>?> getBankPriceList({required Isar isar}) async {
    final bankPricesCollection = getCollection(isar: isar);
    return bankPricesCollection.where().sortByDate().findAll();
  }

  ///
  Future<List<BankPrice>?> getSelectedBankPriceList(
      {required Isar isar, required Map<String, dynamic> param}) async {
    final bankPricesCollection = getCollection(isar: isar);

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
    for (final element in bankPriceList) {
      inputBankPrice(isar: isar, bankPrice: element);
    }
  }

  ///
  Future<void> inputBankPrice(
      {required Isar isar, required BankPrice bankPrice}) async {
    final bankPricesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => bankPricesCollection.put(bankPrice));
  }

  ///
  Future<void> deleteBankPriceList(
      {required Isar isar, required List<BankPrice> bankPriceList}) async {
    for (final element in bankPriceList) {
      deleteBankPrice(isar: isar, id: element.id);
    }
  }

  ///
  Future<void> deleteBankPrice({required Isar isar, required int id}) async {
    final bankPricesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => bankPricesCollection.delete(id));
  }
}
