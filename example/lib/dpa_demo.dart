import 'package:flutter/material.dart';
import 'model/fruit_repository.dart';
import 'model/fruit.dart';

class DPADemoView extends StatefulWidget {
  @override
  _DPADemoViewState createState() => _DPADemoViewState();
}

class _DPADemoViewState extends State<DPADemoView> {
  final FruitRepository _fruitRepository = FruitRepository();
  List<Fruit> fruits = [];

  Future<void> _initData() async {
    Fruit apple = _fruitRepository.entityFactory.construct(
      3,
      "Strawberry",
      "Red, small fruit which has 'Berry' in its name but is really a 'Nut'.",
    );

    try {
      await _fruitRepository.add(apple);
      // await _fruitRepository.delete({"id": 3});
      fruits = await _fruitRepository.all();
    } catch (e) {
      print("unable to ADD new Object");
    }

    try {
      fruits = await _fruitRepository.all();
    } catch (e) {
      print("unable to delete Object");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DPA Test"),
      ),
      body: DataTable(
        columns: [
          DataColumn(
            label: Text("Id"),
            numeric: true,
          ),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Description")),
        ],
        rows: fruits
            .map(
              (Fruit f) => DataRow(cells: [
                DataCell(Text("${f.id}")),
                DataCell(Text("${f.name}")),
                DataCell(Text("${f.description}")),
              ]),
            )
            .toList(),
      ),
    );
  }
}
