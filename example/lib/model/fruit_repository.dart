import 'package:sirius/i_dpa_repository.dart';
import 'fruit.dart';
import 'fruit_factory.dart';

class FruitRepository extends DPARepository<Fruit, FruitFactory> {
  FruitRepository() : super(FruitFactory());
}
