import 'package:sirius/i_dpa_entity.dart';

class Fruit extends DPAEntity {
  int id;

  String name;

  String description;

  @override
  void registerFields() {
    registerField("id", DataType.Integer, primaryKey: true);
    registerField("name", DataType.String);
    registerField("description", DataType.String);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
    };
  }
}
