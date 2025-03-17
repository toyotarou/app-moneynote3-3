// ignore_for_file: depend_on_referenced_packages

// import 'package:collection/collection.dart';
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_items_repository.dart';
import '../../repository/spend_time_places_repository.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';
import 'parts/money_dialog.dart';
import 'spend_time_place_item_modify_alert.dart';

class SpendTimePlaceInputAlert extends ConsumerStatefulWidget {
  const SpendTimePlaceInputAlert({
    super.key,
    required this.date,
    required this.spend,
    required this.isar,
    this.spendTimePlaceList,
  });

  final DateTime date;
  final int spend;
  final Isar isar;
  final List<SpendTimePlace>? spendTimePlaceList;

  @override
  ConsumerState<SpendTimePlaceInputAlert> createState() => _SpendTimePlaceInputAlertState();
}

class _SpendTimePlaceInputAlertState extends ConsumerState<SpendTimePlaceInputAlert>
    with SingleTickerProviderStateMixin, ControllersMixin<SpendTimePlaceInputAlert> {
  late AnimationController _animationController;

  ///
  final DecorationTween _decorationTween = DecorationTween(
    begin: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.1)),
    end: BoxDecoration(color: Colors.yellowAccent.withOpacity(0.1)),
  );

  final List<TextEditingController> _placeTecs = <TextEditingController>[];
  final List<TextEditingController> _priceTecs = <TextEditingController>[];

  final List<String> _timeUnknownItem = <String>[];

  List<SpendItem>? _spendItemList = <SpendItem>[];

  ///
  @override
  void initState() {
    super.initState();

    try {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..repeat(reverse: true);

      _makeTecs();
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}

    _makeSpendItemList();
  }

  ///
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ///
  Future<void> _makeTecs() async {
    for (int i = 0; i < 20; i++) {
      _placeTecs.add(TextEditingController(text: ''));
      _priceTecs.add(TextEditingController(text: ''));
    }

    if (widget.spendTimePlaceList!.isNotEmpty) {
      // ignore: always_specify_types
      await Future(
        () => spendTimePlacesNotifier.setUpdateSpendTimePlace(
          updateSpendTimePlace: widget.spendTimePlaceList!,
          baseDiff: widget.spend,
        ),
      );

      // widget.spendTimePlaceList!.mapIndexed((index, element) {
      //   _placeTecs[index].text = element.place.trim();
      //
      //   _priceTecs[index].text = (element.price.toString().trim().toInt() > 0)
      //       ? element.price.toString().trim()
      //       : (element.price * -1).toString().trim();
      // });

      for (int i = 0; i < widget.spendTimePlaceList!.length; i++) {
        _placeTecs[i].text = widget.spendTimePlaceList![i].place.trim();

        _priceTecs[i].text = (widget.spendTimePlaceList![i].price.toString().trim().toInt() > 0)
            ? widget.spendTimePlaceList![i].price.toString().trim()
            : (widget.spendTimePlaceList![i].price * -1).toString().trim();
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(() => spendTimePlacesNotifier.setBaseDiff(baseDiff: widget.spend.toString()));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Text(widget.date.yyyymmdd),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text('Spend'),
                      const SizedBox(width: 10),
                      Text(
                        (spendTimePlacesControllerState.diff != 0)
                            ? spendTimePlacesControllerState.diff.toString().toCurrency()
                            : (spendTimePlacesControllerState.baseDiff == '')
                                ? ''
                                : spendTimePlacesControllerState.baseDiff.toCurrency(),
                        style: TextStyle(
                          color: (spendTimePlacesControllerState.diff == 0) ? Colors.yellowAccent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: appParamState.inputButtonClicked
                        ? null
                        : () {
                            appParamNotifier.setInputButtonClicked(flag: true);

                            _inputSpendTimePlace();
                          },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('input'),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: _displayInputParts()),
                      if (spendTimePlacesControllerState.blinkingFlag)
                        DecoratedBoxTransition(
                          decoration: _decorationTween.animate(_animationController),
                          child: SizedBox(
                            width: 90,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(color: Colors.black),
                              child: _spendItemSetPanel(),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: 90,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: _spendItemSetPanel(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < 20; i++) {
      final String item = spendTimePlacesControllerState.spendItem[i];
      final String time = spendTimePlacesControllerState.spendTime[i];
      final int price = spendTimePlacesControllerState.spendPrice[i];
      final String place = spendTimePlacesControllerState.spendPlace[i];

      list.add(
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2)),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5,
                right: 15,
                child: Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                ),
              ),
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (item != '項目名' && time != '時間' && price != 0 && place != '')
                        ? Colors.orangeAccent.withOpacity(0.4)
                        : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              spendTimePlacesNotifier.setBlinkingFlag(
                                  blinkingFlag: !spendTimePlacesControllerState.blinkingFlag);

                              spendTimePlacesNotifier.setItemPos(pos: i);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: (item != '項目名')
                                    ? Colors.yellowAccent.withOpacity(0.2)
                                    : const Color(0xFFfffacd).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(item),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showTP(pos: i),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (time != '時間')
                                    ? Colors.greenAccent.withOpacity(0.2)
                                    : const Color(0xFF90ee90).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(time, style: const TextStyle(fontSize: 10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _clearOneBox(pos: i),
                          child: const Icon(Icons.close, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => spendTimePlacesNotifier.setMinusCheck(pos: i),
                          child: Icon(
                            Icons.remove,
                            color: (spendTimePlacesControllerState.minusCheck[i]) ? Colors.redAccent : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _priceTecs[i],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              hintText: '金額(10桁以内)',
                              filled: true,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                            ),
                            style: const TextStyle(fontSize: 12),
                            onChanged: (String value) =>
                                spendTimePlacesNotifier.setSpendPrice(pos: i, price: (value == '') ? 0 : value.toInt()),
                            onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _placeTecs[i],
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        hintText: '場所(30文字以内)',
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                      ),
                      style: const TextStyle(fontSize: 12),
                      onChanged: (String value) => spendTimePlacesNotifier.setPlace(pos: i, place: value.trim()),
                      onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                    if (i < widget.spendTimePlaceList!.length) ...<Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox.shrink(),
                            GestureDetector(
                              onTap: () {
                                MoneyDialog(
                                  context: context,
                                  widget: SpendTimePlaceItemModifyAlert(
                                    isar: widget.isar,
                                    spendTimePlace: widget.spendTimePlaceList![i],
                                  ),
                                  clearBarrierColor: true,
                                );
                              },
                              child: Text(
                                'modify',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
  Widget _spendItemSetPanel() {
    return SingleChildScrollView(
      child: Column(
        children: (_spendItemList != null)
            ? _spendItemList!.map((SpendItem e) {
                return GestureDetector(
                  onTap: () {
                    spendTimePlacesNotifier.setBlinkingFlag(blinkingFlag: false);

                    spendTimePlacesNotifier.setSpendItem(
                        pos: spendTimePlacesControllerState.itemPos, item: e.spendItemName);

                    if (_timeUnknownItem.contains(e.spendItemName)) {
                      spendTimePlacesNotifier.setTime(pos: spendTimePlacesControllerState.itemPos, time: '00:00');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (spendTimePlacesControllerState.itemPos > -1 &&
                              e.spendItemName ==
                                  spendTimePlacesControllerState.spendItem[spendTimePlacesControllerState.itemPos])
                          ? Colors.yellowAccent.withOpacity(0.2)
                          : Colors.blueGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FittedBox(
                      child: Text(e.spendItemName, style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                );
              }).toList()
            : <Widget>[],
      ),
    );
  }

  ///
  Future<void> _showTP({required int pos}) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selectedTime != null) {
      final String time =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

      spendTimePlacesNotifier.setTime(pos: pos, time: time);
    }
  }

  ///
  Future<void> _clearOneBox({required int pos}) async {
    _priceTecs[pos].clear();
    _placeTecs[pos].clear();

    spendTimePlacesNotifier.clearOneBox(pos: pos);
  }

  ///
  Future<void> _inputSpendTimePlace() async {
    final List<SpendTimePlace> list = <SpendTimePlace>[];

    bool errFlg = false;

    ////////////////////////// 同数チェック
    int spendItemCount = 0;
    int spendTimeCount = 0;
    int spendPlaceCount = 0;
    int spendPriceCount = 0;
    ////////////////////////// 同数チェック

    for (int i = 0; i < 20; i++) {
      //===============================================
      if (spendTimePlacesControllerState.spendItem[i].trim() != '項目名' &&
          spendTimePlacesControllerState.spendTime[i].trim() != '時間' &&
          spendTimePlacesControllerState.spendPlace[i].trim() != '' &&
          spendTimePlacesControllerState.spendPrice[i].toString().trim() != '') {
        final int price = (spendTimePlacesControllerState.minusCheck[i])
            ? spendTimePlacesControllerState.spendPrice[i] * -1
            : spendTimePlacesControllerState.spendPrice[i];

        list.add(
          SpendTimePlace()
            ..date = widget.date.yyyymmdd
            ..spendType = spendTimePlacesControllerState.spendItem[i].trim()
            ..time = spendTimePlacesControllerState.spendTime[i].trim()
            ..price = price
            ..place = spendTimePlacesControllerState.spendPlace[i].trim(),
        );
      }
      //===============================================

      ////////////////////////// 同数チェック
      if (spendTimePlacesControllerState.spendItem[i] != '項目名') {
        spendItemCount++;
      }

      if (spendTimePlacesControllerState.spendTime[i] != '時間') {
        spendTimeCount++;
      }

      if (spendTimePlacesControllerState.spendPlace[i] != '') {
        spendPlaceCount++;
      }

      if (spendTimePlacesControllerState.spendPrice[i] != 0) {
        spendPriceCount++;
      }
      ////////////////////////// 同数チェック
    }

    if (list.isEmpty) {
      errFlg = true;
    }

    ////////////////////////// 同数チェック
    final Map<int, String> countCheck = <int, String>{};
    countCheck[spendItemCount] = '';
    countCheck[spendTimeCount] = '';
    countCheck[spendPlaceCount] = '';
    countCheck[spendPriceCount] = '';

    // 同数の場合、要素数は1になる
    if (countCheck.length > 1) {
      errFlg = true;
    }
    ////////////////////////// 同数チェック

    if (!errFlg) {
      for (final SpendTimePlace element in list) {
        for (final List<Object> element2 in <List<Object>>[
          <Object>[element.price.toString().trim(), 10],
          <Object>[element.place.trim(), 30]
        ]) {
          if (!checkInputValueLengthCheck(value: element2[0].toString().trim(), length: element2[1] as int)) {
            errFlg = true;
          }
        }
      }
    }

    final int diff = spendTimePlacesControllerState.diff;

    if (diff != 0 || errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '登録できません。',
            content: '値を正しく入力してください。'),
      );

      appParamNotifier.setInputButtonClicked(flag: false);

      return;
    }

    await SpendTimePlacesRepository()
        .deleteSpendTimePriceList(isar: widget.isar, spendTimePriceList: widget.spendTimePlaceList)
        // ignore: always_specify_types
        .then((value) async {
      await SpendTimePlacesRepository()
          .inputSpendTimePriceList(isar: widget.isar, spendTimePriceList: list)
          // ignore: always_specify_types
          .then((value2) async {
        await spendTimePlacesNotifier
            .clearInputValue()
            // ignore: always_specify_types
            .then((value3) async {
          if (mounted) {
            Navigator.pop(context);

            Navigator.pop(context);
          }
        });
      });
    });
  }

  ///
  Future<void> _makeSpendItemList() async {
    await SpendItemsRepository().getSpendItemList(isar: widget.isar).then((List<SpendItem>? value) {
      _spendItemList = value;

      if (value!.isNotEmpty) {
        for (final SpendItem element in value) {
          if (element.defaultTime != '') {
            final List<String> exDefaultTime = element.defaultTime.split(':');
            if (exDefaultTime[0].toInt() == 0) {
              _timeUnknownItem.add(element.spendItemName);
            }
          }
        }
      }
    });
  }
}
