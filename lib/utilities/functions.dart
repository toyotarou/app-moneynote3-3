import '../collections/bank_price.dart';
import '../collections/spend_item.dart';
import '../collections/spend_time_place.dart';
import '../extensions/extensions.dart';

///
Map<String, dynamic> makeBankPriceMap(
    {required List<BankPrice> bankPriceList}) {
  final Map<String, List<BankPrice>> map2 = <String, List<BankPrice>>{};

  bankPriceList
    ..forEach((BankPrice element) {
      map2['${element.depositType}-${element.bankId}'] = <BankPrice>[];
    })
    ..forEach((BankPrice element) {
      map2['${element.depositType}-${element.bankId}']?.add(element);
    });

  //=======================//

  final Map<String, Map<String, int>> map3 = <String, Map<String, int>>{};

  if (bankPriceList.isNotEmpty) {
    //--- (1)
    final Map<String, List<Map<String, int>>> bplMap =
        <String, List<Map<String, int>>>{};

    bankPriceList
      ..forEach((BankPrice element) {
        bplMap['${element.depositType}-${element.bankId}'] =
            <Map<String, int>>[];
      })
      ..forEach((BankPrice element) {
        bplMap['${element.depositType}-${element.bankId}']
            ?.add(<String, int>{element.date: element.price});
      });
    //--- (1)

//  print(bplMap);

/*

I/flutter ( 5443): {
bank-1: [{2023-12-11: 10000}, {2023-12-12: 11000}, {2023-12-13: 12000}],
bank-2: [{2023-12-11: 20000}, {2023-12-12: 22000}],
bank-3: [{2023-12-11: 30000}, {2023-12-13: 33000}],
bank-4: [{2023-12-11: 40000}, {2023-12-13: 44000}],
bank-5: [{2023-12-11: 50000}],

emoney-1: [{2023-12-11: 10000}],
emoney-2: [{2023-12-11: 20000}],
emoney-3: [{2023-12-11: 30000}],
emoney-4: [{2023-12-11: 40000}],
emoney-5: [{2023-12-11: 50000}]}

*/

    //--- (2)
    final DateTime dt = DateTime.parse('${bankPriceList[0].date} 00:00:00');

    final DateTime now = DateTime.now();

    final int diff = now.difference(dt).inDays;

    bplMap.forEach((String deposit, List<Map<String, int>> value) {
      final Map<String, int> map4 = <String, int>{};

      int price = 0;
      for (int i = 0; i <= diff; i++) {
        final String date = dt.add(Duration(days: i)).yyyymmdd;

        for (final Map<String, int> element in value) {
          if (element[date] != null) {
            price = element[date] ?? 0;
          }

          map4[date] = price;
        }
      }

      map3[deposit] = map4;
    });

    //--- (2)
  }

//print(map3);
  /*
    flutter: {
    bank-1: {2023-12-17: 10000, 2023-12-18: 10000, 2023-12-19: 10000, 2023-12-20: 10000},
    bank-2: {2023-12-17: 20000, 2023-12-18: 20000, 2023-12-19: 20000, 2023-12-20: 20000},
    bank-3: {2023-12-17: 30000, 2023-12-18: 30000, 2023-12-19: 30000, 2023-12-20: 30000},
    bank-4: {2023-12-17: 40000, 2023-12-18: 40000, 2023-12-19: 40000, 2023-12-20: 40000},
    bank-5: {2023-12-17: 50000, 2023-12-18: 50000, 2023-12-19: 50000, 2023-12-20: 50000},
    emoney-1: {2023-12-17: 10000, 2023-12-18: 10000, 2023-12-19: 10000, 2023-12-20: 10000},
    emoney-2: {2023-12-17: 20000, 2023-12-18: 20000, 2023-12-19: 20000, 2023-12-20: 20000},
    emoney-3: {2023-12-17: 30000, 2023-12-18: 30000, 2023-12-19: 30000, 2023-12-20: 30000},
    emoney-4: {2023-12-17: 40000, 2023-12-18: 40000, 2023-12-19: 40000, 2023-12-20: 40000},
    emoney-5: {2023-12-17: 50000, 2023-12-18: 50000, 2023-12-19: 50000, 2023-12-20: 50000}}
    */

  //=======================//

  /////////////////////////////////

  final Map<String, int> map4 = <String, int>{};

  final Map<String, List<int>> aaa = <String, List<int>>{};
  map3
    ..forEach((String key, Map<String, int> value) =>
        value.forEach((String key2, int value2) => aaa[key2] = <int>[]))
    ..forEach((String key, Map<String, int> value) =>
        value.forEach((String key2, int value2) => aaa[key2]?.add(value2)));

//print(aaa);
/*
flutter: {
2023-12-17: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-18: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-19: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-20: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000]}
*/

  aaa.forEach((String key, List<int> value) {
    int sum = 0;
    for (final int element in value) {
      sum += element;
    }
    map4[key] = sum;
  });

// print(map4);
/*
flutter: {2023-12-17: 300000, 2023-12-18: 300000, 2023-12-19: 300000, 2023-12-20: 300000}
*/

  /////////////////////////////////

  // ignore: always_specify_types
  return {'bankPriceDatePadMap': map3, 'bankPriceTotalPadMap': map4};
}

