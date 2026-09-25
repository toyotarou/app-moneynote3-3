import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../collections/money.dart';
import '../extensions/extensions.dart';

class MoneysRepository {
  ///
  IsarCollection<Money> getCollection({required Isar isar}) => isar.moneys;

  ///
  Future<Money?> getMoney({required Isar isar, required int id}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    return moneysCollection.get(id);
  }

  ///
  Future<List<Money>?> getMoneyList({required Isar isar}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    return moneysCollection.where().sortByDate().findAll();
  }

  ///
  Future<Money?> getDateMoney({required Isar isar, required Map<String, dynamic> param}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    // date にはユニークインデックスがあるので、全件走査の filter ではなくインデックス検索を使う
    return moneysCollection.where().dateEqualTo(param['date'] as String).findFirst();
  }

  ///
  Future<List<Money>?> getAfterDateMoneyList({required Isar isar, required String date}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    return moneysCollection
        .filter()
        .dateGreaterThan(
            DateTime(date.split('-')[0].toInt(), date.split('-')[1].toInt(), date.split('-')[2].toInt() - 1).yyyymmdd)
        .sortByDate()
        .findAll();
  }

  ///
  Future<void> inputMoneyList({required Isar isar, required List<Money> moneyList}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);

    // 1件ずつ（await せずに）トランザクションを開いていたのを、1トランザクションの一括登録にする。
    // date はユニークインデックスなので、従来どおり「既に登録済みの日付」「取り込みデータ内で重複した2件目以降」は登録しない
    // （以前はその分だけ put が失敗し、残りは登録されていた。まとめて putAll すると1件の重複で全件失敗するため事前に除外する）
    await isar.writeTxn(() async {
      final List<Money?> existing =
          await moneysCollection.getAllByDate(moneyList.map((Money e) => e.date).toList());

      final Set<String> usedDates = <String>{
        for (final Money? money in existing)
          if (money != null) money.date,
      };

      final List<Money> putList = <Money>[];

      for (final Money element in moneyList) {
        if (usedDates.add(element.date)) {
          putList.add(element);
        } else {
          debugPrint('inputMoneyList: ${element.date} は登録済みのためスキップしました');
        }
      }

      await moneysCollection.putAll(putList);
    });
  }

  ///
  Future<void> inputMoney({required Isar isar, required Money money}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => moneysCollection.put(money));
  }

  ///
  Future<void> updateMoney({required Isar isar, required Money money}) async {
    final IsarCollection<Money> moneysCollection = getCollection(isar: isar);
    await moneysCollection.put(money);
  }
}
