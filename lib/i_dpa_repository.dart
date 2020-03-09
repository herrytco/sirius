import 'package:sirius/dpa.dart';
import 'package:sirius/i_dpa_entity.dart';
import 'package:sirius/i_dpa_factory.dart';
import 'package:sqflite/sqflite.dart';

abstract class DPARepository<F extends DPAEntity, G extends DPAFactory<F>> {
  static List<String> tables = [];

  String _createQuery;
  String get createQuery => _createQuery;

  String _tableName;
  String get tableName => _tableName;

  final G _factory;
  G get entityFactory => _factory;

  F _reference;

  DPARepository(this._factory) {
    _reference = _factory.entity;
    _tableName = "table_${_reference.runtimeType.toString().toLowerCase()}";

    // get the entity information from the reference
    _reference.registerFields();
    _constructCreateQuery(_reference);

    DPA.instance.registerRepository(this);
  }

  ///
  /// builds the CREATE query based on the data gathered from the reference
  /// Object
  ///
  String _constructCreateQuery(F reference) {
    if (reference.primaryKeyFields.length == 0)
      throw Exception(
          "Your entity '${reference.runtimeType.toString()}' does not have a primary key column. Assign at least one.");

    String tableName = _tableName;
    _createQuery = "CREATE TABLE IF NOT EXISTS $tableName (";

    for (String fieldName in reference.fields.keys) {
      switch (reference.fields[fieldName]) {
        case DataType.Integer:
          _createQuery += "$fieldName INTEGER, ";
          break;

        case DataType.String:
          _createQuery += "$fieldName TEXT, ";
          break;

        case DataType.IntegerAuto:
          _createQuery += "$fieldName INTEGER PRIMARY KEY AUTOINCREMENT, ";
          break;
      }
    }

    if (!_reference.hasAutoIncrementPrimaryKey) {
      _createQuery += "PRIMARY KEY(";

      for (String pkColumn in reference.primaryKeyFields)
        _createQuery += "$pkColumn, ";

      _createQuery = _createQuery.substring(0, _createQuery.length - 2);

      _createQuery += "))";
    } else
      _createQuery = _createQuery.substring(0, _createQuery.length - 2) + ")";

    return _createQuery;
  }

  ///
  /// returns true, iff [data] only contains fields that are also a column in
  /// the DPAEntity
  ///
  bool _checkMapFields(Map<String, dynamic> data) {
    for (String key in data.keys) {
      if (!_reference.fields.keys.contains(key)) return false;
    }

    return true;
  }

  ///
  /// adds the given entity to the matching table
  ///
  Future<void> add(F entity) async {
    if (!entity.primaryKeyFieldsAreSet(_reference))
      throw Exception("Not all Primary key fields have been set!");

    Map<String, dynamic> data = entity.toMap();

    if (entity.hasAutoIncrementPrimaryKey) {
      for (String key in entity.fields.keys)
        if (entity.fields[key] == DataType.IntegerAuto) {
          data.remove(key);
          break;
        }
    }

    Database db = await DPA.instance.database;
    try {
      await db.insert(_tableName, data);
    } on DatabaseException catch (e) {
      if (e.toString().startsWith("DatabaseException(UNIQUE constraint failed"))
        throw Exception(
            "It is not possible to add $entity to the table because an element with the same primary key already exists.");
      else
        throw e;
    }
  }

  ///
  /// retrieves all entities from the Database
  ///
  Future<List<F>> all() async {
    Database db = await DPA.instance.database;

    List<Map<String, dynamic>> result = await db.query(_tableName);

    List<F> data = [];

    for (Map<String, dynamic> row in result) {
      data.add(_factory.fromMap(row));
    }

    return data;
  }

  ///
  /// retrieves one entity from the Database
  /// all primary-key fields must be present in [pk]
  ///
  Future<F> one(Map<String, dynamic> pk) async {
    Database db = await DPA.instance.database;

    for (String column in _reference.fields.keys) {
      if (_reference.primaryKeyFields.contains(column) &&
          !pk.containsKey(column))
        throw Exception(
            "Error while querying for a single entity of type '${_reference.runtimeType}': One or more primary key fields are missing in arguments.\nMissing Primary Key Field: $column");
      else if (!_reference.primaryKeyFields.contains(column) &&
          pk.containsKey(column))
        throw Exception(
            "Error while querying for a single entity of type '${_reference.runtimeType}' Unnecessary non-primary-key arguments.\nUnneccessary Field: $column");
    }

    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: _reference.whereStringForSingleEntity,
      whereArgs: _reference.whereArgs(pk, _reference),
    );

    if (result.length != 1)
      throw Exception(
          "Error while querying for a single entity of type '${_reference.runtimeType}' Invalid number of results.\nExpected to find 1 result, actually found: ${result.length}");

    return _factory.fromMap(result[0]);
  }

  ///
  /// deletes ALL entities from the table that matches with the given
  /// search mask
  ///
  Future<void> delete(Map<String, dynamic> mask) async {
    Database db = await DPA.instance.database;

    if (!_checkMapFields(mask))
      throw Exception("Unrecognized field in delete operation!");

    if (mask.keys.isNotEmpty)
      await db.delete(
        _tableName,
        where: _reference.getWhereString(mask, _reference),
        whereArgs: _reference.whereArgs(mask, _reference),
      );
    else
      await db.delete(_tableName);
  }

  ///
  /// updates the values of [entity] in the table to match the entity
  /// of the given parameter.
  ///
  Future<void> update(F entity) async {
    if (!entity.primaryKeyFieldsAreSet(_reference))
      throw Exception("Not all Primary key fields have been set!");

    Database db = await DPA.instance.database;

    try {
      await db.update(
        _tableName,
        entity.toMap(),
        where: _reference.whereStringForSingleEntity,
        whereArgs:
            entity.whereArgs(entity.toPrimaryKeyFields(_reference), _reference),
      );
    } catch (e) {}
  }
}
