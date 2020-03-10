import 'package:example/add_fruit_dialog.dart';
import 'package:example/model/fruit.dart';
import 'package:example/model/fruit_repository.dart';
import 'package:flutter/material.dart';
import 'package:sirius/dpa.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Fruit> fruits = [];

  Future<void> _initData() async {
    FruitRepository repo = DPA.repository(FruitRepository);
    fruits = await repo.all();

    setState(() {});
  }

  @override
  void initState() {
    FruitRepository();
    super.initState();
    _initData();
  }

  ///
  /// callback to the dialog to add the new defined fruit to the database and
  /// update the view
  ///
  void _addFruit(String name, String description, int weight) async {
    print("Adding Fruit($name, $description, $weight)");

    FruitRepository repo = DPA.repository(FruitRepository);

    Fruit fNew =
        repo.entityFactory.construct(name, description, weight: weight);
    await repo.add(fNew);

    fruits = await repo.all();

    setState(() {});
  }

  ///
  /// deletes all fruits stored by passing an empty mask to the delete(..)
  /// method in the repository
  ///
  void _deleteAll() async {
    FruitRepository repo = DPA.repository(FruitRepository);
    await repo.delete({});
    fruits = await repo.all();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DPA Demo Application',
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text("DPA Test"),
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FloatingActionButton(
                child: Icon(Icons.delete),
                onPressed: _deleteAll,
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AddFruitDialog(_addFruit),
                  );
                },
              ),
            ],
          ),
          body: DataTable(
            columns: [
              DataColumn(
                label: Text("Id"),
                numeric: true,
              ),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Description")),
              DataColumn(
                label: Text("Weight"),
                numeric: true,
              ),
            ],
            rows: fruits
                .map(
                  (Fruit f) => DataRow(cells: [
                    DataCell(Text("${f.id}")),
                    DataCell(Text("${f.name}")),
                    DataCell(Text("${f.description}")),
                    DataCell(Text("${f.weight}")),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
