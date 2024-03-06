import 'package:isar/isar.dart';

part 'emoney_name.g.dart';

@collection
class EmoneyName {
  Id id = Isar.autoIncrement;

  late String emoneyName;

  late String depositType;
}
