import 'package:shared_preferences/shared_preferences.dart';

//Bu sınıf, uygulama içindeki tüm cache işlemlerini yönetir.
//Shared preferences kullanarak token saklama işlemi yaptık
class AppCache {
  AppCache._();
  //singleton yaptık sınıfı
  static final AppCache instance = AppCache._();
   late final SharedPreferences prefs;
   
   //shared preferences bailatma fonksiyonu yazdık
   Future<void> setUp() async {
     prefs = await SharedPreferences.getInstance();


   }

  
}