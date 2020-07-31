// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalDatabase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class account_book extends DataClass implements Insertable<account_book> {
  final int id;
  final String name;
  final int color;
  final int creationDate;
  account_book(
      {@required this.id,
      @required this.name,
      @required this.color,
      @required this.creationDate});
  factory account_book.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return account_book(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      creationDate: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || creationDate != null) {
      map['creation_date'] = Variable<int>(creationDate);
    }
    return map;
  }

  AccountBookCompanion toCompanion(bool nullToAbsent) {
    return AccountBookCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      creationDate: creationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(creationDate),
    );
  }

  factory account_book.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return account_book(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      creationDate: serializer.fromJson<int>(json['creationDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'creationDate': serializer.toJson<int>(creationDate),
    };
  }

  account_book copyWith({int id, String name, int color, int creationDate}) =>
      account_book(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        creationDate: creationDate ?? this.creationDate,
      );
  @override
  String toString() {
    return (StringBuffer('account_book(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('creationDate: $creationDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(color.hashCode, creationDate.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is account_book &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.creationDate == this.creationDate);
}

class AccountBookCompanion extends UpdateCompanion<account_book> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> creationDate;
  const AccountBookCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.creationDate = const Value.absent(),
  });
  AccountBookCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
    @required int creationDate,
  })  : name = Value(name),
        color = Value(color),
        creationDate = Value(creationDate);
  static Insertable<account_book> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<int> creationDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (creationDate != null) 'creation_date': creationDate,
    });
  }

  AccountBookCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<int> creationDate}) {
    return AccountBookCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<int>(creationDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountBookCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('creationDate: $creationDate')
          ..write(')'))
        .toString();
  }
}

class $AccountBookTable extends AccountBook
    with TableInfo<$AccountBookTable, account_book> {
  final GeneratedDatabase _db;
  final String _alias;
  $AccountBookTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  GeneratedIntColumn _creationDate;
  @override
  GeneratedIntColumn get creationDate =>
      _creationDate ??= _constructCreationDate();
  GeneratedIntColumn _constructCreationDate() {
    return GeneratedIntColumn(
      'creation_date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color, creationDate];
  @override
  $AccountBookTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'account_book';
  @override
  final String actualTableName = 'account_book';
  @override
  VerificationContext validateIntegrity(Insertable<account_book> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date'], _creationDateMeta));
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  account_book map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return account_book.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AccountBookTable createAlias(String alias) {
    return $AccountBookTable(_db, alias);
  }
}

class category extends DataClass implements Insertable<category> {
  final int id;
  final String name;
  final int color;
  final bool isIncome;
  final int bookId;
  final bool canDelete;
  category(
      {@required this.id,
      @required this.name,
      @required this.color,
      @required this.isIncome,
      @required this.bookId,
      @required this.canDelete});
  factory category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      isIncome:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_income']),
      bookId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}book_id']),
      canDelete: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}can_delete']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || isIncome != null) {
      map['is_income'] = Variable<bool>(isIncome);
    }
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    if (!nullToAbsent || canDelete != null) {
      map['can_delete'] = Variable<bool>(canDelete);
    }
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      isIncome: isIncome == null && nullToAbsent
          ? const Value.absent()
          : Value(isIncome),
      bookId:
          bookId == null && nullToAbsent ? const Value.absent() : Value(bookId),
      canDelete: canDelete == null && nullToAbsent
          ? const Value.absent()
          : Value(canDelete),
    );
  }

  factory category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      bookId: serializer.fromJson<int>(json['bookId']),
      canDelete: serializer.fromJson<bool>(json['canDelete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'isIncome': serializer.toJson<bool>(isIncome),
      'bookId': serializer.toJson<int>(bookId),
      'canDelete': serializer.toJson<bool>(canDelete),
    };
  }

  category copyWith(
          {int id,
          String name,
          int color,
          bool isIncome,
          int bookId,
          bool canDelete}) =>
      category(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        isIncome: isIncome ?? this.isIncome,
        bookId: bookId ?? this.bookId,
        canDelete: canDelete ?? this.canDelete,
      );
  @override
  String toString() {
    return (StringBuffer('category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isIncome: $isIncome, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              color.hashCode,
              $mrjc(isIncome.hashCode,
                  $mrjc(bookId.hashCode, canDelete.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is category &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.isIncome == this.isIncome &&
          other.bookId == this.bookId &&
          other.canDelete == this.canDelete);
}

class CategoryCompanion extends UpdateCompanion<category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<bool> isIncome;
  final Value<int> bookId;
  final Value<bool> canDelete;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.bookId = const Value.absent(),
    this.canDelete = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
    this.isIncome = const Value.absent(),
    @required int bookId,
    this.canDelete = const Value.absent(),
  })  : name = Value(name),
        color = Value(color),
        bookId = Value(bookId);
  static Insertable<category> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<bool> isIncome,
    Expression<int> bookId,
    Expression<bool> canDelete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isIncome != null) 'is_income': isIncome,
      if (bookId != null) 'book_id': bookId,
      if (canDelete != null) 'can_delete': canDelete,
    });
  }

  CategoryCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<bool> isIncome,
      Value<int> bookId,
      Value<bool> canDelete}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
      bookId: bookId ?? this.bookId,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (canDelete.present) {
      map['can_delete'] = Variable<bool>(canDelete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isIncome: $isIncome, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }
}

