import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_news_app/product/models/category.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';
import 'package:flutter_firebase_news_app/product/utility/image/pick_image.dart';


// Haber oluşturma sayfasının iş mantığını yöneten sınıf
class HomeLogic with FirebaseUtility {
  final TextEditingController titleController = TextEditingController();
  //seçilen kategori
  CategoryModel? _categoryModel;
  //Form validasyonu için anahtar
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //tüm kategoriler
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  // 0-255 arasında sayılar içeren liste Resmi sayı listesine, byte a donusturunce kullanırız bunu
  //Resmi sayı listesi olarak saklama yöntemidir photo dıye bır degısken yktur resmi sayı listesıne donusturulmus hale
  Uint8List? _selectedFileBytes;
  bool isValidateAllForm = false;
  Uint8List? get selectedFileBytes => _selectedFileBytes;
  void updateCategory(CategoryModel categoryModel) {
    _categoryModel = categoryModel;
  }


  Future<void> pickAndCheck(ValueSetter<bool> onUpdate) async {
    //Gleriden reim seç
   _selectedFileBytes=await PickImage().pickImageFromGallery();
   //Form validasyonunu kontrol et bos callback
   checkValidateAndSave((value){});
   //UI'a "işlem tamamlandı" sinyali gönder burada callback çalışıyor
   //resim seçildiği için ui 'a kendini güncellemesini söylüyor
   onUpdate.call(true);
  }
  
  //ValueSetter aslında bir callback function tipi!
  //setState kullanmadan bir bileşeni dışarıdan kontrol etmenin mantıklı yollarından biridir.
  //Özellikle StatefulWidget’lar arasında haberleşme gerekiyorsa çok işe yarar.
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
