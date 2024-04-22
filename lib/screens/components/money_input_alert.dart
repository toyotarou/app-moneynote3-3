import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/money.dart';
import '../../extensions/extensions.dart';
import '../../repository/moneys_repository.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class MoneyInputAlert extends ConsumerStatefulWidget {
  MoneyInputAlert({super.key, required this.date, required this.isar, this.onedayMoneyList, this.beforedayMoneyList});

  final DateTime date;
  final Isar isar;

  List<Money>? onedayMoneyList;
  List<Money>? beforedayMoneyList;

  @override
  ConsumerState<MoneyInputAlert> createState() => _MoneyInputAlertState();
}

class _MoneyInputAlertState extends ConsumerState<MoneyInputAlert> {
  final TextEditingController _tecYen10000 = TextEditingController();
  final TextEditingController _tecYen5000 = TextEditingController();
  final TextEditingController _tecYen2000 = TextEditingController();
  final TextEditingController _tecYen1000 = TextEditingController();
  final TextEditingController _tecYen500 = TextEditingController();
  final TextEditingController _tecYen100 = TextEditingController();
  final TextEditingController _tecYen50 = TextEditingController();
  final TextEditingController _tecYen10 = TextEditingController();
  final TextEditingController _tecYen5 = TextEditingController();
  final TextEditingController _tecYen1 = TextEditingController();

