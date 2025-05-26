import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../deposit_tab_alert.dart';
import 'money_dialog.dart';

// ignore: must_be_immutable
class BankEmoneyBlankMessage extends StatefulWidget {
  BankEmoneyBlankMessage(
      {super.key, required this.deposit, this.index, required this.isar, required this.buttonLabelTextList});

  final String deposit;
  int? index;
  final Isar isar;
  final List<String> buttonLabelTextList;

  @override
  State<BankEmoneyBlankMessage> createState() => _BankEmoneyBlankMessageState();
}

class _BankEmoneyBlankMessageState extends State<BankEmoneyBlankMessage> {
  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${widget.deposit}が設定されていません。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('必要であれば登録してください。'),
              GestureDetector(
                child: Text('登録', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                onTap: () => MoneyDialog(
                  context: context,
                  widget: (widget.index != null)
                      ? DepositTabAlert(
                          index: 1,
                          isar: widget.isar,
                          buttonLabelTextList: widget.buttonLabelTextList,
                        )
                      : DepositTabAlert(
                          isar: widget.isar,
                          buttonLabelTextList: widget.buttonLabelTextList,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
