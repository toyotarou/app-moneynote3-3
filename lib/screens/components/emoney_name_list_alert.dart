// ignore_for_file: depend_on_referenced_packages

// import 'package:collection/collection.dart';
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/emoney_name.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/emoney_names_repository.dart';
import 'emoney_name_input_alert.dart';
import 'parts/money_dialog.dart';

// ignore: must_be_immutable
class EmoneyNameListAlert extends ConsumerStatefulWidget {
  const EmoneyNameListAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<EmoneyNameListAlert> createState() =>
      _EmoneyNameListAlertState();
}

class _EmoneyNameListAlertState extends ConsumerState<EmoneyNameListAlert> {
  // ignore: use_late_for_private_fields_and_variables
  List<EmoneyName>? _emoneyNameList = <EmoneyName>[];

  ///
  @override
  Widget build(BuildContext context) {
    _makeEmoneyNameList();

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
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                    onPressed: () => MoneyDialog(
                      context: context,
                      widget: EmoneyNameInputAlert(
                        depositType: DepositType.emoney,
                        isar: widget.isar,
                      ),
                    ),
                    child: const Text('電子マネーを追加する',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              FutureBuilder<List<Widget>>(
                future: _displayEmoneyNames(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Column(children: snapshot.data!),
                    );
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
  Future<void> _makeEmoneyNameList() async {
    await EmoneyNamesRepository().getEmoneyNameList(isar: widget.isar).then(
        (List<EmoneyName>? value) => setState(() => _emoneyNameList = value));
  }

  ///
  Future<List<Widget>> _displayEmoneyNames() async {
    final List<Widget> list = <Widget>[];

    // _emoneyNameList!.mapIndexed((index, element) {
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
    //             child: Text(
    //                 '${element.depositType}-${element.id}: ${element.emoneyName}'),
    //           ),
    //           Row(
    //             children: [
    //               GestureDetector(
    //                 onTap: () => MoneyDialog(
    //                   context: context,
    //                   widget: EmoneyNameInputAlert(
    //                     isar: widget.isar,
    //                     depositType: DepositType.emoney,
    //                     emoneyName: element,
    //                   ),
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

    for (int i = 0; i < _emoneyNameList!.length; i++) {
      list.add(
        Container(
          width: context.screenSize.width,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.4))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                    '${_emoneyNameList![i].depositType}-${_emoneyNameList![i].id}: ${_emoneyNameList![i].emoneyName}'),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => MoneyDialog(
                      context: context,
                      widget: EmoneyNameInputAlert(
                        isar: widget.isar,
                        depositType: DepositType.emoney,
                        emoneyName: _emoneyNameList![i],
                      ),
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
