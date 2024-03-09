import 'package:isar/isar.dart';

import '../collections/bank_name.dart';

class BankNamesRepository {
  ///
  IsarCollection<BankName> getCollection({required Isar isar}) => isar.bankNames;

  ///
  Future<BankName?> getBankName({required Isar isar, required int id}) async {
    final bankNamesCollection = getCollection(isar: isar);
    return bankNamesCollection.get(id);
  }

  ///
  Future<List<BankName>?> getBankNameList({required Isar isar}) async {
    final bankNamesCollection = getCollection(isar: isar);
    return bankNamesCollection.where().findAll();
  }

  ///
  Future<void> inputBankName({required Isar isar, required BankName bankName}) async {
    final bankNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => bankNamesCollection.put(bankName));
  }

  ///
  Future<void> updateBankName({required Isar isar, required BankName bankName}) async {
    final bankNamesCollection = getCollection(isar: isar);
    await bankNamesCollection.put(bankName);
  }

  ///
  Future<void> deleteBankName({required Isar isar, required int id}) async {
    final bankNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => bankNamesCollection.delete(id));
  }
}
