enum DateDownloadDataType { none, money, bank, spend }

extension DateDownloadDataTypeExtension on DateDownloadDataType {
  String get japanName {
    switch (this) {
      case DateDownloadDataType.none:
        return '';

      case DateDownloadDataType.money:
        return 'money';

      case DateDownloadDataType.bank:
        return 'bank';

      case DateDownloadDataType.spend:
        return 'spend';
    }
  }
}
