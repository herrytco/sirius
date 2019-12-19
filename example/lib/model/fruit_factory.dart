import 'package:sirius/i_dpa_factory.dart';
import 'fruit.dart';

class FruitFactory extends DPAFactory<Fruit> {
  @override
  Fruit fromMap(Map<String, dynamic> data) {
    if (!(data.containsKey("id") &&
        data.containsKey("name") &&
        data.containsKey("weight") &&
        data.containsKey("description")))
      throw Exception("not all fields are present in the map");
    
    Fruit f = entity;

    f.id = data["id"];
    f.name = data["name"];
    f.description = data["description"];
    f.weight = data["weight"];

    return f;
  }

  @override
  Fruit get entity => Fruit();

  Fruit construct(String name, String description, {int weight}) {
    Fruit f = entity;

    f.name = name;
    f.description = description;
    f.weight = weight;

    return f;
  }
}
