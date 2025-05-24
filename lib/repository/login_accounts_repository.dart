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