class $CategoryTable extends Category with TableInfo<$CategoryTable, category> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoryTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isIncomeMeta = const VerificationMeta('isIncome');
  GeneratedBoolColumn _isIncome;
  @override
  GeneratedBoolColumn get isIncome => _isIncome ??= _constructIsIncome();
  GeneratedBoolColumn _constructIsIncome() {
    return GeneratedBoolColumn('is_income', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  GeneratedIntColumn _bookId;
  @override
  GeneratedIntColumn get bookId => _bookId ??= _constructBookId();
  GeneratedIntColumn _constructBookId() {
    return GeneratedIntColumn('book_id', $tableName, false,
        $customConstraints: 'REFERENCES account_book(id)');
  }

  final VerificationMeta _canDeleteMeta = const VerificationMeta('canDelete');
  GeneratedBoolColumn _canDelete;
  @override
  GeneratedBoolColumn get canDelete => _canDelete ??= _constructCanDelete();
  GeneratedBoolColumn _constructCanDelete() {
    return GeneratedBoolColumn('can_delete', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, isIncome, bookId, canDelete];
  @override
  $CategoryTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'category';
  @override
  final String actualTableName = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income'], _isIncomeMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id'], _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('can_delete')) {
      context.handle(_canDeleteMeta,
          canDelete.isAcceptableOrUnknown(data['can_delete'], _canDeleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(_db, alias);
  }
}

class entry extends DataClass implements Insertable<entry> {
  final int id;
  final double amount;
  final int date;
  final int categoryId;
  final int tagId;
  final int walletId;
  final String description;
  final int bookId;
  entry(
      {@required this.id,
      @required this.amount,
      @required this.date,
      @required this.categoryId,
      this.tagId,
      @required this.walletId,
      this.description,
      @required this.bookId});
  factory entry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final stringType = db.typeSystem.forDartType<String>();
    return entry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      date: intType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      tagId: intType.mapFromDatabaseResponse(data['${effectivePrefix}tag_id']),
      walletId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}wallet_id']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      bookId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}book_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<int>(date);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<int>(tagId);
    }
    if (!nullToAbsent || walletId != null) {
      map['wallet_id'] = Variable<int>(walletId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    return map;
  }

  EntryCompanion toCompanion(bool nullToAbsent) {
    return EntryCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      tagId:
          tagId == null && nullToAbsent ? const Value.absent() : Value(tagId),
      walletId: walletId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      bookId:
          bookId == null && nullToAbsent ? const Value.absent() : Value(bookId),
    );
  }

  factory entry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return entry(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<int>(json['date']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      walletId: serializer.fromJson<int>(json['walletId']),
      description: serializer.fromJson<String>(json['description']),
      bookId: serializer.fromJson<int>(json['bookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<int>(date),
      'categoryId': serializer.toJson<int>(categoryId),
      'tagId': serializer.toJson<int>(tagId),
      'walletId': serializer.toJson<int>(walletId),
      'description': serializer.toJson<String>(description),
      'bookId': serializer.toJson<int>(bookId),
    };
  }

  entry copyWith(
          {int id,
          double amount,
          int date,
          int categoryId,
          int tagId,
          int walletId,
          String description,
          int bookId}) =>
      entry(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        categoryId: categoryId ?? this.categoryId,
        tagId: tagId ?? this.tagId,
        walletId: walletId ?? this.walletId,
        description: description ?? this.description,
        bookId: bookId ?? this.bookId,
      );
  @override
  String toString() {
    return (StringBuffer('entry(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('tagId: $tagId, ')
          ..write('walletId: $walletId, ')
          ..write('description: $description, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          amount.hashCode,
          $mrjc(
              date.hashCode,
              $mrjc(
                  categoryId.hashCode,
                  $mrjc(
                      tagId.hashCode,
                      $mrjc(walletId.hashCode,
                          $mrjc(description.hashCode, bookId.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is entry &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.categoryId == this.categoryId &&
          other.tagId == this.tagId &&
          other.walletId == this.walletId &&
          other.description == this.description &&
          other.bookId == this.bookId);
}

class EntryCompanion extends UpdateCompanion<entry> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> date;
  final Value<int> categoryId;
  final Value<int> tagId;
  final Value<int> walletId;
  final Value<String> description;
  final Value<int> bookId;
  const EntryCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.description = const Value.absent(),
    this.bookId = const Value.absent(),
  });
  EntryCompanion.insert({
    this.id = const Value.absent(),
    @required double amount,
    @required int date,
    @required int categoryId,
    this.tagId = const Value.absent(),
    @required int walletId,
    this.description = const Value.absent(),
    @required int bookId,
  })  : amount = Value(amount),
        date = Value(date),
        categoryId = Value(categoryId),
        walletId = Value(walletId),
        bookId = Value(bookId);
  static Insertable<entry> custom({
    Expression<int> id,
    Expression<double> amount,
    Expression<int> date,
    Expression<int> categoryId,
    Expression<int> tagId,
    Expression<int> walletId,
    Expression<String> description,
    Expression<int> bookId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (tagId != null) 'tag_id': tagId,
      if (walletId != null) 'wallet_id': walletId,
      if (description != null) 'description': description,
      if (bookId != null) 'book_id': bookId,
    });
  }

  EntryCompanion copyWith(
      {Value<int> id,
      Value<double> amount,
      Value<int> date,
      Value<int> categoryId,
      Value<int> tagId,
      Value<int> walletId,
      Value<String> description,
      Value<int> bookId}) {
    return EntryCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      tagId: tagId ?? this.tagId,
      walletId: walletId ?? this.walletId,
      description: description ?? this.description,
      bookId: bookId ?? this.bookId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('tagId: $tagId, ')
          ..write('walletId: $walletId, ')
          ..write('description: $description, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }
}

class $EntryTable extends Entry with TableInfo<$EntryTable, entry> {
  final GeneratedDatabase _db;
  final String _alias;
  $EntryTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;
  @override
  GeneratedRealColumn get amount => _amount ??= _constructAmount();
  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn(
      'amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedIntColumn _date;
  @override
  GeneratedIntColumn get date => _date ??= _constructDate();
  GeneratedIntColumn _constructDate() {
    return GeneratedIntColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('category_id', $tableName, false,
        $customConstraints: 'REFERENCES category(id)');
  }

  final VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  GeneratedIntColumn _tagId;
  @override
  GeneratedIntColumn get tagId => _tagId ??= _constructTagId();
  GeneratedIntColumn _constructTagId() {
    return GeneratedIntColumn('tag_id', $tableName, true,
        $customConstraints: 'NULLABLE REFERENCES tag(id)');
  }

  final VerificationMeta _walletIdMeta = const VerificationMeta('walletId');
  GeneratedIntColumn _walletId;
  @override
  GeneratedIntColumn get walletId => _walletId ??= _constructWalletId();
  GeneratedIntColumn _constructWalletId() {
    return GeneratedIntColumn('wallet_id', $tableName, false,
        $customConstraints: 'REFERENCES wallet(id)');
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  GeneratedIntColumn _bookId;
  @override
  GeneratedIntColumn get bookId => _bookId ??= _constructBookId();
  GeneratedIntColumn _constructBookId() {
    return GeneratedIntColumn('book_id', $tableName, false,
        $customConstraints: 'REFERENCES account_book(id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, date, categoryId, tagId, walletId, description, bookId];
  @override
  $EntryTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'entry';
  @override
  final String actualTableName = 'entry';
  @override
  VerificationContext validateIntegrity(Insertable<entry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount'], _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id'], _tagIdMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(_walletIdMeta,
          walletId.isAcceptableOrUnknown(data['wallet_id'], _walletIdMeta));
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id'], _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  entry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return entry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $EntryTable createAlias(String alias) {
    return $EntryTable(_db, alias);
  }
}

class tag extends DataClass implements Insertable<tag> {
  final int id;
  final String name;
  final int color;
  final int categoryId;
  final int bookId;
  final bool canDelete;
  tag(
      {@required this.id,
      @required this.name,
      @required this.color,
      @required this.categoryId,
      @required this.bookId,
      @required this.canDelete});
  factory tag.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return tag(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      bookId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}book_id']),
      canDelete: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}can_delete']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    if (!nullToAbsent || canDelete != null) {
      map['can_delete'] = Variable<bool>(canDelete);
    }
    return map;
  }

  TagCompanion toCompanion(bool nullToAbsent) {
    return TagCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      bookId:
          bookId == null && nullToAbsent ? const Value.absent() : Value(bookId),
      canDelete: canDelete == null && nullToAbsent
          ? const Value.absent()
          : Value(canDelete),
    );
  }

  factory tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      canDelete: serializer.fromJson<bool>(json['canDelete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'categoryId': serializer.toJson<int>(categoryId),
      'bookId': serializer.toJson<int>(bookId),
      'canDelete': serializer.toJson<bool>(canDelete),
    };
  }

  tag copyWith(
          {int id,
          String name,
          int color,
          int categoryId,
          int bookId,
          bool canDelete}) =>
      tag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        categoryId: categoryId ?? this.categoryId,
        bookId: bookId ?? this.bookId,
        canDelete: canDelete ?? this.canDelete,
      );
  @override
  String toString() {
    return (StringBuffer('tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              color.hashCode,
              $mrjc(categoryId.hashCode,
                  $mrjc(bookId.hashCode, canDelete.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.categoryId == this.categoryId &&
          other.bookId == this.bookId &&
          other.canDelete == this.canDelete);
}

class TagCompanion extends UpdateCompanion<tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> categoryId;
  final Value<int> bookId;
  final Value<bool> canDelete;
  const TagCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.canDelete = const Value.absent(),
  });
  TagCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
    @required int categoryId,
    @required int bookId,
    this.canDelete = const Value.absent(),
  })  : name = Value(name),
        color = Value(color),
        categoryId = Value(categoryId),
        bookId = Value(bookId);
  static Insertable<tag> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<int> categoryId,
    Expression<int> bookId,
    Expression<bool> canDelete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (categoryId != null) 'category_id': categoryId,
      if (bookId != null) 'book_id': bookId,
      if (canDelete != null) 'can_delete': canDelete,
    });
  }

  TagCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<int> categoryId,
      Value<int> bookId,
      Value<bool> canDelete}) {
    return TagCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      bookId: bookId ?? this.bookId,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (canDelete.present) {
      map['can_delete'] = Variable<bool>(canDelete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }
}

class $TagTable extends Tag with TableInfo<$TagTable, tag> {
  final GeneratedDatabase _db;
  final String _alias;
  $TagTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('category_id', $tableName, false,
        $customConstraints: 'REFERENCES category(id)');
  }

  final VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  GeneratedIntColumn _bookId;
  @override
  GeneratedIntColumn get bookId => _bookId ??= _constructBookId();
  GeneratedIntColumn _constructBookId() {
    return GeneratedIntColumn('book_id', $tableName, false,
        $customConstraints: 'REFERENCES account_book(id)');
  }

  final VerificationMeta _canDeleteMeta = const VerificationMeta('canDelete');
  GeneratedBoolColumn _canDelete;
  @override
  GeneratedBoolColumn get canDelete => _canDelete ??= _constructCanDelete();
  GeneratedBoolColumn _constructCanDelete() {
    return GeneratedBoolColumn('can_delete', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, categoryId, bookId, canDelete];
  @override
  $TagTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tag';
  @override
  final String actualTableName = 'tag';
  @override
  VerificationContext validateIntegrity(Insertable<tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id'], _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('can_delete')) {
      context.handle(_canDeleteMeta,
          canDelete.isAcceptableOrUnknown(data['can_delete'], _canDeleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  tag map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return tag.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TagTable createAlias(String alias) {
    return $TagTable(_db, alias);
  }
}

class wallet extends DataClass implements Insertable<wallet> {
  final int id;
  final String name;
  final int color;
  final int bookId;
  final bool canDelete;
  wallet(
      {@required this.id,
      @required this.name,
      @required this.color,
      @required this.bookId,
      @required this.canDelete});
  factory wallet.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return wallet(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      bookId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}book_id']),
      canDelete: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}can_delete']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    if (!nullToAbsent || canDelete != null) {
      map['can_delete'] = Variable<bool>(canDelete);
    }
    return map;
  }

  WalletCompanion toCompanion(bool nullToAbsent) {
    return WalletCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      bookId:
          bookId == null && nullToAbsent ? const Value.absent() : Value(bookId),
      canDelete: canDelete == null && nullToAbsent
          ? const Value.absent()
          : Value(canDelete),
    );
  }

  factory wallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return wallet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      bookId: serializer.fromJson<int>(json['bookId']),
      canDelete: serializer.fromJson<bool>(json['canDelete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'bookId': serializer.toJson<int>(bookId),
      'canDelete': serializer.toJson<bool>(canDelete),
    };
  }

  wallet copyWith(
          {int id, String name, int color, int bookId, bool canDelete}) =>
      wallet(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        bookId: bookId ?? this.bookId,
        canDelete: canDelete ?? this.canDelete,
      );
  @override
  String toString() {
    return (StringBuffer('wallet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(color.hashCode, $mrjc(bookId.hashCode, canDelete.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is wallet &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.bookId == this.bookId &&
          other.canDelete == this.canDelete);
}

class WalletCompanion extends UpdateCompanion<wallet> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> bookId;
  final Value<bool> canDelete;
  const WalletCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.bookId = const Value.absent(),
    this.canDelete = const Value.absent(),
  });
  WalletCompanion.insert({
    @required int id,
    @required String name,
    @required int color,
    @required int bookId,
    @required bool canDelete,
  })  : id = Value(id),
        name = Value(name),
        color = Value(color),
        bookId = Value(bookId),
        canDelete = Value(canDelete);
  static Insertable<wallet> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
    Expression<int> bookId,
    Expression<bool> canDelete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (bookId != null) 'book_id': bookId,
      if (canDelete != null) 'can_delete': canDelete,
    });
  }

  WalletCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<int> bookId,
      Value<bool> canDelete}) {
    return WalletCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      bookId: bookId ?? this.bookId,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (canDelete.present) {
      map['can_delete'] = Variable<bool>(canDelete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('bookId: $bookId, ')
          ..write('canDelete: $canDelete')
          ..write(')'))
        .toString();
  }
}

