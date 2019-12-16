import 'package:sirius/i_dpa_factory.dart';
import 'fruit.dart';

class FruitFactory extends DPAFactory<Fruit> {
  @override
  Fruit fromMap(Map<String, dynamic> data) {
    if (!(data.containsKey("id") &&
        data.containsKey("name") &&
        data.containsKey("description")))
      throw Exception("not all fields are present in the map");

    return construct(data["id"], data["name"], data["description"]);
  }

  @override
  Fruit get entity => Fruit();

  Fruit construct(int id, String name, String description) {
    Fruit f = entity;

    f.id = id;
    f.name = name;
    f.description = description;

    return f;
  }
}
