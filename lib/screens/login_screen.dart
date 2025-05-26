import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/config.dart';
import '../collections/login_account.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../repository/configs_repository.dart';
import '../repository/login_accounts_repository.dart';
import '../utilities/functions.dart';
import 'components/parts/custom_shape_clipper.dart';
import 'components/parts/error_dialog.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, required this.isar, this.mailAddress, this.password});

  final Isar isar;

  final String? mailAddress;
  final String? password;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with ControllersMixin<LoginScreen> {
  TextEditingController mailAddressEditingController = TextEditingController();

  TextEditingController passwordEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  List<LoginAccount>? loginAccountList = <LoginAccount>[];

  Map<String, String> loginAccountMap = <String, String>{};

  Map<String, String> configMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());

    _makeLoginAccountList();

    _makeConfigMap();

    if (widget.mailAddress != null && widget.password != null) {
      mailAddressEditingController.text = widget.mailAddress!;
      passwordEditingController.text = widget.password!;
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: context.screenSize.height * 0.9,
              width: context.screenSize.width * 0.9,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: const Color(0xFFFBB6CE).withOpacity(0.6),
              child: Text('■', style: TextStyle(color: Colors.white.withOpacity(0.1))),
            ),
          ),
          Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(width: context.screenSize.width),
                const SizedBox(height: 30),
                Container(
                  width: context.screenSize.width / 2.5,
                  height: 140,
                  decoration:
                      const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coinpig.png'))),
                ),
                Container(
                  width: context.screenSize.width / 2.5,
                  height: 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/moneynote_title.png'))),
                ),
                const SizedBox(height: 20),
                _displayInputParts(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    mailAddressEditingController.text = 'hide.toyoda@gmail.com';
                    passwordEditingController.text = 'hidechy4819';
                  },
                  child: const Text('hide'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        // ignore: inference_failure_on_instance_creation, always_specify_types
                        MaterialPageRoute(builder: (BuildContext context) => SignupScreen(isar: widget.isar)));
                  },
                  child: const Text('SIGN UP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                TextField(
                  controller: mailAddressEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'メールアドレス(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[0],
                  onTap: () => context.showKeyboard(focusNodeList[0]),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'パスワード(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[1],
                  onTap: () => context.showKeyboard(focusNodeList[1]),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeLoginAccountList() async {
    await LoginAccountsRepository().getLoginAccountList(isar: widget.isar).then(
      (List<LoginAccount>? value) {
        if (mounted) {
          setState(
            () {
              loginAccountList = value;

              if (value!.isNotEmpty) {
                for (final LoginAccount element in value) {
                  loginAccountMap[element.mailAddress] = element.password;
                }
              }
            },
          );
        }
      },
    );
  }

  ///
  Future<void> _makeConfigMap() async {
    await ConfigsRepository().getConfigList(isar: widget.isar).then(
      (List<Config>? value) {
        if (mounted) {
          setState(
            () {
              if (value!.isNotEmpty) {
                for (final Config element in value) {
                  configMap[element.configKey] = element.configValue;
                }
              }
            },
          );
        }
      },
    );
  }

  ///
  void _login() {
    bool errFlg = false;

    if (mailAddressEditingController.text.trim() == '' || passwordEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[mailAddressEditingController.text.trim(), 30],
        <Object>[passwordEditingController.text.trim(), 30],
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (loginAccountMap[mailAddressEditingController.text.trim()] != null) {
      if (passwordEditingController.text.trim() == loginAccountMap[mailAddressEditingController.text.trim()]) {
        Navigator.pushReplacement(
            context,
            // ignore: inference_failure_on_instance_creation, always_specify_types
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar, configMap: configMap)));
      } else {
        errFlg = true;
      }
    } else {
      errFlg = true;
    }

    if (errFlg) {
      // ignore: always_specify_types, use_build_context_synchronously
      Future.delayed(
          Duration.zero,
          // ignore: use_build_context_synchronously
          () => error_dialog(context: context, title: 'ログインできません。', content: '値を正しく入力してください。'));

      return;
    }
  }
}
