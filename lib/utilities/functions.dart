import '../collections/bank_price.dart';
import '../collections/spend_item.dart';
import '../collections/spend_time_place.dart';
import '../extensions/extensions.dart';

///
Map<String, dynamic> makeBankPriceMap({required List<BankPrice> bankPriceList}) {
  final map2 = <String, List<BankPrice>>{};

  bankPriceList
    ..forEach((element) {
      map2['${element.depositType}-${element.bankId}'] = [];
    })
    ..forEach((element) {
      map2['${element.depositType}-${element.bankId}']?.add(element);
    });

  //=======================//

  final map3 = <String, Map<String, int>>{};

  if (bankPriceList.isNotEmpty) {
    //--- (1)
    final bplMap = <String, List<Map<String, int>>>{};

    bankPriceList
      ..forEach((element) {
        bplMap['${element.depositType}-${element.bankId}'] = [];
      })
      ..forEach((element) {
        bplMap['${element.depositType}-${element.bankId}']?.add({element.date: element.price});
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
    final dt = DateTime.parse('${bankPriceList[0].date} 00:00:00');

    final now = DateTime.now();

    final diff = now.difference(dt).inDays;

    bplMap.forEach((deposit, value) {
      final map4 = <String, int>{};

      var price = 0;
      for (var i = 0; i <= diff; i++) {
        final date = dt.add(Duration(days: i)).yyyymmdd;

        value.forEach((element) {
          if (element[date] != null) {
            price = element[date] ?? 0;
          }

          map4[date] = price;
        });
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

  final map4 = <String, int>{};

  final aaa = <String, List<int>>{};
  map3
    ..forEach((key, value) => value.forEach((key2, value2) => aaa[key2] = []))
    ..forEach((key, value) => value.forEach((key2, value2) => aaa[key2]?.add(value2)));

//print(aaa);
/*
flutter: {
2023-12-17: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-18: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-19: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000],
2023-12-20: [10000, 20000, 30000, 40000, 50000, 10000, 20000, 30000, 40000, 50000]}
*/

  aaa.forEach((key, value) {
    var sum = 0;
    value.forEach((element) => sum += element);
    map4[key] = sum;
  });

// print(map4);
/*
flutter: {2023-12-17: 300000, 2023-12-18: 300000, 2023-12-19: 300000, 2023-12-20: 300000}
*/

  /////////////////////////////////

  return {'bankPriceDatePadMap': map3, 'bankPriceTotalPadMap': map4};
}

///
Map<String, int> makeMonthlySpendItemSumMap(
    {required List<SpendTimePlace> spendTimePlaceList, List<SpendItem>? spendItemList}) {
  final monthlySpendItemSumMap = <String, int>{};

  final list = <String>[];

  if (spendItemList!.isNotEmpty) {
    spendItemList.forEach((element) => list.add(element.spendItemName));
  }

  final map = <String, List<int>>{};

  list.forEach((element) {
    final filtered = spendTimePlaceList.where((element2) => element2.spendType == element).toList();
    if (filtered.isNotEmpty) {
      filtered
        ..forEach((element3) => map[element3.spendType] = [])
        ..forEach((element3) => map[element3.spendType]?.add(element3.price));
    }
  });

  map.forEach((key, value) {
    var sum = 0;
    value.forEach((element) => sum += element);
    monthlySpendItemSumMap[key] = sum;
  });

  return monthlySpendItemSumMap;
}

///
Map<String, List<int>> makeYearlySpendItemSumMap(
    {required List<SpendTimePlace> spendTimePlaceList, List<SpendItem>? spendItemList}) {
  final list = <String>[];

  if (spendItemList!.isNotEmpty) {
    spendItemList.forEach((element) => list.add(element.spendItemName));
  }

  final map = <String, List<SpendTimePlace>>{};

  for (var i = 1; i <= 12; i++) {
    final list2 = <SpendTimePlace>[];

    spendTimePlaceList.forEach((element) {
      if (i.toString().padLeft(2, '0') == element.date.split('-')[1]) {
        list2.add(element);
      }
    });

    map[i.toString().padLeft(2, '0')] = list2;
  }

//  print(map['02']);

  final map2 = <String, Map<String, int>>{};

  map.forEach(
      (key, value) => map2[key] = makeMonthlySpendItemSumMap(spendTimePlaceList: value, spendItemList: spendItemList));

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

  final map3 = <String, List<int>>{};

  list.forEach((element) => map3[element] = []);

  for (var i = 1; i <= 12; i++) {
    list.forEach((element) => map3[element]?.add((map2[i.toString().padLeft(2, '0')]?[element] != null)
        ? '${map2[i.toString().padLeft(2, '0')]?[element]}'.toInt()
        : 0));
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
