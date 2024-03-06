import 'package:isar/isar.dart';

part 'spend_time_place.g.dart';

@collection
class SpendTimePlace {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;

  late String spendType;
  late String time;
  late String place;
  late int price;
}
