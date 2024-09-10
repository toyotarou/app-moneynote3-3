import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../../collections/bank_name.dart';
import '../../../collections/bank_price.dart';
import '../../../collections/emoney_name.dart';
import '../../../collections/income.dart';
import '../../../collections/money.dart';
import '../../../collections/spend_time_place.dart';
import '../../../extensions/extensions.dart';

class DummyDataInputAlert extends StatelessWidget {
  const DummyDataInputAlert({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    final List<BankName> barNameList = <BankName>[
      BankName()
        ..bankNumber = '0001'
        ..bankName = 'みずほ銀行'
        ..branchNumber = '046'
        ..branchName = '虎ノ門支店'
        ..accountType = '普通口座'
        ..accountNumber = '2961375'
        ..depositType = 'bank',
      BankName()
        ..bankNumber = '0009'
        ..bankName = '三井住友銀行'
        ..branchNumber = '547'
        ..branchName = '横浜駅前支店'
        ..accountType = '普通口座'
        ..accountNumber = '8981660'
        ..depositType = 'bank',
      BankName()
        ..bankNumber = '0009'
        ..bankName = '三井住友銀行'
        ..branchNumber = '259'
        ..branchName = '新宿西口支店'
        ..accountType = '普通口座'
        ..accountNumber = '2967733'
        ..depositType = 'bank',
      BankName()
        ..bankNumber = '0005'
        ..bankName = '三菱UFJ銀行'
        ..branchNumber = '271'
        ..branchName = '船橋支店'
        ..accountType = '普通口座'
        ..accountNumber = '0782619'
        ..depositType = 'bank',
      BankName()
        ..bankNumber = '0036'
        ..bankName = '楽天銀行'
        ..branchNumber = '226'
        ..branchName = 'ギター支店'
        ..accountType = '普通口座'
        ..accountNumber = '2994905'
        ..depositType = 'bank',
    ];

    final List<EmoneyName> emoneyNameList = <EmoneyName>[
      EmoneyName()
        ..emoneyName = 'Suica1'
        ..depositType = 'emoney',
      EmoneyName()
        ..emoneyName = 'PayPay'
        ..depositType = 'emoney',
      EmoneyName()
        ..emoneyName = 'PASMO'
        ..depositType = 'emoney',
      EmoneyName()
        ..emoneyName = 'Suica2'
        ..depositType = 'emoney',
      EmoneyName()
        ..emoneyName = 'メルカリ'
        ..depositType = 'emoney',
    ];

    final List<BankPrice> bankPriceList = <BankPrice>[
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'bank'
        ..bankId = 1
        ..price = 10000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'bank'
        ..bankId = 2
        ..price = 20000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'bank'
        ..bankId = 3
        ..price = 30000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'bank'
        ..bankId = 4
        ..price = 40000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'bank'
        ..bankId = 5
        ..price = 50000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'emoney'
        ..bankId = 1
        ..price = 10000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'emoney'
        ..bankId = 2
        ..price = 20000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'emoney'
        ..bankId = 3
        ..price = 30000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'emoney'
        ..bankId = 4
        ..price = 40000,
      BankPrice()
        ..date = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 3)
            .yyyymmdd
        ..depositType = 'emoney'
        ..bankId = 5
        ..price = 50000,
    ];

    final DateTime date1 = DateTime.now();
    final DateTime date2 = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    final DateTime date3 = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);

    final List<Money> moneyList = <Money>[
      Money()
        ..date = date1.yyyymmdd
        ..yen_10000 = 7
        ..yen_5000 = 7
        ..yen_2000 = 7
        ..yen_1000 = 7
        ..yen_500 = 7
        ..yen_100 = 7
        ..yen_50 = 7
        ..yen_10 = 7
        ..yen_5 = 7
        ..yen_1 = 7,
      Money()
        ..date = date2.yyyymmdd
        ..yen_10000 = 8
        ..yen_5000 = 8
        ..yen_2000 = 8
        ..yen_1000 = 8
        ..yen_500 = 8
        ..yen_100 = 8
        ..yen_50 = 8
        ..yen_10 = 8
        ..yen_5 = 8
        ..yen_1 = 8,
      Money()
        ..date = date3.yyyymmdd
        ..yen_10000 = 9
        ..yen_5000 = 9
        ..yen_2000 = 9
        ..yen_1000 = 9
        ..yen_500 = 9
        ..yen_100 = 9
        ..yen_50 = 9
        ..yen_10 = 9
        ..yen_5 = 9
        ..yen_1 = 9,
    ];

