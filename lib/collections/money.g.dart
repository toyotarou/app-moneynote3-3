// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMoneyCollection on Isar {
  IsarCollection<Money> get moneys => this.collection();
}

const MoneySchema = CollectionSchema(
  name: r'Money',
  id: 8874918762861247504,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'yen_1': PropertySchema(
      id: 1,
      name: r'yen_1',
      type: IsarType.long,
    ),
    r'yen_10': PropertySchema(
      id: 2,
      name: r'yen_10',
      type: IsarType.long,
    ),
    r'yen_100': PropertySchema(
      id: 3,
      name: r'yen_100',
      type: IsarType.long,
    ),
    r'yen_1000': PropertySchema(
      id: 4,
      name: r'yen_1000',
      type: IsarType.long,
    ),
    r'yen_10000': PropertySchema(
      id: 5,
      name: r'yen_10000',
      type: IsarType.long,
    ),
    r'yen_2000': PropertySchema(
      id: 6,
      name: r'yen_2000',
      type: IsarType.long,
    ),
    r'yen_5': PropertySchema(
      id: 7,
      name: r'yen_5',
      type: IsarType.long,
    ),
    r'yen_50': PropertySchema(
      id: 8,
      name: r'yen_50',
      type: IsarType.long,
    ),
    r'yen_500': PropertySchema(
      id: 9,
      name: r'yen_500',
      type: IsarType.long,
    ),
    r'yen_5000': PropertySchema(
      id: 10,
      name: r'yen_5000',
      type: IsarType.long,
    )
  },
  estimateSize: _moneyEstimateSize,
  serialize: _moneySerialize,
  deserialize: _moneyDeserialize,
  deserializeProp: _moneyDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _moneyGetId,
  getLinks: _moneyGetLinks,
  attach: _moneyAttach,
  version: '3.1.0+1',
);

int _moneyEstimateSize(
  Money object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  return bytesCount;
}

void _moneySerialize(
  Money object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeLong(offsets[1], object.yen_1);
  writer.writeLong(offsets[2], object.yen_10);
  writer.writeLong(offsets[3], object.yen_100);
  writer.writeLong(offsets[4], object.yen_1000);
  writer.writeLong(offsets[5], object.yen_10000);
  writer.writeLong(offsets[6], object.yen_2000);
  writer.writeLong(offsets[7], object.yen_5);
  writer.writeLong(offsets[8], object.yen_50);
  writer.writeLong(offsets[9], object.yen_500);
  writer.writeLong(offsets[10], object.yen_5000);
}

Money _moneyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Money();
  object.date = reader.readString(offsets[0]);
  object.id = id;
  object.yen_1 = reader.readLong(offsets[1]);
  object.yen_10 = reader.readLong(offsets[2]);
  object.yen_100 = reader.readLong(offsets[3]);
  object.yen_1000 = reader.readLong(offsets[4]);
  object.yen_10000 = reader.readLong(offsets[5]);
  object.yen_2000 = reader.readLong(offsets[6]);
  object.yen_5 = reader.readLong(offsets[7]);
  object.yen_50 = reader.readLong(offsets[8]);
  object.yen_500 = reader.readLong(offsets[9]);
  object.yen_5000 = reader.readLong(offsets[10]);
  return object;
}

P _moneyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moneyGetId(Money object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moneyGetLinks(Money object) {
  return [];
}

void _moneyAttach(IsarCollection<dynamic> col, Id id, Money object) {
  object.id = id;
}

extension MoneyByIndex on IsarCollection<Money> {
  Future<Money?> getByDate(String date) {
    return getByIndex(r'date', [date]);
  }

  Money? getByDateSync(String date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(String date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(String date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<Money?>> getAllByDate(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<Money?> getAllByDateSync(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<String> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(Money object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(Money object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<Money> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<Money> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension MoneyQueryWhereSort on QueryBuilder<Money, Money, QWhere> {
  QueryBuilder<Money, Money, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MoneyQueryWhere on QueryBuilder<Money, Money, QWhereClause> {
  QueryBuilder<Money, Money, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Money, Money, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Money, Money, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Money, Money, QAfterWhereClause> idBetween(
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

  QueryBuilder<Money, Money, QAfterWhereClause> dateEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterWhereClause> dateNotEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MoneyQueryFilter on QueryBuilder<Money, Money, QFilterCondition> {
  QueryBuilder<Money, Money, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Money, Money, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Money, Money, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_1',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_1',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_1',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_10',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_10',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_10',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_10',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_100EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_100',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_100GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_100',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_100LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_100',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_100Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_100',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1000EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_1000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1000GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_1000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1000LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_1000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_1000Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_1000',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10000EqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_10000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10000GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_10000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10000LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_10000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_10000Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_10000',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_2000EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_2000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_2000GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_2000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_2000LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_2000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_2000Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_2000',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_5',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_5',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_5',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_5',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_50EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_50',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_50GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_50',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_50LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_50',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_50Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_50',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_500EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_500',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_500GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_500',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_500LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_500',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_500Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_500',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5000EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yen_5000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5000GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yen_5000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5000LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yen_5000',
        value: value,
      ));
    });
  }

  QueryBuilder<Money, Money, QAfterFilterCondition> yen_5000Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yen_5000',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MoneyQueryObject on QueryBuilder<Money, Money, QFilterCondition> {}

extension MoneyQueryLinks on QueryBuilder<Money, Money, QFilterCondition> {}

extension MoneyQuerySortBy on QueryBuilder<Money, Money, QSortBy> {
  QueryBuilder<Money, Money, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_10() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_10Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_100() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_100', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_100Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_100', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_1000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_1000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_10000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_10000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_2000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_2000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_2000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_2000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_50() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_50', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_50Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_50', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_500() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_500', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_500Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_500', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_5000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> sortByYen_5000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5000', Sort.desc);
    });
  }
}

extension MoneyQuerySortThenBy on QueryBuilder<Money, Money, QSortThenBy> {
  QueryBuilder<Money, Money, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_10() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_10Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_100() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_100', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_100Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_100', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_1000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_1000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_1000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_10000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_10000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_10000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_2000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_2000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_2000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_2000', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_50() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_50', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_50Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_50', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_500() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_500', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_500Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_500', Sort.desc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_5000() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5000', Sort.asc);
    });
  }

  QueryBuilder<Money, Money, QAfterSortBy> thenByYen_5000Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yen_5000', Sort.desc);
    });
  }
}

extension MoneyQueryWhereDistinct on QueryBuilder<Money, Money, QDistinct> {
  QueryBuilder<Money, Money, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_1');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_10() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_10');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_100() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_100');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_1000() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_1000');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_10000() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_10000');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_2000() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_2000');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_5() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_5');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_50() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_50');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_500() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_500');
    });
  }

  QueryBuilder<Money, Money, QDistinct> distinctByYen_5000() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yen_5000');
    });
  }
}

extension MoneyQueryProperty on QueryBuilder<Money, Money, QQueryProperty> {
  QueryBuilder<Money, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Money, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_1');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_10Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_10');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_100Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_100');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_1000Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_1000');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_10000Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_10000');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_2000Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_2000');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_5Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_5');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_50Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_50');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_500Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_500');
    });
  }

  QueryBuilder<Money, int, QQueryOperations> yen_5000Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yen_5000');
    });
  }
}
