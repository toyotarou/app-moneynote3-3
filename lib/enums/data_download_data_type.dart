enum DateDownloadDataType { none, money, bank, spend, bankName, spendItem }

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

      case DateDownloadDataType.bankName:
        return 'bankName';

      case DateDownloadDataType.spendItem:
        return 'spendItem';
    }
  }
}
