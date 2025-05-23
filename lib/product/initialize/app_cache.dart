import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  AppCache._();
  //sibgleton yaptık sınıfı
  static final AppCache instance = AppCache._();
   late final SharedPreferences prefs;

   Future<void> setUp() async {
     prefs = await SharedPreferences.getInstance();


   }

  
}