  ///
  @override
  void initState() {
    super.initState();

    if (widget.onedayMoneyList!.isNotEmpty) {
      _tecYen10000.text = widget.onedayMoneyList![0].yen_10000.toString();
      _tecYen5000.text = widget.onedayMoneyList![0].yen_5000.toString();
      _tecYen2000.text = widget.onedayMoneyList![0].yen_2000.toString();
      _tecYen1000.text = widget.onedayMoneyList![0].yen_1000.toString();
      _tecYen500.text = widget.onedayMoneyList![0].yen_500.toString();
      _tecYen100.text = widget.onedayMoneyList![0].yen_100.toString();
      _tecYen50.text = widget.onedayMoneyList![0].yen_50.toString();
      _tecYen10.text = widget.onedayMoneyList![0].yen_10.toString();
      _tecYen5.text = widget.onedayMoneyList![0].yen_5.toString();
      _tecYen1.text = widget.onedayMoneyList![0].yen_1.toString();
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Text(widget.date.yyyymmdd),
              Divider(
                color: Colors.white.withOpacity(0.4),
                thickness: 5,
              ),
              _displayInputParts(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _callBeforeDateData,
                    child: Text('前日データ呼び出し', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                  ),
                  (widget.onedayMoneyList!.isNotEmpty)
                      ? GestureDetector(
                          onTap: _updateMoney,
                          child: Text('マネーデータを更新する', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                        )
                      : GestureDetector(
                          onTap: _insertMoney,
                          child: Text('マネーデータを追加する', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _displayInputTextFieldParts(name: '10000', tec: _tecYen10000)),
                    Expanded(child: _displayInputTextFieldParts(name: '5000', tec: _tecYen5000)),
                    Expanded(child: _displayInputTextFieldParts(name: '2000', tec: _tecYen2000)),
                    Expanded(child: _displayInputTextFieldParts(name: '1000', tec: _tecYen1000)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _displayInputTextFieldParts(name: '500', tec: _tecYen500)),
                    Expanded(child: _displayInputTextFieldParts(name: '100', tec: _tecYen100)),
                    Expanded(child: _displayInputTextFieldParts(name: '50', tec: _tecYen50)),
                    Expanded(child: Container()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _displayInputTextFieldParts(name: '10', tec: _tecYen10)),
                    Expanded(child: _displayInputTextFieldParts(name: '5', tec: _tecYen5)),
                    Expanded(child: _displayInputTextFieldParts(name: '1', tec: _tecYen1)),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputTextFieldParts({required String name, required TextEditingController tec}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: tec,
        decoration: InputDecoration(labelText: name),
        style: const TextStyle(fontSize: 13, color: Colors.white),
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }

  ///
  Future<void> _insertMoney() async {
    var errFlg = false;

    if (_tecYen10000.text == '' ||
        _tecYen5000.text == '' ||
        _tecYen2000.text == '' ||
        _tecYen1000.text == '' ||
        _tecYen500.text == '' ||
        _tecYen100.text == '' ||
        _tecYen50.text == '' ||
        _tecYen10.text == '' ||
        _tecYen5.text == '' ||
        _tecYen1.text == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_tecYen10000.text, 3],
        [_tecYen5000.text, 3],
        [_tecYen2000.text, 3],
        [_tecYen1000.text, 3],
        [_tecYen500.text, 3],
        [_tecYen100.text, 3],
        [_tecYen50.text, 3],
        [_tecYen10.text, 3],
        [_tecYen5.text, 3],
        [_tecYen1.text, 3],
      ].forEach((element) {
        if (checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int) == false) {
          errFlg = true;
        }
      });
    }

    if (errFlg) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    final money = Money()
      ..date = widget.date.yyyymmdd
      ..yen_10000 = (_tecYen10000.text == '') ? 0 : _tecYen10000.text.toInt()
      ..yen_5000 = (_tecYen5000.text == '') ? 0 : _tecYen5000.text.toInt()
      ..yen_2000 = (_tecYen2000.text == '') ? 0 : _tecYen2000.text.toInt()
      ..yen_1000 = (_tecYen1000.text == '') ? 0 : _tecYen1000.text.toInt()
      ..yen_500 = (_tecYen500.text == '') ? 0 : _tecYen500.text.toInt()
      ..yen_100 = (_tecYen100.text == '') ? 0 : _tecYen100.text.toInt()
      ..yen_50 = (_tecYen50.text == '') ? 0 : _tecYen50.text.toInt()
      ..yen_10 = (_tecYen10.text == '') ? 0 : _tecYen10.text.toInt()
      ..yen_5 = (_tecYen5.text == '') ? 0 : _tecYen5.text.toInt()
      ..yen_1 = (_tecYen1.text == '') ? 0 : _tecYen1.text.toInt();

    await MoneysRepository().inputMoney(isar: widget.isar, money: money).then((value) {
      _tecYen10000.clear();
      _tecYen5000.clear();
      _tecYen2000.clear();
      _tecYen1000.clear();
      _tecYen500.clear();
      _tecYen100.clear();
      _tecYen50.clear();
      _tecYen10.clear();
      _tecYen5.clear();
      _tecYen1.clear();

      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  ///
  Future<void> _updateMoney() async {
    var errFlg = false;

    if (_tecYen10000.text == '' ||
        _tecYen5000.text == '' ||
        _tecYen2000.text == '' ||
        _tecYen1000.text == '' ||
        _tecYen500.text == '' ||
        _tecYen100.text == '' ||
        _tecYen50.text == '' ||
        _tecYen10.text == '' ||
        _tecYen5.text == '' ||
        _tecYen1.text == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_tecYen10000.text, 3],
        [_tecYen5000.text, 3],
        [_tecYen2000.text, 3],
        [_tecYen1000.text, 3],
        [_tecYen500.text, 3],
        [_tecYen100.text, 3],
        [_tecYen50.text, 3],
        [_tecYen10.text, 3],
        [_tecYen5.text, 3],
        [_tecYen1.text, 3],
      ].forEach((element) {
        if (checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int) == false) {
          errFlg = true;
        }
      });
    }

    if (errFlg) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    await widget.isar.writeTxn(() async {
      await MoneysRepository().getMoney(isar: widget.isar, id: widget.onedayMoneyList![0].id).then((value) async {
        value!
          ..date = widget.date.yyyymmdd
          ..yen_10000 = (_tecYen10000.text == '') ? 0 : _tecYen10000.text.toInt()
          ..yen_5000 = (_tecYen5000.text == '') ? 0 : _tecYen5000.text.toInt()
          ..yen_2000 = (_tecYen2000.text == '') ? 0 : _tecYen2000.text.toInt()
          ..yen_1000 = (_tecYen1000.text == '') ? 0 : _tecYen1000.text.toInt()
          ..yen_500 = (_tecYen500.text == '') ? 0 : _tecYen500.text.toInt()
          ..yen_100 = (_tecYen100.text == '') ? 0 : _tecYen100.text.toInt()
          ..yen_50 = (_tecYen50.text == '') ? 0 : _tecYen50.text.toInt()
          ..yen_10 = (_tecYen10.text == '') ? 0 : _tecYen10.text.toInt()
          ..yen_5 = (_tecYen5.text == '') ? 0 : _tecYen5.text.toInt()
          ..yen_1 = (_tecYen1.text == '') ? 0 : _tecYen1.text.toInt();

        await MoneysRepository().updateMoney(isar: widget.isar, money: value).then((value) {
          _tecYen10000.clear();
          _tecYen5000.clear();
          _tecYen2000.clear();
          _tecYen1000.clear();
          _tecYen500.clear();
          _tecYen100.clear();
          _tecYen50.clear();
          _tecYen10.clear();
          _tecYen5.clear();
          _tecYen1.clear();

          Navigator.pop(context);
        });
      });
    });
  }

  ///
  Future<void> _callBeforeDateData() async {
    if (widget.beforedayMoneyList!.isNotEmpty) {
      _tecYen10000.text = widget.beforedayMoneyList![0].yen_10000.toString();
      _tecYen5000.text = widget.beforedayMoneyList![0].yen_5000.toString();
      _tecYen2000.text = widget.beforedayMoneyList![0].yen_2000.toString();
      _tecYen1000.text = widget.beforedayMoneyList![0].yen_1000.toString();
      _tecYen500.text = widget.beforedayMoneyList![0].yen_500.toString();
      _tecYen100.text = widget.beforedayMoneyList![0].yen_100.toString();
      _tecYen50.text = widget.beforedayMoneyList![0].yen_50.toString();
      _tecYen10.text = widget.beforedayMoneyList![0].yen_10.toString();
      _tecYen5.text = widget.beforedayMoneyList![0].yen_5.toString();
      _tecYen1.text = widget.beforedayMoneyList![0].yen_1.toString();
    }
  }
}
