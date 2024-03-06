enum DepositType { bank, emoney }

extension DipositTypeExtension on DepositType {
  String get japanName {
    switch (this) {
      case DepositType.bank:
        return 'bank';
      case DepositType.emoney:
        return 'emoney';
    }
  }
}
