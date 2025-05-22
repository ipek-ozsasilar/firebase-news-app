// Bu klasorde benim initiliazer kodlarım olacak
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/firebase_options.dart';


// Burada bir ekstra degısken vs kullanılmayacagı ıcın constructorı prıvate yaptık
// Bir data girişini vs de engellemek ıcın ımmutable yaptık sınıfı
// Bu init işlemini yaparak firebase'e connection saglamıs olduk 
// Bu kısım daha giriş ekranına gelmeden çalışır
@immutable
class ApplicationStart {
  ApplicationStart._();
  static Future<void> init() async {
    //Firebase gibi cihazın kendi özelliklerini kullanan servisler, Flutter'ın motorunun tam olarak başlamasını bekler
    //Bu kod, "Hey Flutter, motorunu tam olarak başlat, ben Firebase'i kullanacağım" demek gibidir
    WidgetsFlutterBinding.ensureInitialized();
    //Bu satır Firebase'i başlatır bu kod firebase core paketi ile gelir
    await Firebase.initializeApp(
      //Bu kısım, Firebase'in hangi platformda (Android, iOS, Web) çalıştığını otomatik olarak algılar
      options:DefaultFirebaseOptions.currentPlatform, 
    );

    //Firebase authentıcatıon kullanacagımız ıcın onceden bunu set etmemız gerekıyor yıne uygulama baslamadan
    //Uygulamanda hangi giriş yöntemlerini (authentication providers) kullanmak istediğini tanımlar.
    FirebaseUIAuth.configureProviders([
      //Kullanıcının email ve şifre ile giriş yapmasını sağlar.
      EmailAuthProvider(),
      //clientid yı google info.json dosyasından alabiliriz
      GoogleProvider(clientId: ''),
    ]);
  
  }
}
