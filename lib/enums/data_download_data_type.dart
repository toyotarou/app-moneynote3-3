enum DateDownloadDataType { money, spend }

extension DateDownloadDataTypeExtension on DateDownloadDataType {
  String get japanName {
    switch (this) {
      case DateDownloadDataType.money:
        return 'money';
      case DateDownloadDataType.spend:
        return 'spend';
    }
  }
}
