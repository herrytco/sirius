![logo](https://github.com/herrytco/sirius/blob/master/sirius.png)

Sirius is an abstraction to SQFlite. The main goal is to avoid the need to write basic CRUD queries and abstract the process of creating and maintaining the SQLite tables by yourself.

# How it works

1. Let your model extend DPAEntity

```
class Fruit extends DPAEntity {}
```

This makes your model consumable by the Sirius engine. Now, you can register the fields of the model class to be stored in the underlaying table. To do that, you have to override the *registerFields()* method.

2. Register fields which have to be stored

```
int id;
String name; 

@override
void registerFields() {
  registerField("id", DataType.Integer, primaryKey: true);
  registerField("name", DataType.String);
}
```

In the example above, a table would be created, which holds 2 values, *id* and *name*, where *id* is the primary key. 

3. Define a Serialization

Sirius will use the serialized version of your model class to store it in the resulting table. To achieve this, the *toMap()* method has to be implemented 

```
@override
Map<String, dynamic> toMap() {
  return {
    "id": id,
    "name": name,
  };
}
```

4. Create a Factory

The factory is responsible for instantiating your model objects. It's main responsibility is to provide the repository a reference entity to fetch the field-data from.

```
class FruitFactory extends DPAFactory<Fruit> {
  @override
  Fruit fromMap(Map<String, dynamic> data) {
    if (!(data.containsKey("id") &&
        data.containsKey("name")))
      throw Exception("not all fields are present in the map");

    return construct(data["id"], data["name"]);
  }

  @override
  Fruit get entity => Fruit();
  
  Fruit construct(int id, String name) {
    Fruit f = entity;

    f.id = id;
    f.name = name;
    
    return f;
  }
}
```

The *fromMap(..)* method is used to deserialize the model class every time it is retrieved from the table. *entity* should instanciate a reference Object. It does not have to contain data, as it is used by the repository to determine the table structure.

In the example above, I added a *construct(..)* method to avoid the need of passing a Map each time i want to instantiate a Fruit. This step is optional.

5. Create the Repository

```
class FruitRepository extends DPARepository<Fruit, FruitFactory> {
  FruitRepository() : super(FruitFactory());
}
```

The repository ties all ends together. The factory defined above gets used to create a table in the background, where the Fruit objects will be stored. All basic CRUD operations are called from the repository.

# Use examples

```
FruitRepository fruitRepository = FruitRepository();

Fruit apple = fruitRepository.entityFactory.construct(
  3,
  "Strawberry",
  "Red, small fruit which has 'Berry' in its name but is really a 'Nut'.",
);

fruitRepository.add(apple);

Fruit fruit = await fruitRepository.one({"id": 3});

List<Fruit> allFruits = await fruitRepository.all();

await fruitRepository.delete({"id": 3});
```

Here, the repository gets instantiated once. It is then used to:

* get a reference to the FruitFactory
* add a new Fruit object to the table
* query all stored Fruit objects
* get a specific Fruit object from the table
* delete a specific Fruit object from the table