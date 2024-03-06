enum AccountType { blank, normal, fixed }

extension AccountTypeExtension on AccountType {
  String get japanName {
    switch (this) {
      case AccountType.blank:
        return '';
      case AccountType.normal:
        return '普通口座';
      case AccountType.fixed:
        return '定期口座';
    }
  }
}
