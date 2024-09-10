import 'package:isar/isar.dart';

import '../collections/bank_name.dart';

class BankNamesRepository {
  ///
  IsarCollection<BankName> getCollection({required Isar isar}) =>
      isar.bankNames;

  ///
  Future<BankName?> getBankName({required Isar isar, required int id}) async {
    final IsarCollection<BankName> bankNamesCollection =
        getCollection(isar: isar);
    return bankNamesCollection.get(id);
  }

  ///
  Future<List<BankName>?> getBankNameList({required Isar isar}) async {
    final IsarCollection<BankName> bankNamesCollection =
        getCollection(isar: isar);
    return bankNamesCollection.where().findAll();
  }

  ///
  Future<void> inputBankNameList(
      {required Isar isar, required List<BankName> bankNameList}) async {
    for (final BankName element in bankNameList) {
      inputBankName(isar: isar, bankName: element);
    }
  }

  ///
  Future<void> inputBankName(
      {required Isar isar, required BankName bankName}) async {
    final IsarCollection<BankName> bankNamesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => bankNamesCollection.put(bankName));
  }

  ///
  Future<void> updateBankName(
      {required Isar isar, required BankName bankName}) async {
    final IsarCollection<BankName> bankNamesCollection =
        getCollection(isar: isar);
    await bankNamesCollection.put(bankName);
  }

  ///
  Future<void> deleteBankName({required Isar isar, required int id}) async {
    final IsarCollection<BankName> bankNamesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => bankNamesCollection.delete(id));
  }
}
