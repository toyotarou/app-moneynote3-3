import 'package:isar/isar.dart';

import '../collections/emoney_name.dart';

class EmoneyNamesRepository {
  ///
  IsarCollection<EmoneyName> getCollection({required Isar isar}) =>
      isar.emoneyNames;

  ///
  Future<EmoneyName?> getEmoneyName(
      {required Isar isar, required int id}) async {
    final IsarCollection<EmoneyName> emoneyNamesCollection =
        getCollection(isar: isar);
    return emoneyNamesCollection.get(id);
  }

  ///
  Future<List<EmoneyName>?> getEmoneyNameList({required Isar isar}) async {
    final IsarCollection<EmoneyName> emoneyNamesCollection =
        getCollection(isar: isar);
    return emoneyNamesCollection.where().findAll();
  }

  ///
  Future<void> inputEmoneyName(
      {required Isar isar, required EmoneyName emoneyName}) async {
    final IsarCollection<EmoneyName> emoneyNamesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => emoneyNamesCollection.put(emoneyName));
  }

  ///
  Future<void> updateEmoneyName(
      {required Isar isar, required EmoneyName emoneyName}) async {
    final IsarCollection<EmoneyName> emoneyNamesCollection =
        getCollection(isar: isar);
    await emoneyNamesCollection.put(emoneyName);
  }

  ///
  Future<void> deleteEmoneyName({required Isar isar, required int id}) async {
    final IsarCollection<EmoneyName> emoneyNamesCollection =
        getCollection(isar: isar);
    await isar.writeTxn(() async => emoneyNamesCollection.delete(id));
  }
}
