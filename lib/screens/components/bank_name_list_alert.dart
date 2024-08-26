// ignore_for_file: depend_on_referenced_packages

// import 'package:collection/collection.dart';
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/bank_names_repository.dart';
import 'bank_name_input_alert.dart';
import 'parts/money_dialog.dart';

class BankNameListAlert extends ConsumerStatefulWidget {
  const BankNameListAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<BankNameListAlert> createState() => _BankNameListAlertState();
}

class _BankNameListAlertState extends ConsumerState<BankNameListAlert> {
  // ignore: use_late_for_private_fields_and_variables
  List<BankName>? _bankNameList = [];

  ///
  @override
  Widget build(BuildContext context) {
    _makeBankNameList();

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
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(
                    onPressed: () => MoneyDialog(
                      context: context,
                      widget: BankNameInputAlert(
                          isar: widget.isar, depositType: DepositType.bank),
                    ),
                    child: const Text('金融機関を追加する'),
                  ),
                ],
              ),
              FutureBuilder<List<Widget>>(
                future: _displayBankNames(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(child: Column(children: snapshot.data!));
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeBankNameList() async => BankNamesRepository()
      .getBankNameList(isar: widget.isar)
      .then((value) => setState(() => _bankNameList = value));

  ///
  Future<List<Widget>> _displayBankNames() async {
    final list = <Widget>[];

    // _bankNameList!.mapIndexed((index, element) {
    //   list.add(
    //     Container(
    //       width: context.screenSize.width,
    //       margin: const EdgeInsets.all(3),
    //       padding: const EdgeInsets.all(3),
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Colors.white.withOpacity(0.4))),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   '${element.depositType}-${element.id}: ${element.bankName} (${element.bankNumber}) ',
    //                 ),
    //                 Text('${element.branchName} (${element.branchNumber})'),
    //                 Text('${element.accountType} ${element.accountNumber}'),
    //               ],
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               GestureDetector(
    //                 onTap: () => MoneyDialog(
    //                   context: context,
    //                   widget: BankNameInputAlert(
    //                       depositType: DepositType.bank,
    //                       isar: widget.isar,
    //                       bankName: element),
    //                 ),
    //                 child: Icon(Icons.edit,
    //                     size: 16, color: Colors.greenAccent.withOpacity(0.6)),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // });

    for (var i = 0; i < _bankNameList!.length; i++) {
      list.add(
        Container(
          width: context.screenSize.width,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.4))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_bankNameList![i].depositType}-${_bankNameList![i].id}: ${_bankNameList![i].bankName} (${_bankNameList![i].bankNumber}) ',
                    ),
                    Text(
                        '${_bankNameList![i].branchName} (${_bankNameList![i].branchNumber})'),
                    Text(
                        '${_bankNameList![i].accountType} ${_bankNameList![i].accountNumber}'),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => MoneyDialog(
                      context: context,
                      widget: BankNameInputAlert(
                          depositType: DepositType.bank,
                          isar: widget.isar,
                          bankName: _bankNameList![i]),
                    ),
                    child: Icon(Icons.edit,
                        size: 16, color: Colors.greenAccent.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }
}
