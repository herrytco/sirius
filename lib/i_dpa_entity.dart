enum DataType { String, Integer, IntegerAuto }

abstract class DPAEntity {
  Map<String, DataType> fields = {};
  List<String> primaryKeyFields = [];
  List<String> _fieldOrder = [];
  List<String> get fieldOrder => _fieldOrder;
  bool _hasAutoIncrementInteger = false;
  bool get hasAutoIncrementPrimaryKey => _hasAutoIncrementInteger;

  ///
  /// registers a new field of the entity. It gets mapped to a column in the
  /// generated table.
  /// An exception is thrown, if a field is registered twice.
  ///
  void registerField(String key, DataType type, {bool primaryKey = false}) {
    if (fields.containsKey(key)) throw Exception("Field was already defined.");

    fields[key] = type;
    _fieldOrder.add(key);

    if (type == DataType.IntegerAuto) {
      if (!primaryKey)
        throw Exception(
            "Field '$key' was declared as an AutoIncrement but is not a primary key!");
      _hasAutoIncrementInteger = true;
    } else {
      if (_hasAutoIncrementInteger && primaryKeyFields.length > 1)
        throw Exception(
            "cannot add field '$key' to the primary keys because there exists an auto increment column which must be the only primary key value.");
    }

    if (primaryKey || type == DataType.IntegerAuto) primaryKeyFields.add(key);
  }

  ///
  /// transforms the given map into a list of arguments for querying. This is
  /// important to ensure the same order of arguments in each query
  ///
  List<dynamic> whereArgs(Map<String, dynamic> args, DPAEntity reference) {
    List<dynamic> whereArgs = [];

    if (args.keys.isNotEmpty)
      for (String field in reference.fieldOrder) {
        if (args.containsKey(field)) {
          whereArgs.add(args[field]);
        }
      }

    return whereArgs;
  }

  ///
  /// generates a SQFLite where String which is used in the repository
  /// based on the order of the fields which occur through the order
  /// of registering
  ///
  String getWhereString(Map<String, dynamic> data, DPAEntity reference) {
    String result = "";

    if (data.keys.isNotEmpty)
      for (String field in reference.fieldOrder) {
        if (data.containsKey(field)) {
          result += "$field = ? AND";
        }
      }

    return result.substring(0, result.length - 4).trim();
  }

  ///
  /// builds the where-String to query a single entity. It gets build like the
  /// following schema:
  ///
  /// field1 = ? AND field2 = ? AND ...
  /// for each primary key field
  ///
  String get whereStringForSingleEntity {
    String whereString = "";

    for (String field in _fieldOrder) {
      if (primaryKeyFields.contains(field)) {
        whereString += "$field = ? AND ";
      }
    }

    return whereString.substring(0, whereString.length - 5);
  }

  ///
  /// returns true, iff all fields required to identify one entity have been set
  /// or not
  ///
  bool primaryKeyFieldsAreSet(DPAEntity reference) {
    Map<String, dynamic> data = toMap();

    for (String key in reference.primaryKeyFields)
      if (reference.fields[key] == DataType.IntegerAuto)
        continue;
      else if (!data.containsKey(key) || data[key] == null) return false;

    return true;
  }

  ///
  /// retrieve all fields used to identify the entity uniquely
  ///
  Map<String, dynamic> toPrimaryKeyFields(DPAEntity reference) {
    Map<String, dynamic> data = {};
    Map<String, dynamic> entityData = toMap();

    for (String key in reference.primaryKeyFields) {
      if (!entityData.containsKey(key))
        throw Exception("Not all Primary key fields have been set!");

      data[key] = entityData[key];
    }

    return data;
  }

  void registerFields();

  Map<String, dynamic> toMap();
}
