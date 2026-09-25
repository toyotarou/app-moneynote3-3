import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_items_repository.dart';
import '../../repository/spend_time_places_repository.dart';

import '../../utilities/functions.dart';
import '../../utilities/utilities.dart';

class SpendMonthlyListAlert extends ConsumerStatefulWidget {
  const SpendMonthlyListAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<SpendMonthlyListAlert> createState() => _SpendMonthlyListAlertState();
}

class _SpendMonthlyListAlertState extends ConsumerState<SpendMonthlyListAlert>
    with ControllersMixin<SpendMonthlyListAlert> {
  final Utility _utility = Utility();

  // ignore: use_late_for_private_fields_and_variables
  List<SpendTimePlace>? monthlySpendTimePlaceList = <SpendTimePlace>[];

  final Map<String, Map<String, int>> _monthlySpendTimePlaceMap = <String, Map<String, int>>{};

  Map<String, String> _holidayMap = <String, String>{};

  List<SpendItem>? _spendItemList = <SpendItem>[];

  late final IsarChangeWatcher _isarChangeWatcher;

  ///
  @override
  void initState() {
    super.initState();

    // 以前は build のたびに DB を読み直し → setState → build … を繰り返していた（表示中ずっと読み込みが走っていた）。
    // 最初に1回読み込み、以降は DB に変更があったときだけ読み直す
    _init();

    _isarChangeWatcher = IsarChangeWatcher(
      streams: <Stream<void>>[widget.isar.spendTimePlaces.watchLazy(), widget.isar.spendItems.watchLazy()],
      onChanged: _init,
    );
  }

  ///
  @override
  void dispose() {
    _isarChangeWatcher.dispose();

    super.dispose();
  }

  ///
  Future<void> _init() async {
    // 日別の集計に消費アイテム一覧を使うので、先に読み込む
    // （以前は並行して読んでいたため、最初は空の一覧で集計され、ループの2周目でようやく正しい値になっていた）
    await _makeSpendItemList();

    await _makeMonthlySpendTimePlaceList();
  }

  ///
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: const TextStyle(fontFamily: 'KiwiMaru', fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('月間使用用途履歴'), SizedBox.shrink()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayMonthlySpendItemPlaceList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeMonthlySpendTimePlaceList() async {
    final Map<String, dynamic> param = <String, dynamic>{};
    param['date'] = widget.date.yyyymm;

    await SpendTimePlacesRepository()
        .getDateSpendTimePlaceList(isar: widget.isar, param: param)
        .then((List<SpendTimePlace>? value) {
      if (!mounted) {
        return;
      }

      setState(() {
        monthlySpendTimePlaceList = value;

        // 以前は追記だけでクリアしていなかったため、削除した記録の値がアプリ再起動まで残っていた。
        _monthlySpendTimePlaceMap.clear();

        if (value!.isNotEmpty) {
          final Map<String, List<SpendTimePlace>> map = <String, List<SpendTimePlace>>{};
          value
            ..forEach((SpendTimePlace element) => map[element.date] = <SpendTimePlace>[])
            ..forEach((SpendTimePlace element) => map[element.date]?.add(element));

          map.forEach((String key, List<SpendTimePlace> value) => _monthlySpendTimePlaceMap[key] =
              makeMonthlySpendItemSumMap(spendTimePlaceList: value, spendItemList: _spendItemList));
        }
      });
    });
  }

  ///
  Widget _displayMonthlySpendItemPlaceList() {
    final List<Widget> list = <Widget>[];

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final Map<String, String> spendItemColorMap = <String, String>{};
    if (_spendItemList!.isNotEmpty) {
      for (final SpendItem element in _spendItemList!) {
        spendItemColorMap[element.spendItemName] = element.color;
      }
    }

    final int roopNum = DateTime(widget.date.year, widget.date.month + 1, 0).day;

    for (int i = 1; i <= roopNum; i++) {
      final String genDate =
          DateTime(widget.date.yyyymmdd.split('-')[0].toInt(), widget.date.yyyymmdd.split('-')[1].toInt(), i).yyyymmdd;

      int sum = 0;
      _monthlySpendTimePlaceMap[genDate]?.forEach((String key, int value) => sum += value);

      final List<Widget> list2 = <Widget>[];
      _monthlySpendTimePlaceMap[genDate]?.forEach((String key, int value) {
        final String? lineColor =
            (spendItemColorMap[key] != null && spendItemColorMap[key] != '') ? spendItemColorMap[key] : '0xffffffff';

        list2.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: DefaultTextStyle(
            style: TextStyle(color: Color(lineColor!.toInt()), fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(key), Text(value.toString().toCurrency())],
            ),
          ),
        ));
      });

      list.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  color: _utility.getYoubiColor(
                    date: DateTime.parse('$genDate 00:00:00').yyyymmdd,
                    youbiStr: DateTime.parse('$genDate 00:00:00').youbiStr,
                    holidayMap: _holidayMap,
                  ),
                ),
                child: (sum == 0)
                    ? Text(genDate)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(genDate), Text(sum.toString().toCurrency())],
                          ),
                          const SizedBox(height: 10),
                          Column(children: list2),
                        ],
                      ),
              ),
            ),
            if (sum == 0) const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Future<void> _makeSpendItemList() async => SpendItemsRepository()
      .getSpendItemList(isar: widget.isar)
      .then((List<SpendItem>? value) {
        if (mounted) {
          setState(() => _spendItemList = value);
        }
      });
}
