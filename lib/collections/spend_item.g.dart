// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spend_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpendItemCollection on Isar {
  IsarCollection<SpendItem> get spendItems => this.collection();
}

const SpendItemSchema = CollectionSchema(
  name: r'SpendItem',
  id: -7020034350100909142,
  properties: {
    r'spendItemName': PropertySchema(
      id: 0,
      name: r'spendItemName',
      type: IsarType.string,
    )
  },
  estimateSize: _spendItemEstimateSize,
  serialize: _spendItemSerialize,
  deserialize: _spendItemDeserialize,
  deserializeProp: _spendItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _spendItemGetId,
  getLinks: _spendItemGetLinks,
  attach: _spendItemAttach,
  version: '3.1.0+1',
);

int _spendItemEstimateSize(
  SpendItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.spendItemName.length * 3;
  return bytesCount;
}

void _spendItemSerialize(
  SpendItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.spendItemName);
}

SpendItem _spendItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpendItem();
  object.id = id;
  object.spendItemName = reader.readString(offsets[0]);
  return object;
}

P _spendItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _spendItemGetId(SpendItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _spendItemGetLinks(SpendItem object) {
  return [];
}

void _spendItemAttach(IsarCollection<dynamic> col, Id id, SpendItem object) {
  object.id = id;
}

extension SpendItemQueryWhereSort
    on QueryBuilder<SpendItem, SpendItem, QWhere> {
  QueryBuilder<SpendItem, SpendItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SpendItemQueryWhere
    on QueryBuilder<SpendItem, SpendItem, QWhereClause> {
  QueryBuilder<SpendItem, SpendItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SpendItem, SpendItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterWhereClause> idBetween(
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

extension SpendItemQueryFilter
    on QueryBuilder<SpendItem, SpendItem, QFilterCondition> {
  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spendItemName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spendItemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spendItemName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spendItemName',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterFilterCondition>
      spendItemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spendItemName',
        value: '',
      ));
    });
  }
}

extension SpendItemQueryObject
    on QueryBuilder<SpendItem, SpendItem, QFilterCondition> {}

extension SpendItemQueryLinks
    on QueryBuilder<SpendItem, SpendItem, QFilterCondition> {}

extension SpendItemQuerySortBy on QueryBuilder<SpendItem, SpendItem, QSortBy> {
  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> sortBySpendItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spendItemName', Sort.asc);
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> sortBySpendItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spendItemName', Sort.desc);
    });
  }
}

extension SpendItemQuerySortThenBy
    on QueryBuilder<SpendItem, SpendItem, QSortThenBy> {
  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> thenBySpendItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spendItemName', Sort.asc);
    });
  }

  QueryBuilder<SpendItem, SpendItem, QAfterSortBy> thenBySpendItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spendItemName', Sort.desc);
    });
  }
}

extension SpendItemQueryWhereDistinct
    on QueryBuilder<SpendItem, SpendItem, QDistinct> {
  QueryBuilder<SpendItem, SpendItem, QDistinct> distinctBySpendItemName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spendItemName',
          caseSensitive: caseSensitive);
    });
  }
}

extension SpendItemQueryProperty
    on QueryBuilder<SpendItem, SpendItem, QQueryProperty> {
  QueryBuilder<SpendItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpendItem, String, QQueryOperations> spendItemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spendItemName');
    });
  }
}
