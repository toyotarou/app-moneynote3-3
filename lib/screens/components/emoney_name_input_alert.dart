import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/emoney_name.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/emoney_names_repository.dart';
import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class EmoneyNameInputAlert extends ConsumerStatefulWidget {
  EmoneyNameInputAlert({super.key, required this.depositType, required this.isar, this.emoneyName});

  final DepositType depositType;
  final Isar isar;
  EmoneyName? emoneyName;

  @override
  ConsumerState<EmoneyNameInputAlert> createState() => _EmoneyNameInputAlertState();
}

class _EmoneyNameInputAlertState extends ConsumerState<EmoneyNameInputAlert> {
  final TextEditingController _emoneyNameEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    if (widget.emoneyName != null) {
      _emoneyNameEditingController.text = widget.emoneyName!.emoneyName.trim();
    }

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
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
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('電子マネー追加'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),
                  if (widget.emoneyName != null)
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _updateEmoneyName,
                          child: Text('電子マネーを更新する',
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _showDeleteDialog,
                          child: Text('電子マネーを削除する',
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    )
                  else
                    TextButton(
                      onPressed: _inputEmoneyName,
                      child: const Text('電子マネーを追加する', style: TextStyle(fontSize: 12)),
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
        boxShadow: <BoxShadow>[
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
              controller: _emoneyNameEditingController,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                hintText: '電子マネー名称(30文字以内)',
                filled: true,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              focusNode: focusNodeList[0],
              onTap: () => context.showKeyboard(focusNodeList[0]),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputEmoneyName() async {
    bool errFlg = false;

    if (_emoneyNameEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_emoneyNameEditingController.text.trim(), 30]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
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

    final EmoneyName emoneyName = EmoneyName()
      ..emoneyName = _emoneyNameEditingController.text.trim()
      ..depositType = widget.depositType.japanName;

    await EmoneyNamesRepository()
        .inputEmoneyName(isar: widget.isar, emoneyName: emoneyName)
        // ignore: always_specify_types
        .then((value) {
      _emoneyNameEditingController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  ///
  Future<void> _updateEmoneyName() async {
    bool errFlg = false;

    if (_emoneyNameEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_emoneyNameEditingController.text.trim(), 30]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
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

    await widget.isar.writeTxn(() async {
      await EmoneyNamesRepository()
          .getEmoneyName(isar: widget.isar, id: widget.emoneyName!.id)
          .then((EmoneyName? value) async {
        value!
          ..emoneyName = _emoneyNameEditingController.text.trim()
          ..depositType = widget.depositType.japanName;

        await EmoneyNamesRepository()
            .updateEmoneyName(isar: widget.isar, emoneyName: value)
            // ignore: always_specify_types
            .then((value) {
          _emoneyNameEditingController.clear();

          if (mounted) {
            Navigator.pop(context);
          }
        });
      });
    });
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteEmoneyName();

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
  Future<void> _deleteEmoneyName() async => EmoneyNamesRepository()
          .deleteEmoneyName(isar: widget.isar, id: widget.emoneyName!.id)
          // ignore: always_specify_types
          .then((value) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
}
