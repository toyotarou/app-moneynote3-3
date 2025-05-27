import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/login_account.dart';
import '../../extensions/extensions.dart';
import '../../repository/login_accounts_repository.dart';
import '../login_screen.dart';

class LoginAccountDisplayAlert extends ConsumerStatefulWidget {
  const LoginAccountDisplayAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<LoginAccountDisplayAlert> createState() => _LoginAccountDisplayAlertState();
}

class _LoginAccountDisplayAlertState extends ConsumerState<LoginAccountDisplayAlert> {
  List<LoginAccount>? loginAccountList = <LoginAccount>[];

  Map<String, String> loginAccountMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    _makeLoginAccountList();
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('ログインアカウント管理'),
                  SizedBox.shrink(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(
                child: displayLoginAccountList(),
              ),
            ],
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
  Widget displayLoginAccountList() {
    final List<Widget> list = <Widget>[];

    loginAccountList?.forEach(
      (LoginAccount element) {
        list.add(
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(element.mailAddress),
                IconButton(
                  onPressed: () => _showDeleteDialog(id: element.id),
                  icon: Icon(Icons.delete, color: Colors.white.withValues(alpha: 0.3)),
                ),
              ],
            ),
          ),
        );
      },
    );

    return SingleChildScrollView(
      child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list)),
    );
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteLoginAccount(id: id);

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
  Future<void> _deleteLoginAccount({required int id}) async {
    LoginAccountsRepository().deleteLoginAccount(isar: widget.isar, id: id).then(
      // ignore: always_specify_types
      (value) {
        if (mounted) {
          Navigator.pushReplacement(
            context,

            // ignore: inference_failure_on_instance_creation, always_specify_types
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen(isar: widget.isar)),
          );
        }
      },
    );
  }
}
