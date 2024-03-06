import 'package:isar/isar.dart';

part 'bank_name.g.dart';

@collection
class BankName {
  Id id = Isar.autoIncrement;

  late String bankNumber;
  late String bankName;

  late String branchNumber;
  late String branchName;

  late String accountType;
  late String accountNumber;

  late String depositType;
}
