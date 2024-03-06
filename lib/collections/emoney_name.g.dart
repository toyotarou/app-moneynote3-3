// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoney_name.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEmoneyNameCollection on Isar {
  IsarCollection<EmoneyName> get emoneyNames => this.collection();
}

const EmoneyNameSchema = CollectionSchema(
  name: r'EmoneyName',
  id: -8879503489187812298,
  properties: {
    r'depositType': PropertySchema(
      id: 0,
      name: r'depositType',
      type: IsarType.string,
    ),
    r'emoneyName': PropertySchema(
      id: 1,
      name: r'emoneyName',
      type: IsarType.string,
    )
  },
  estimateSize: _emoneyNameEstimateSize,
  serialize: _emoneyNameSerialize,
  deserialize: _emoneyNameDeserialize,
  deserializeProp: _emoneyNameDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _emoneyNameGetId,
  getLinks: _emoneyNameGetLinks,
  attach: _emoneyNameAttach,
  version: '3.1.0+1',
);

int _emoneyNameEstimateSize(
  EmoneyName object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.depositType.length * 3;
  bytesCount += 3 + object.emoneyName.length * 3;
  return bytesCount;
}

void _emoneyNameSerialize(
  EmoneyName object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.depositType);
  writer.writeString(offsets[1], object.emoneyName);
}

EmoneyName _emoneyNameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmoneyName();
  object.depositType = reader.readString(offsets[0]);
  object.emoneyName = reader.readString(offsets[1]);
  object.id = id;
  return object;
}

P _emoneyNameDeserializeProp<P>(
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

Id _emoneyNameGetId(EmoneyName object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _emoneyNameGetLinks(EmoneyName object) {
  return [];
}

void _emoneyNameAttach(IsarCollection<dynamic> col, Id id, EmoneyName object) {
  object.id = id;
}

extension EmoneyNameQueryWhereSort
    on QueryBuilder<EmoneyName, EmoneyName, QWhere> {
  QueryBuilder<EmoneyName, EmoneyName, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EmoneyNameQueryWhere
    on QueryBuilder<EmoneyName, EmoneyName, QWhereClause> {
  QueryBuilder<EmoneyName, EmoneyName, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<EmoneyName, EmoneyName, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterWhereClause> idBetween(
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

extension EmoneyNameQueryFilter
    on QueryBuilder<EmoneyName, EmoneyName, QFilterCondition> {
  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'depositType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'depositType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'depositType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depositType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      depositTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'depositType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> emoneyNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> emoneyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emoneyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emoneyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> emoneyNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emoneyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoneyName',
        value: '',
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition>
      emoneyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emoneyName',
        value: '',
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<EmoneyName, EmoneyName, QAfterFilterCondition> idBetween(
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
}

extension EmoneyNameQueryObject
    on QueryBuilder<EmoneyName, EmoneyName, QFilterCondition> {}

extension EmoneyNameQueryLinks
    on QueryBuilder<EmoneyName, EmoneyName, QFilterCondition> {}

extension EmoneyNameQuerySortBy
    on QueryBuilder<EmoneyName, EmoneyName, QSortBy> {
  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> sortByDepositType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depositType', Sort.asc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> sortByDepositTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depositType', Sort.desc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> sortByEmoneyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoneyName', Sort.asc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> sortByEmoneyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoneyName', Sort.desc);
    });
  }
}

extension EmoneyNameQuerySortThenBy
    on QueryBuilder<EmoneyName, EmoneyName, QSortThenBy> {
  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenByDepositType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depositType', Sort.asc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenByDepositTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depositType', Sort.desc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenByEmoneyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoneyName', Sort.asc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenByEmoneyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoneyName', Sort.desc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension EmoneyNameQueryWhereDistinct
    on QueryBuilder<EmoneyName, EmoneyName, QDistinct> {
  QueryBuilder<EmoneyName, EmoneyName, QDistinct> distinctByDepositType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'depositType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmoneyName, EmoneyName, QDistinct> distinctByEmoneyName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emoneyName', caseSensitive: caseSensitive);
    });
  }
}

extension EmoneyNameQueryProperty
    on QueryBuilder<EmoneyName, EmoneyName, QQueryProperty> {
  QueryBuilder<EmoneyName, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EmoneyName, String, QQueryOperations> depositTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'depositType');
    });
  }

  QueryBuilder<EmoneyName, String, QQueryOperations> emoneyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emoneyName');
    });
  }
}
