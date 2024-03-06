import 'package:isar/isar.dart';

part 'spend_item.g.dart';

@collection
class SpendItem {
  Id id = Isar.autoIncrement;

  late String spendItemName;
}
