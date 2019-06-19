import 'package:flutter/material.dart';
import '../model/category_model_entity.dart';

class ChildCategory with ChangeNotifier {
  List<CategoryModelDataBxmallsubdto> childCategoryList = [];

  setChildCategory(List<CategoryModelDataBxmallsubdto> list) {
    CategoryModelDataBxmallsubdto all = CategoryModelDataBxmallsubdto(mallSubId: '00',mallSubName: '全部', mallCategoryId: '00', comments: 'null');
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }
}
