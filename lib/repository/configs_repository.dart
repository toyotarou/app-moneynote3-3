import 'package:isar/isar.dart';

import '../collections/config.dart';

class ConfigsRepository {
  ///
  IsarCollection<Config> getCollection({required Isar isar}) => isar.configs;

  ///
  Future<Config?> getConfigByKeyString({required Isar isar, required String key}) async {
    final IsarCollection<Config> configsCollection = getCollection(isar: isar);
    return configsCollection.filter().configKeyEqualTo(key).findFirst();
  }

  ///
  Future<List<Config>?> getConfigList({required Isar isar}) async {
    final IsarCollection<Config> configsCollection = getCollection(isar: isar);
    return configsCollection.where().findAll();
  }

  ///
  Future<void> inputConfigList({required Isar isar, required List<Config> configList}) async {
    for (final Config element in configList) {
      inputConfig(isar: isar, config: element);
    }
  }

  ///
  Future<void> inputConfig({required Isar isar, required Config config}) async {
    final IsarCollection<Config> configsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => configsCollection.put(config));
  }

  ///
  Future<void> updateConfig({required Isar isar, required Config config}) async {
    final IsarCollection<Config> configsCollection = getCollection(isar: isar);
    await configsCollection.put(config);
  }
}
