import 'package:isar/isar.dart';

part 'bank_price.g.dart';

@collection
class BankPrice {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;

  late String depositType;

  late int bankId;

  late int price;
}
