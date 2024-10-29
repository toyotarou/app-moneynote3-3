import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/income.dart';
import '../../extensions/extensions.dart';
import '../../repository/incomes_repository.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../state/app_params/app_params_response_state.dart';
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
  final TextEditingController _incomePriceEditingController =
      TextEditingController();
  final TextEditingController _incomeSourceEditingController =
      TextEditingController();

  List<Income>? _incomeList = <Income>[];

  List<String> _yearList = <String>[];

  ///
  void _init() {
    _makeIncomeList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('収入履歴登録'),
                  Text(widget.date.yyyymm)
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                      onPressed: _insertIncome, child: const Text('入力する')),
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
    final String incomeInputDate = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.incomeInputDate));

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: 24,
              spreadRadius: 16,
              color: Colors.black.withOpacity(0.2)),
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
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _showDP,
                      child: Icon(Icons.calendar_month,
                          color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.screenSize.width / 6,
                      child: Text(incomeInputDate,
                          style: const TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _incomePriceEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '金額(10桁以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
                TextField(
                  controller: _incomeSourceEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '支払い元(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
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
    final DateTime? selectedDate = await showDatePicker(
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
      ref
          .read(appParamProvider.notifier)
          .setIncomeInputDate(date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _makeIncomeList() async {
    _yearList = <String>[];

    await IncomesRepository()
        .getIncomeList(isar: widget.isar)
        .then((List<Income>? value) {
      setState(() {
        _incomeList = value;

        if (value != null) {
          final Map<String, String> map = <String, String>{};
          for (final Income element in _incomeList!) {
            map[element.date.split('-')[0]] = '';
          }
          map.forEach((String key, String value) => _yearList.add(key));
        }
      });
    });
  }

  ///
  Widget _displayYearButton() {
    final String selectedIncomeYear = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.selectedIncomeYear));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async => ref
                .read(appParamProvider.notifier)
                .setSelectedIncomeYear(year: ''),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: (selectedIncomeYear == '')
                    ? Colors.yellowAccent.withOpacity(0.2)
                    : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.close, size: 14),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _yearList.map((String e) {
              return GestureDetector(
                onTap: () async => ref
                    .read(appParamProvider.notifier)
                    .setSelectedIncomeYear(year: e),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: (selectedIncomeYear == e)
                        ? Colors.yellowAccent.withOpacity(0.2)
                        : Colors.black,
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
    final List<Widget> list = <Widget>[];

    List<Income> icList = <Income>[];

    if (_incomeList!.isNotEmpty) {
      final String selectedIncomeYear = ref.watch(appParamProvider
          .select((AppParamsResponseState value) => value.selectedIncomeYear));

      if (selectedIncomeYear == '') {
        icList = _incomeList!;
      } else {
        for (final Income element in _incomeList!) {
          if (element.date.split('-')[0] == selectedIncomeYear) {
            icList.add(element);
          }
        }
      }
    }

    for (final Income element in icList) {
      list.add(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(element.date),
                  Text(element.price.toString().toCurrency()),
                ],
              ),
              Text(element.sourceName,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              GestureDetector(
                onTap: () async => _showDeleteDialog(id: element.id),
                child: Text(
                  'delete',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary),
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
  Future<void> _insertIncome() async {
    bool errFlg = false;

    if (_incomePriceEditingController.text.trim() == '' ||
        _incomeSourceEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_incomePriceEditingController.text.trim(), 10],
        <Object>[_incomeSourceEditingController.text.trim(), 30]
      ]) {
        if (!checkInputValueLengthCheck(
            value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '登録できません。',
            content: '値を正しく入力してください。'),
      );

      return;
    }

    final String incomeInputDate = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.incomeInputDate));

    final Income income = Income()
      ..date = incomeInputDate
      ..sourceName = _incomeSourceEditingController.text.trim()
      ..price = _incomePriceEditingController.text.trim().toInt();

    // ignore: always_specify_types
    await IncomesRepository()
        .inputIncome(isar: widget.isar, income: income)
        // ignore: always_specify_types
        .then((value) async {
      _incomeSourceEditingController.clear();
      _incomePriceEditingController.clear();

      ref.read(appParamProvider.notifier).setIncomeInputDate(date: '');
    });
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteIncome(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteIncome({required int id}) async =>
      // ignore: always_specify_types
      IncomesRepository()
          .deleteIncome(isar: widget.isar, id: id)
          // ignore: always_specify_types
          .then((value) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
}
