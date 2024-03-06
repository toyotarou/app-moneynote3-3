import 'package:isar/isar.dart';

part 'income.g.dart';

@collection
class Income {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;

  late String sourceName;

  late int price;
}