///
Map<String, int> makeMonthlySpendItemSumMap(
    {required List<SpendTimePlace> spendTimePlaceList,
    List<SpendItem>? spendItemList}) {
  final Map<String, int> monthlySpendItemSumMap = <String, int>{};

  final List<String> list = <String>[];

  if (spendItemList!.isNotEmpty) {
    for (final SpendItem element in spendItemList) {
      list.add(element.spendItemName);
    }
  }

  final Map<String, List<int>> map = <String, List<int>>{};

  for (final String element in list) {
    final List<SpendTimePlace> filtered = spendTimePlaceList
        .where((SpendTimePlace element2) => element2.spendType == element)
        .toList();
    if (filtered.isNotEmpty) {
      filtered
        ..forEach(
            (SpendTimePlace element3) => map[element3.spendType] = <int>[])
        ..forEach((SpendTimePlace element3) =>
            map[element3.spendType]?.add(element3.price));
    }
  }

  map.forEach((String key, List<int> value) {
    int sum = 0;
    for (final int element in value) {
      sum += element;
    }
    monthlySpendItemSumMap[key] = sum;
  });

  return monthlySpendItemSumMap;
}

///
Map<String, List<int>> makeYearlySpendItemSumMap(
    {required List<SpendTimePlace> spendTimePlaceList,
    List<SpendItem>? spendItemList}) {
  final List<String> list = <String>[];

  if (spendItemList!.isNotEmpty) {
    for (final SpendItem element in spendItemList) {
      list.add(element.spendItemName);
    }
  }

  final Map<String, List<SpendTimePlace>> map =
      <String, List<SpendTimePlace>>{};

  for (int i = 1; i <= 12; i++) {
    final List<SpendTimePlace> list2 = <SpendTimePlace>[];

    for (final SpendTimePlace element in spendTimePlaceList) {
      if (i.toString().padLeft(2, '0') == element.date.split('-')[1]) {
        list2.add(element);
      }
    }

    map[i.toString().padLeft(2, '0')] = list2;
  }

//  print(map['02']);

  final Map<String, Map<String, int>> map2 = <String, Map<String, int>>{};

  map.forEach((String key, List<SpendTimePlace> value) => map2[key] =
      makeMonthlySpendItemSumMap(
          spendTimePlaceList: value, spendItemList: spendItemList));

  /*

print(map2);

  I/flutter (26319): {

  01: {
  食費: 22216, 住居費: 134000, 交通費: 8814, クレジット: 179349, 遊興費: 2000, 趣味: 1320, 交際費: 6814, 雑費: 1642, 美容費: 2200, 通信費: 204, 保険料: 59667, 水道光熱費: 5314, 共済代: 3000, 投資: 43333, 手数料: 220, 税金: 201900, 国民年金基金: 26625, プラス: -14001, 収入: -650000, 支払い: 1600, 国民健康保険: 51100
  },
  02: {
  食費: 278, 交通費: 1727, 趣味: 765, 雑費: 744, 手数料: 154, 国民年金基金: 26625, 支払い: 16500
  }, 03: {}, 04: {}, 05: {}, 06: {}, 07: {}, 08: {}, 09: {}, 10: {}, 11: {}, 12: {}}

  */

  final Map<String, List<int>> map3 = <String, List<int>>{};

  for (final String element in list) {
    map3[element] = <int>[];
  }

  for (int i = 1; i <= 12; i++) {
    for (final String element in list) {
      map3[element]?.add((map2[i.toString().padLeft(2, '0')]?[element] != null)
          ? '${map2[i.toString().padLeft(2, '0')]?[element]}'.toInt()
          : 0);
    }
  }

  /*

  print(map3);

  I/flutter (26710): {
  食費: [22216, 278, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  住居費: [134000, 23100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  交通費: [8814, 1727, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],

  */

  return map3;
}

///
bool checkInputValueLengthCheck({required String value, required int length}) {
  return value.length <= length;
}
