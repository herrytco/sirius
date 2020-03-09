import 'package:sirius/i_dpa_repository.dart';
import 'package:sirius/dpa.dart';
import 'fruit.dart';
import 'fruit_factory.dart';
import 'package:sqflite/sqflite.dart';

class FruitRepository extends DPARepository<Fruit, FruitFactory> {
  FruitRepository() : super(FruitFactory());

  Future<List<Fruit>> largeFruits() async {
    Database db = await DPA.instance.database;

    List<dynamic> rows = await db.query(
      tableName,
      where: "weight > 2",
    );

    return rows.map((e) => entityFactory.fromMap(e)).toList();
  }
}
