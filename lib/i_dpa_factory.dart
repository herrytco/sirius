import 'package:sirius/i_dpa_entity.dart';

abstract class DPAFactory<F extends DPAEntity> {
  F get entity;

  F fromMap(Map<String, dynamic> data);
}
