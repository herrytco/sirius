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
      _fruitRepository.add(apple);
    } catch (e) {
      // print("UNABLE TO ADD new Object because of: $e");
    }

    fruits = await _fruitRepository.all();

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
