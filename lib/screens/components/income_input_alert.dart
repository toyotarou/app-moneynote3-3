import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/income.dart';
import '../../extensions/extensions.dart';
import '../../repository/incomes_repository.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

class IncomeInputAlert extends ConsumerStatefulWidget {
  const IncomeInputAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<IncomeInputAlert> createState() => _IncomeListAlertState();
}

class _IncomeListAlertState extends ConsumerState<IncomeInputAlert> {
  final TextEditingController _incomePriceEditingController = TextEditingController();
  final TextEditingController _incomeSourceEditingController = TextEditingController();

  List<Income>? _incomeList = [];

  List<String> _yearList = [];

  ///
  void _init() {
    _makeIncomeList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('収入履歴登録'), Text(widget.date.yyyymm)],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(onPressed: _insertIncome, child: const Text('入力する')),
                ],
              ),
              SizedBox(height: 40, child: _displayYearButton()),
              Expanded(child: _displayIncomeList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final incomeInputDate = ref.watch(appParamProvider.select((value) => value.incomeInputDate));

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showDP,
                      child: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.screenSize.width / 6,
                      child: Text(incomeInputDate, style: const TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _incomePriceEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '金額(10桁以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                TextField(
                  controller: _incomeSourceEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '支払い元(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _showDP() async {
    final selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime(widget.date.year, widget.date.month),
      firstDate: DateTime(widget.date.year, widget.date.month),
      lastDate: DateTime(widget.date.year, widget.date.month + 1, 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      await ref.read(appParamProvider.notifier).setIncomeInputDate(date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _makeIncomeList() async {
    _yearList = [];

    await IncomesRepository().getIncomeList(isar: widget.isar).then((value) {
      setState(() {
        _incomeList = value;

        if (value != null) {
          final map = <String, String>{};
          _incomeList!.forEach((element) => map[element.date.split('-')[0]] = '');
          map.forEach((key, value) => _yearList.add(key));
        }
      });
    });
  }

  ///
  Widget _displayYearButton() {
    final selectedIncomeYear = ref.watch(appParamProvider.select((value) => value.selectedIncomeYear));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async => ref.read(appParamProvider.notifier).setSelectedIncomeYear(year: ''),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: (selectedIncomeYear == '') ? Colors.yellowAccent.withOpacity(0.2) : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.close, size: 14),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _yearList.map((e) {
              return GestureDetector(
                onTap: () async => ref.read(appParamProvider.notifier).setSelectedIncomeYear(year: e),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: (selectedIncomeYear == e) ? Colors.yellowAccent.withOpacity(0.2) : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  ///
  Widget _displayIncomeList() {
    final list = <Widget>[];

    var icList = <Income>[];

    if (_incomeList!.isNotEmpty) {
      final selectedIncomeYear = ref.watch(appParamProvider.select((value) => value.selectedIncomeYear));

      if (selectedIncomeYear == '') {
        icList = _incomeList!;
      } else {
        _incomeList!.forEach((element) {
          if (element.date.split('-')[0] == selectedIncomeYear) {
            icList.add(element);
          }
        });
      }
    }

    icList.forEach((element) {
      list.add(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element.date),
                  Text(element.price.toString().toCurrency()),
                ],
              ),
              Text(element.sourceName, maxLines: 1, overflow: TextOverflow.ellipsis),
              GestureDetector(
                onTap: () async => _showDeleteDialog(id: element.id),
                child: Text(
                  'delete',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Future<void> _insertIncome() async {
    var errFlg = false;

    if (_incomePriceEditingController.text.trim() == '' || _incomeSourceEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (errFlg == false) {
      [
        [_incomePriceEditingController.text.trim(), 10],
        [_incomeSourceEditingController.text.trim(), 30]
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

    final incomeInputDate = ref.watch(appParamProvider.select((value) => value.incomeInputDate));

    final income = Income()
      ..date = incomeInputDate
      ..sourceName = _incomeSourceEditingController.text.trim()
      ..price = _incomePriceEditingController.text.trim().toInt();

    await IncomesRepository().inputIncome(isar: widget.isar, income: income).then((value) async {
      _incomeSourceEditingController.clear();
      _incomePriceEditingController.clear();

      await ref.read(appParamProvider.notifier).setIncomeInputDate(date: '');
    });
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteIncome(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: [cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteIncome({required int id}) async =>
      IncomesRepository().deleteIncome(isar: widget.isar, id: id).then((value) => Navigator.pop(context));
}
