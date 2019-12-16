enum DataType { String, Integer }

abstract class DPAEntity {
  Map<String, DataType> fields = {};
  List<String> primaryKeyFields = [];
  List<String> _fieldOrder = [];

  ///
  /// registers a new field of the entity. It gets mapped to a column in the
  /// generated table.
  /// An exception is thrown, if a field is registered twice.
  ///
  void registerField(String key, DataType type, {bool primaryKey = false}) {
    if (fields.containsKey(key)) throw Exception("Field was already defined.");

    fields[key] = type;
    _fieldOrder.add(key);

    if (primaryKey) primaryKeyFields.add(key);
  }

  ///
  /// transforms the given map into a list of arguments for querying. This is
  /// important to ensure the same order of arguments in each query
  ///
  List<dynamic> whereArgs(Map<String, dynamic> args) {
    List<dynamic> whereArgs = [];

    for (String field in _fieldOrder) {
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
  String getWhereString(Map<String, dynamic> data) {
    String result = "";

    for (String field in _fieldOrder) {
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

  void registerFields();

  Map<String, dynamic> toMap();
}
