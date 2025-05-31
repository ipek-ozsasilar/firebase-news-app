import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_news_app/product/models/category.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';
import 'package:flutter_firebase_news_app/product/utility/image/pick_image.dart';
import 'package:image_picker/image_picker.dart';

class HomeLogic with FirebaseUtility {
  final TextEditingController titleController = TextEditingController();
  CategoryModel? _categoryModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  Uint8List? _selectedFileBytes;
  bool isValidateAllForm = false;
  Uint8List? get selectedFileBytes => _selectedFileBytes;
  void updateCategory(CategoryModel categoryModel) {
    _categoryModel = categoryModel;
  }

  
  Future<void> pickAndCheck(ValueSetter<bool> onUpdate) async {
   _selectedFileBytes=await PickImage().pickImageFromGallery();
   checkValidateAndSave((value){});
   onUpdate.call(true);
  }

  void checkValidateAndSave(ValueSetter<bool> onUpdate) {
     final value=isValidateAllForm = formKey.currentState?.validate() ?? false;

     if (value!=isValidateAllForm && selectedFileBytes!=null) {
      isValidateAllForm=value;
       onUpdate.call(value);
     }
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

    _categories = response ?? [];
  }

  void Save() {
    
  }
}
