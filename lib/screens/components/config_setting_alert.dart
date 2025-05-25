import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

class ConfigSettingAlert extends ConsumerStatefulWidget {
  const ConfigSettingAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<ConfigSettingAlert> createState() => _ConfigSettingAlertState();
}

class _ConfigSettingAlertState extends ConsumerState<ConfigSettingAlert> with ControllersMixin<ConfigSettingAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('設定'),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('登録'),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('簡易ログイン機能を使用する'),
                            Switch(
                              value: appParamState.configUseEasyLoginFlag,
                              onChanged: (bool value) {
                                appParamNotifier.setConfigUseEasyLoginFlag(flag: !appParamState.configUseEasyLoginFlag);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('金融機関管理機能を使用する'),
                            Switch(
                              value: appParamState.configUseBankManageFlag,
                              onChanged: (bool value) {
                                appParamNotifier.setConfigUseBankManageFlag(
                                    flag: !appParamState.configUseBankManageFlag);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('電子マネー管理機能を使用する'),
                            Switch(
                              value: appParamState.configUseEmoneyManageFlag,
                              onChanged: (bool value) {
                                appParamNotifier.setConfigUseEmoneyManageFlag(
                                    flag: !appParamState.configUseEmoneyManageFlag);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
