import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_news_app/product/models/category.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';

class HomeLogic with FirebaseUtility {
  final TextEditingController titleController = TextEditingController();
  CategoryModel? _categoryModel;
  List<CategoryModel> _categories=[];
  List<CategoryModel> get categories=>_categories;

  void updateCategory(CategoryModel categoryModel) {
    _categoryModel = categoryModel;
  }

  void dispose() {
    titleController.dispose();
    _categoryModel = null;
  }

  Future<void> fetchListCategory() async {
    final response = await fetchList<CategoryModel, CategoryModel>(
      CategoryModel(),
      FirebaseCollections.category,
    );

    _categories=response ?? [];
  }
}
