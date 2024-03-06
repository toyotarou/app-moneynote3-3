import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../deposit_tab_alert.dart';
import 'money_dialog.dart';

// ignore: must_be_immutable
class BankEmoneyBlankMessage extends StatelessWidget {
  BankEmoneyBlankMessage({super.key, required this.deposit, this.index, required this.isar});

  final String deposit;
  int? index;
  final Isar isar;

  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$depositが設定されていません。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('必要であれば登録してください。'),
              GestureDetector(
                child: Text('登録', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                onTap: () => MoneyDialog(
                  context: context,
                  widget: (index != null) ? DepositTabAlert(index: 1, isar: isar) : DepositTabAlert(isar: isar),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
