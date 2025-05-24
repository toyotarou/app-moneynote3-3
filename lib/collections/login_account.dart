import 'package:isar/isar.dart';

part 'login_account.g.dart';

@collection
class LoginAccount {
  Id id = Isar.autoIncrement;

  late String mailAddress;
  late String password;
}
