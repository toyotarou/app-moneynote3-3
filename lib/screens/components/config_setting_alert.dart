import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/config.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/configs_repository.dart';
import '../home_screen.dart';

class ConfigSettingAlert extends ConsumerStatefulWidget {
  const ConfigSettingAlert({super.key, required this.isar, this.baseYm});

  final Isar isar;
  final String? baseYm;

  @override
  ConsumerState<ConfigSettingAlert> createState() => _ConfigSettingAlertState();
}

class _ConfigSettingAlertState extends ConsumerState<ConfigSettingAlert> with ControllersMixin<ConfigSettingAlert> {
  Map<String, String> configMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    makeConfigMap();
  }

  ///
  Future<void> makeConfigMap() async {
    await ConfigsRepository().getConfigList(isar: widget.isar).then(
      (List<Config>? value) {
        setState(
          () {
            if (value!.isNotEmpty) {
              for (final Config element in value) {
                configMap[element.configKey] = element.configValue;

                if (element.configKey == 'useEasyLogin') {
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  appParamNotifier.setConfigUseEasyLoginFlag(flag: element.configValue == 'true' ? true : false);
                }

                if (element.configKey == 'useBankManage') {
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  appParamNotifier.setConfigUseBankManageFlag(flag: element.configValue == 'true' ? true : false);
                }

                if (element.configKey == 'useEmoneyManage') {
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  appParamNotifier.setConfigUseEmoneyManageFlag(flag: element.configValue == 'true' ? true : false);
                }
              }
            }
          },
        );
      },
    );
  }

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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () => (configMap.isNotEmpty) ? updateConfig() : inputConfig(),
                    child: Text((configMap.isNotEmpty) ? '更新' : '登録'),
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

  ///
  Future<void> inputConfig() async {
    final Map<String, String> map = <String, String>{};

    map['useEasyLogin'] = appParamState.configUseEasyLoginFlag.toString();
    map['useBankManage'] = appParamState.configUseBankManageFlag.toString();
    map['useEmoneyManage'] = appParamState.configUseEmoneyManageFlag.toString();

    map.forEach(
      (String key, String value) async {
        final Config config = Config()
          ..configKey = key
          ..configValue = value;

        await ConfigsRepository().inputConfig(isar: widget.isar, config: config);
      },
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation, always_specify_types
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(isar: widget.isar, baseYm: widget.baseYm),
        ),
      );
    }
  }

  ///
  Future<void> updateConfig() async {
    final Map<String, String> map = <String, String>{};

    map['useEasyLogin'] = appParamState.configUseEasyLoginFlag.toString();
    map['useBankManage'] = appParamState.configUseBankManageFlag.toString();
    map['useEmoneyManage'] = appParamState.configUseEmoneyManageFlag.toString();

    await widget.isar.writeTxn(
      () async {
        for (final MapEntry<String, String> entry in map.entries) {
          final Config? config = await ConfigsRepository().getConfigByKeyString(isar: widget.isar, key: entry.key);

          if (config != null) {
            config.configValue = entry.value;
            await ConfigsRepository().updateConfig(isar: widget.isar, config: config);
          }
        }
      },
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation, always_specify_types
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar, baseYm: widget.baseYm)),
      );
    }
  }
}
