import 'package:isar/isar.dart';

import '../collections/login_account.dart';

class LoginAccountsRepository {
  ///
  IsarCollection<LoginAccount> getCollection({required Isar isar}) => isar.loginAccounts;

  ///
  Future<LoginAccount?> getLoginAccount({required Isar isar, required String mailAddress}) async {
    final IsarCollection<LoginAccount> loginAccountsCollection = getCollection(isar: isar);
    return loginAccountsCollection.filter().mailAddressEqualTo(mailAddress).findFirst();
  }

  ///
  Future<List<LoginAccount>?> getLoginAccountList({required Isar isar}) async {
    final IsarCollection<LoginAccount> loginAccountsCollection = getCollection(isar: isar);
    return loginAccountsCollection.where().findAll();
  }

  ///
  Future<void> inputLoginAccountList({required Isar isar, required List<LoginAccount> loginAccountList}) async {
    // 1件ずつ（await せずに）トランザクションを開いていたのを、1トランザクションの一括登録にする
    final IsarCollection<LoginAccount> loginAccountsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => loginAccountsCollection.putAll(loginAccountList));
  }

  ///
  Future<void> inputLoginAccount({required Isar isar, required LoginAccount loginAccount}) async {
    final IsarCollection<LoginAccount> loginAccountsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => loginAccountsCollection.put(loginAccount));
  }

  ///
  Future<void> deleteLoginAccount({required Isar isar, required int id}) async {
    final IsarCollection<LoginAccount> loginAccountsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => loginAccountsCollection.delete(id));
  }
}