    final List<SpendTimePlace> spendTimePlaceList = <SpendTimePlace>[
      SpendTimePlace()
        ..date = date1.yyyymmdd
        ..spendType = '食費'
        ..time = '08:00'
        ..place = 'aaa'
        ..price = 100,
      SpendTimePlace()
        ..date = date1.yyyymmdd
        ..spendType = '交通費'
        ..time = '09:00'
        ..place = 'bbb'
        ..price = 200,
      SpendTimePlace()
        ..date = date1.yyyymmdd
        ..spendType = '支払い'
        ..time = '10:00'
        ..place = 'ccc'
        ..price = 300,
      SpendTimePlace()
        ..date = date2.yyyymmdd
        ..spendType = '食費'
        ..time = '08:00'
        ..place = 'aaa'
        ..price = 100,
      SpendTimePlace()
        ..date = date2.yyyymmdd
        ..spendType = '交通費'
        ..time = '09:00'
        ..place = 'bbb'
        ..price = 200,
      SpendTimePlace()
        ..date = date2.yyyymmdd
        ..spendType = '支払い'
        ..time = '10:00'
        ..place = 'ccc'
        ..price = 300,
      SpendTimePlace()
        ..date = date3.yyyymmdd
        ..spendType = '食費'
        ..time = '08:00'
        ..place = 'aaa'
        ..price = 100,
      SpendTimePlace()
        ..date = date3.yyyymmdd
        ..spendType = '交通費'
        ..time = '09:00'
        ..place = 'bbb'
        ..price = 200,
      SpendTimePlace()
        ..date = date3.yyyymmdd
        ..spendType = '支払い'
        ..time = '10:00'
        ..place = 'ccc'
        ..price = 300,
    ];

    final List<Income> incomeList = <Income>[
      Income()
        ..date = '2021-09-25'
        ..sourceName = 'aaaaa'
        ..price = 100000,
      Income()
        ..date = '2021-10-25'
        ..sourceName = 'bbbbb'
        ..price = 200000,
      Income()
        ..date = '2021-11-25'
        ..sourceName = 'ccccc'
        ..price = 300000,
      Income()
        ..date = '2022-09-25'
        ..sourceName = 'aaaaa'
        ..price = 100000,
      Income()
        ..date = '2022-10-25'
        ..sourceName = 'bbbbb'
        ..price = 200000,
      Income()
        ..date = '2022-11-25'
        ..sourceName = 'ccccc'
        ..price = 300000,
      Income()
        ..date = '2023-09-25'
        ..sourceName = 'aaaaa'
        ..price = 100000,
      Income()
        ..date = '2023-10-25'
        ..sourceName = 'bbbbb'
        ..price = 200000,
      Income()
        ..date = '2023-11-25'
        ..sourceName = 'ccccc'
        ..price = 300000,
      Income()
        ..date = '2023-12-25'
        ..sourceName = 'ddddd'
        ..price = 400000,
    ];

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: context.screenSize.width),
                ElevatedButton(
                  onPressed: () {
                    _inputBankNameMulti(bankNameList: barNameList);
                  },
                  child: const Text('BankName Multi'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () {
                    _inputEmoneyNameMulti(emoneyNameList: emoneyNameList);
                  },
                  child: const Text('EmoneyName Multi'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () {
                    _inputBankPriceMulti(bankPriceList: bankPriceList);
                  },
                  child: const Text('BankPrice Multi'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () {
                    _inputMoneyMulti(moneyList: moneyList);
                  },
                  child: const Text('Money Multi'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () {
                    _inputSpendTimePlaceMulti(
                        spendTimePlaceList: spendTimePlaceList);
                  },
                  child: const Text('SpendTimePlace Multi'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () {
                    _inputIncomeMulti(incomeList: incomeList);
                  },
                  child: const Text('Income Multi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputBankNameMulti(
      {required List<BankName> bankNameList}) async {
    await isar.writeTxn(() async {
      for (final BankName bankName in bankNameList) {
        await isar.bankNames.put(bankName);
      }
    });
  }

  ///
  Future<void> _inputEmoneyNameMulti(
      {required List<EmoneyName> emoneyNameList}) async {
    await isar.writeTxn(() async {
      for (final EmoneyName emoneyName in emoneyNameList) {
        await isar.emoneyNames.put(emoneyName);
      }
    });
  }

  ///
  Future<void> _inputBankPriceMulti(
      {required List<BankPrice> bankPriceList}) async {
    await isar.writeTxn(() async {
      for (final BankPrice bankPrice in bankPriceList) {
        await isar.bankPrices.put(bankPrice);
      }
    });
  }

  ///
  Future<void> _inputMoneyMulti({required List<Money> moneyList}) async {
    await isar.writeTxn(() async {
      for (final Money money in moneyList) {
        await isar.moneys.put(money);
      }
    });
  }

  ///
  Future<void> _inputSpendTimePlaceMulti(
      {required List<SpendTimePlace> spendTimePlaceList}) async {
    await isar.writeTxn(() async {
      for (final SpendTimePlace spendTimePlace in spendTimePlaceList) {
        await isar.spendTimePlaces.put(spendTimePlace);
      }
    });
  }

  ///
  Future<void> _inputIncomeMulti({required List<Income> incomeList}) async {
    await isar.writeTxn(() async {
      for (final Income income in incomeList) {
        await isar.incomes.put(income);
      }
    });
  }
}
