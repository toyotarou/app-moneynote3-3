import 'package:isar/isar.dart';

part 'money.g.dart';

@collection
class Money {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String date;

  late int yen_10000;
  late int yen_5000;
  late int yen_2000;
  late int yen_1000;
  late int yen_500;
  late int yen_100;
  late int yen_50;
  late int yen_10;
  late int yen_5;
  late int yen_1;
}
