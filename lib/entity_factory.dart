import 'package:flutter_shop/model/category_model_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "CategoryModelEntity") {
      return CategoryModelEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}