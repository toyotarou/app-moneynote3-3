import 'package:isar/isar.dart';

import '../collections/income.dart';

class IncomesRepository {
  ///
  IsarCollection<Income> getCollection({required Isar isar}) => isar.incomes;

  ///
  Future<List<Income>?> getIncomeList({required Isar isar}) async {
    final incomesCollection = getCollection(isar: isar);
    return incomesCollection.where().sortByDate().findAll();
  }

  ///
  Future<List<Income>?> getYearMonthIncomeList({required Isar isar, required Map<String, dynamic> param}) async {
    final incomesCollection = getCollection(isar: isar);
    return incomesCollection.filter().dateStartsWith('${param['year']}-${param['month']}').sortByDate().findAll();
  }

  ///
  Future<void> inputIncome({required Isar isar, required Income income}) async {
    final incomesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => incomesCollection.put(income));
  }

  ///
  Future<void> deleteIncome({required Isar isar, required int id}) async {
    final incomesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => incomesCollection.delete(id));
  }
}
