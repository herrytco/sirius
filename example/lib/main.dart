import 'package:example/add_fruit_dialog.dart';
import 'package:example/model/fruit.dart';
import 'package:example/model/fruit_repository.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final FruitRepository _fruitRepository = FruitRepository();
  List<Fruit> fruits = [];

  Future<void> _initData() async {
    fruits = await _fruitRepository.all();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  ///
  /// callback to the dialog to add the new defined fruit to the database and
  /// update the view
  ///
  void _addFruit(String name, String description, int weight) async {
    print("Adding Fruit($name, $description, $weight)");

    Fruit fNew = _fruitRepository.entityFactory
        .construct(name, description, weight: weight);
    await _fruitRepository.add(fNew);

    fruits = await _fruitRepository.all();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("DPA Test"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AddFruitDialog(_addFruit),
            );
          },
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
    );
  }
}
