import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImageFromGallery() async {
  
     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //readAsBytes() metodu bir dosyayı (bu durumda resmi) byte dizisi (Uint8List) olarak okur ve hafızaya yükler.
    //Seçilen resmi byte formatında hafızaya alır bunun amacı  Resmi göstermek, manipüle etmek, 
    //boyutlandırmak veya format değiştirmek , Firebase Storage'a veya başka bir servise yüklemek için
     return await image?.readAsBytes();
  }


}