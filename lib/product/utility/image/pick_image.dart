import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

//XFile = Dosya Referansı (Dosyanın kendisi değil!) Uint8List = Dosyanın Kendisi (Binary data)
//Neden XFile'da Kalmadı? Dosya Yolu Problemi: // Dosya yolu: "/temporary/cache/scaled_image_picker123.jpg"
//Uygulama yeniden başlatılırsa Bu dosya yolu artık geçersiz olabilir XFile farklı platformlarda farklı çalışır
// Android, ios, webde. Uint8List her platformda aynıdır. XFile dosya yolunu tutar Dosya silinirse = resim kaybolur
//Uint8List - resmin kendisini tutar Dosya silinse bile resim hafızada!
class PickImage {
  final ImagePicker _picker = ImagePicker();
  static bool _isActive = false;  // Static değişken ile kontrol
    //readAsBytes() metodu bir dosyayı (bu durumda resmi) byte dizisi (Uint8List) olarak okur ve hafızaya yükler.
    //Seçilen resmi byte formatında hafızaya alır bunun amacı  Resmi göstermek, manipüle etmek, 
    //boyutlandırmak veya format değiştirmek , Firebase Storage'a veya başka bir servise yüklemek için
  Future<Uint8List?> pickImageFromGallery() async {
    // Eğer zaten aktifse, işlemi durdur
    if (_isActive) {
      print("Image picker zaten aktif, lütfen bekleyin...");
      return null;
    }
    
    try {
      _isActive = true;  // İşlemi aktif olarak işaretle
      
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      
      //readAsBytes() metodu bir dosyayı (bu durumda resmi) byte dizisi (Uint8List) olarak okur ve hafızaya yükler.
      //Seçilen resmi byte formatında hafızaya alır bunun amacı  Resmi göstermek, manipüle etmek, 
      //boyutlandırmak veya format değiştirmek , Firebase Storage'a veya başka bir servise yüklemek için
      return await image?.readAsBytes();
      
    } catch (e) {
      print("Resim seçme hatası: $e");
      return null;
    } finally {
      _isActive = false;  // İşlem bitti, durumu sıfırla
    }
  }
}