class $WalletTable extends Wallet with TableInfo<$WalletTable, wallet> {
  final GeneratedDatabase _db;
  final String _alias;
  $WalletTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  GeneratedIntColumn _bookId;
  @override
  GeneratedIntColumn get bookId => _bookId ??= _constructBookId();
  GeneratedIntColumn _constructBookId() {
    return GeneratedIntColumn('book_id', $tableName, false,
        $customConstraints: 'REFERENCES account_book(id)');
  }

  final VerificationMeta _canDeleteMeta = const VerificationMeta('canDelete');
  GeneratedBoolColumn _canDelete;
  @override
  GeneratedBoolColumn get canDelete => _canDelete ??= _constructCanDelete();
  GeneratedBoolColumn _constructCanDelete() {
    return GeneratedBoolColumn(
      'can_delete',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color, bookId, canDelete];
  @override
  $WalletTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'wallet';
  @override
  final String actualTableName = 'wallet';
  @override
  VerificationContext validateIntegrity(Insertable<wallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id'], _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('can_delete')) {
      context.handle(_canDeleteMeta,
          canDelete.isAcceptableOrUnknown(data['can_delete'], _canDeleteMeta));
    } else if (isInserting) {
      context.missing(_canDeleteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  wallet map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return wallet.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $WalletTable createAlias(String alias) {
    return $WalletTable(_db, alias);
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $AccountBookTable _accountBook;
  $AccountBookTable get accountBook => _accountBook ??= $AccountBookTable(this);
  $CategoryTable _category;
  $CategoryTable get category => _category ??= $CategoryTable(this);
  $EntryTable _entry;
  $EntryTable get entry => _entry ??= $EntryTable(this);
  $TagTable _tag;
  $TagTable get tag => _tag ??= $TagTable(this);
  $WalletTable _wallet;
  $WalletTable get wallet => _wallet ??= $WalletTable(this);
  AccountBookDao _accountBookDao;
  AccountBookDao get accountBookDao =>
      _accountBookDao ??= AccountBookDao(this as LocalDatabase);
  ParentCategoryDao _parentCategoryDao;
  ParentCategoryDao get parentCategoryDao =>
      _parentCategoryDao ??= ParentCategoryDao(this as LocalDatabase);
  CategoryDao _categoryDao;
  CategoryDao get categoryDao =>
      _categoryDao ??= CategoryDao(this as LocalDatabase);
  EntryDao _entryDao;
  EntryDao get entryDao => _entryDao ??= EntryDao(this as LocalDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accountBook, category, entry, tag, wallet];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ParentCategoryDaoMixin on DatabaseAccessor<LocalDatabase> {}
