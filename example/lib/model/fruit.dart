import 'package:sirius/i_dpa_entity.dart';

class Fruit extends DPAEntity {
  int id;

  String name;

  String description;

  int weight;

  @override
  void registerFields() {
    registerField("id", DataType.IntegerAuto, primaryKey: true);
    registerField("name", DataType.String);
    registerField("description", DataType.String);
    registerField("weight", DataType.Integer);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "weight": weight,
    };
  }
}
