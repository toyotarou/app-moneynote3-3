import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../controllers/controllers_mixin.dart';
import '../../enums/account_type.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/bank_names_repository.dart';

import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

class BankNameInputAlert extends ConsumerStatefulWidget {
  const BankNameInputAlert({super.key, required this.depositType, required this.isar, this.bankName});

  final DepositType depositType;
  final Isar isar;
  final BankName? bankName;

  @override
  ConsumerState<BankNameInputAlert> createState() => _BankNameInputAlertState();
}

class _BankNameInputAlertState extends ConsumerState<BankNameInputAlert> with ControllersMixin<BankNameInputAlert> {
  final TextEditingController _bankNumberEditingController = TextEditingController();
  final TextEditingController _bankNameEditingController = TextEditingController();
  final TextEditingController _branchNumberEditingController = TextEditingController();
  final TextEditingController _branchNameEditingController = TextEditingController();
  final TextEditingController _accountNumberEditingController = TextEditingController();

  AccountType _selectedAccountType = AccountType.blank;

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    if (widget.bankName != null) {
      _bankNumberEditingController.text = widget.bankName!.bankNumber.trim();
      _bankNameEditingController.text = widget.bankName!.bankName.trim();
      _branchNumberEditingController.text = widget.bankName!.branchNumber.trim();
      _branchNameEditingController.text = widget.bankName!.branchName.trim();
      _accountNumberEditingController.text = widget.bankName!.accountNumber.trim();

      switch (widget.bankName!.accountType) {
        case '普通口座':
          _selectedAccountType = AccountType.normal;
        case '定期口座':
          _selectedAccountType = AccountType.fixed;
      }
    }

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  @override
  void dispose() {
    _bankNumberEditingController.dispose();
    _bankNameEditingController.dispose();
    _branchNumberEditingController.dispose();
    _branchNameEditingController.dispose();
    _accountNumberEditingController.dispose();

    super.dispose();
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
              const Text('金融機関追加'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),
                  if (widget.bankName != null)
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            switch (widget.bankName!.accountType) {
                              case '普通口座':
                                bankNamesNotifier.setAccountType(accountType: AccountType.normal);
                              case '定期口座':
                                bankNamesNotifier.setAccountType(accountType: AccountType.fixed);
                            }

                            _updateBankName();
                          },
                          child: Text(
                            '金融機関を更新する',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _showDeleteDialog,
                          child: Text('金融機関を削除する',
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    )
                  else
                    TextButton(
                      onPressed: _inputBankName,
                      child: const Text('金融機関を追加する', style: TextStyle(fontSize: 12)),
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
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _bankNumberEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '金融機関番号(4桁以内)',
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
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _bankNameEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '金融機関名(30文字以内)',
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        focusNode: focusNodeList[1],
                        onTap: () => context.showKeyboard(focusNodeList[1]),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _branchNumberEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '支店番号(3桁以内)',
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        focusNode: focusNodeList[2],
                        onTap: () => context.showKeyboard(focusNodeList[2]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _branchNameEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '支店名(30文字以内)',
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        focusNode: focusNodeList[3],
                        onTap: () => context.showKeyboard(focusNodeList[3]),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      // ignore: always_specify_types
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                        iconEnabledColor: Colors.white,
                        items: AccountType.values.map((AccountType e) {
                          // ignore: always_specify_types
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.japanName, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        value: (_selectedAccountType != AccountType.blank)
                            ? _selectedAccountType
                            : bankNamesState.accountType,
                        onChanged: (AccountType? value) {
                          bankNamesNotifier.setAccountType(accountType: value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _accountNumberEditingController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          hintText: '口座番号(7桁以内)',
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        focusNode: focusNodeList[4],
                        onTap: () => context.showKeyboard(focusNodeList[4]),
                      ),
                    ),
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
  Future<void> _inputBankName() async {
    bool errFlg = false;

    if (_bankNumberEditingController.text.trim() == '' ||
        _bankNameEditingController.text.trim() == '' ||
        _branchNumberEditingController.text.trim() == '' ||
        _branchNameEditingController.text.trim() == '' ||
        _accountNumberEditingController.text.trim() == '' ||
        (bankNamesState.accountType == AccountType.blank)) {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_bankNumberEditingController.text.trim(), 4],
        <Object>[_bankNameEditingController.text.trim(), 30],
        <Object>[_branchNumberEditingController.text.trim(), 3],
        <Object>[_branchNameEditingController.text.trim(), 30],
        <Object>[_accountNumberEditingController.text.trim(), 7]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int)) {
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

    final BankName bankName = BankName()
      ..bankNumber = _bankNumberEditingController.text.trim()
      ..bankName = _bankNameEditingController.text.trim()
      ..branchNumber = _branchNumberEditingController.text.trim()
      ..branchName = _branchNameEditingController.text.trim()
      ..accountType = bankNamesState.accountType.japanName
      ..accountNumber = _accountNumberEditingController.text.trim()
      ..depositType = widget.depositType.japanName;

    await BankNamesRepository()
        .inputBankName(isar: widget.isar, bankName: bankName)
        // ignore: always_specify_types
        .then((value) {
      _bankNumberEditingController.clear();
      _bankNameEditingController.clear();
      _branchNumberEditingController.clear();
      _branchNameEditingController.clear();
      _accountNumberEditingController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  ///
  Future<void> _updateBankName() async {
    bool errFlg = false;

    if (_bankNumberEditingController.text.trim() == '' ||
        _bankNameEditingController.text.trim() == '' ||
        _branchNumberEditingController.text.trim() == '' ||
        _branchNameEditingController.text.trim() == '' ||
        _accountNumberEditingController.text.trim() == '' ||
        (bankNamesState.accountType == AccountType.blank)) {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_bankNumberEditingController.text.trim(), 4],
        <Object>[_bankNameEditingController.text.trim(), 30],
        <Object>[_branchNumberEditingController.text.trim(), 3],
        <Object>[_branchNameEditingController.text.trim(), 30],
        <Object>[_accountNumberEditingController.text.trim(), 7]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int)) {
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
      await BankNamesRepository().getBankName(isar: widget.isar, id: widget.bankName!.id).then((BankName? value) async {
        value!
          ..bankNumber = _bankNumberEditingController.text.trim()
          ..bankName = _bankNameEditingController.text.trim()
          ..branchNumber = _branchNumberEditingController.text.trim()
          ..branchName = _branchNameEditingController.text.trim()
          ..accountType = bankNamesState.accountType.japanName
          ..accountNumber = _accountNumberEditingController.text.trim()
          ..depositType = widget.depositType.japanName;

        await BankNamesRepository()
            .updateBankName(isar: widget.isar, bankName: value)
            // ignore: always_specify_types
            .then((value) {
          _bankNumberEditingController.clear();
          _bankNameEditingController.clear();
          _branchNumberEditingController.clear();
          _branchNameEditingController.clear();
          _accountNumberEditingController.clear();

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
          _deleteBankName();

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
  Future<void> _deleteBankName() async => BankNamesRepository()
          .deleteBankName(isar: widget.isar, id: widget.bankName!.id)
          // ignore: always_specify_types
          .then((value) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
}
