// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLoginAccountCollection on Isar {
  IsarCollection<LoginAccount> get loginAccounts => this.collection();
}

const LoginAccountSchema = CollectionSchema(
  name: r'LoginAccount',
  id: -1085183710116321989,
  properties: {
    r'mailAddress': PropertySchema(
      id: 0,
      name: r'mailAddress',
      type: IsarType.string,
    ),
    r'password': PropertySchema(
      id: 1,
      name: r'password',
      type: IsarType.string,
    )
  },
  estimateSize: _loginAccountEstimateSize,
  serialize: _loginAccountSerialize,
  deserialize: _loginAccountDeserialize,
  deserializeProp: _loginAccountDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _loginAccountGetId,
  getLinks: _loginAccountGetLinks,
  attach: _loginAccountAttach,
  version: '3.1.0+1',
);

int _loginAccountEstimateSize(
  LoginAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mailAddress.length * 3;
  bytesCount += 3 + object.password.length * 3;
  return bytesCount;
}

void _loginAccountSerialize(
  LoginAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.mailAddress);
  writer.writeString(offsets[1], object.password);
}

LoginAccount _loginAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LoginAccount();
  object.id = id;
  object.mailAddress = reader.readString(offsets[0]);
  object.password = reader.readString(offsets[1]);
  return object;
}

P _loginAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _loginAccountGetId(LoginAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _loginAccountGetLinks(LoginAccount object) {
  return [];
}

void _loginAccountAttach(
    IsarCollection<dynamic> col, Id id, LoginAccount object) {
  object.id = id;
}

extension LoginAccountQueryWhereSort
    on QueryBuilder<LoginAccount, LoginAccount, QWhere> {
  QueryBuilder<LoginAccount, LoginAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LoginAccountQueryWhere
    on QueryBuilder<LoginAccount, LoginAccount, QWhereClause> {
  QueryBuilder<LoginAccount, LoginAccount, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LoginAccountQueryFilter
    on QueryBuilder<LoginAccount, LoginAccount, QFilterCondition> {
  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mailAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mailAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mailAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      mailAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mailAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'password',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'password',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'password',
        value: '',
      ));
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterFilterCondition>
      passwordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'password',
        value: '',
      ));
    });
  }
}

extension LoginAccountQueryObject
    on QueryBuilder<LoginAccount, LoginAccount, QFilterCondition> {}

extension LoginAccountQueryLinks
    on QueryBuilder<LoginAccount, LoginAccount, QFilterCondition> {}

extension LoginAccountQuerySortBy
    on QueryBuilder<LoginAccount, LoginAccount, QSortBy> {
  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> sortByMailAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mailAddress', Sort.asc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy>
      sortByMailAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mailAddress', Sort.desc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> sortByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> sortByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }
}

extension LoginAccountQuerySortThenBy
    on QueryBuilder<LoginAccount, LoginAccount, QSortThenBy> {
  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> thenByMailAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mailAddress', Sort.asc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy>
      thenByMailAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mailAddress', Sort.desc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> thenByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QAfterSortBy> thenByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }
}

extension LoginAccountQueryWhereDistinct
    on QueryBuilder<LoginAccount, LoginAccount, QDistinct> {
  QueryBuilder<LoginAccount, LoginAccount, QDistinct> distinctByMailAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mailAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoginAccount, LoginAccount, QDistinct> distinctByPassword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'password', caseSensitive: caseSensitive);
    });
  }
}

extension LoginAccountQueryProperty
    on QueryBuilder<LoginAccount, LoginAccount, QQueryProperty> {
  QueryBuilder<LoginAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LoginAccount, String, QQueryOperations> mailAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mailAddress');
    });
  }

  QueryBuilder<LoginAccount, String, QQueryOperations> passwordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'password');
    });
  }
}
