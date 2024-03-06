import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:money_note/collections/spend_time_place.dart';

import '../../collections/spend_item.dart';
import '../../extensions/extensions.dart';
import 'parts/error_dialog.dart';

class SpendItemInputAlert extends ConsumerStatefulWidget {
  const SpendItemInputAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<SpendItemInputAlert> createState() => _SpendItemInputAlertState();
}

class _SpendItemInputAlertState extends ConsumerState<SpendItemInputAlert> {
  final TextEditingController _spendItemEditingController = TextEditingController();

  List<SpendItem> _spendItemList = [];

  ///
  void _init() {
    _makeSpendItemList();
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
              const Text('消費アイテム管理'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(
                    onPressed: _inputSpendItem,
                    child: const Text('消費アイテムを追加する', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              Expanded(child: _displaySpendItemList()),
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
            child: TextField(
              controller: _spendItemEditingController,
              decoration: const InputDecoration(labelText: '消費アイテム'),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputSpendItem() async {
    if (_spendItemEditingController.text == '') {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    final spendItem = SpendItem()..spendItemName = _spendItemEditingController.text;

    await widget.isar.writeTxn(() async => widget.isar.spendItems.put(spendItem));

    _spendItemEditingController.clear();
  }

  ///
  Future<void> _makeSpendItemList() async {
    final spendItemsCollection = widget.isar.spendItems;

    final getSpendItems = await spendItemsCollection.where().findAll();

    setState(() => _spendItemList = getSpendItems);
  }

  ///
  Widget _displaySpendItemList() {
    final list = <Widget>[];

    final oneWidth = context.screenSize.width / 5;

    _spendItemList.forEach((element) {
      list.add(
        GestureDetector(
          onLongPress: () => _showDeleteDialog(id: element.id),
          child: Container(
            width: oneWidth,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.4))),
            alignment: Alignment.center,
            child: Text(element.spendItemName),
          ),
        ),
      );
    });

    return Wrap(children: list);
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteSpendItem(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: [cancelButton, continueButton],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteSpendItem({required int id}) async {
    final spendItemsCollection = widget.isar.spendItems;

    //-----------------------------------

    final getSpendItem = await spendItemsCollection.filter().idEqualTo(id).findFirst();

    if (getSpendItem != null) {
      final spendTimePlacesCollection = widget.isar.spendTimePlaces;

      final getSpendTimePlaces =
          await spendTimePlacesCollection.filter().spendTypeEqualTo(getSpendItem.spendItemName).findAll();

      await widget.isar.writeTxn(() async {
        getSpendTimePlaces.forEach((element) async {
          final spendTimePlace = element
            ..date = element.date
            ..time = element.time
            ..price = element.price
            ..place = element.place
            ..spendType = '';

          await widget.isar.spendTimePlaces.put(spendTimePlace);
        });
      });
    }

    //-----------------------------------

    await widget.isar.writeTxn(() async => spendItemsCollection.delete(id));
  }
}
