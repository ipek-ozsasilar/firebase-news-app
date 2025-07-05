import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firebase_news_app/product/enums/cache_items.dart';

class AuthenticationNotifier extends StateNotifier<AuthState> {
  AuthenticationNotifier(): super(AuthState());
  //User firebase_authdan gelır Flutter'da firebase_auth paketi kullanıldığında, 
  //giriş yapmış kullanıcıya ait bilgiler User sınıfı üzerinden erişilir.
  Future<void> fetchUserDetail(User? user) async {
    if (user == null) return;
     //Token, dijital dünyada kimlik kartı gibi düşünebilirsiniz. kullanıcının ID Token'ını alır ve yazdırır.
     // internet üzerinde "Ben bu kullanıcıyım" demenin yoludur.Token geçici - çalınsa bile belirli süre sonra işe yaramaz
     //mesela WhatsApp'ta: Mesaj gönderirken token ile kimliğiniz doğrulanır
     //Bu mesajı gerçekten bu kişi mi gönderiyor?" kontrolü, ya da netflixte premıum uye mı kontrolu

     //getIdToken metodu, kullanıcının kimliğini doğrulamak için Firebase
     //Authentication paketi tarafından sağlanan bir token alır.
     //Giriş yapmış kullanıcıya ait ID Token'ı getirir. JWT formatındadır (JSON Web Token)
     //Firebase tarafından imzalanmıştır Backend tarafında "Bu kullanıcı gerçekten kim?" kontrolü için kullanılır.
     //Token’lar yaklaşık 1 saat geçerlidir.Süresi dolduğunda otomatik olarak yenilenir.
     //Dilersen getIdToken(refresh: true) diyerek elle yenisini de alabilirsin.
     //token kullanıcı kımlıgını tesıl eder ve backend'e göndeririz.
     //SDK sadece Firestore / Storage gibi kendi servisleri için token'ı arka planda kullanır.
     //Ancak sen token'ı başka bir yerde kullanmak istiyorsan (örneğin kendi backend API'ine göndermek),
     //o zaman senin manuel olarak getIdToken() çağırman gerekir.
     //kımınn  hangı verıyı cekebılecegını yetkılendırıyoruz dıyebılırız
     //getIdToken() çağırdığında, Firebase'in senin için önceden oluşturup bellekte tuttuğu ID token’ı almış
     //oluyorsun. an yeni bir token üretmiyorsun, sadece hazır olanı alıyorsun (veya istersen yenisini alıyorsun).
     final token=await user.getIdToken();
     await tokenSaveCache(token);
     tokenReadCache();
     state=state.copyWith(isRedirect: true);

  }

  //Kullanıcı uygulamayı kapatıp tekrar açtığında:
  //FirebaseAuth.instance.currentUser dolu olabilir ama bazen getIdToken() çağırmak zaman alabilir.
  //O sırada önbellekten token’ı hızlıca okuruz.Firebase zaten token’ı tutuyor ama senin ulaşımın 
  //için değil, kendi sistemleri için tutuyor.Senin mobil uygulaman, o token’a erişmek için her seferinde:
  //getIdToken şeklinde elle istemek zorunda. Firebase uyg tekrar baslasa bıle kullanıcıyı hatırlar
  //tokenı bellekte tutar. Ama cachete hazır tutmaz ve sana vermez getIdToken() bazı durumlarda 
  //200-500ms sürebilir. Sen “hızlı erişim” istersen kendin cache’e yazarsın.
  //Senin "cache" diye yazdığın şey cihazın lokal (yerel) depolama alanıdır.
  //SharedPreferences veya secure_storage → diskte kalır, uygulama kapansa da silinmez.
    Future<void> tokenSaveCache(String? tokenValue) async {
    await CacheItemsKey.token.write(tokenValue ?? '');
    
  }
  

  String tokenReadCache() {
    return CacheItemsKey.token.read ?? '';
    
  }
}


class AuthState extends Equatable {
   final bool isRedirect;

   AuthState({this.isRedirect=false});
  @override
  // TODO: implement props
  List<Object> get props => [isRedirect];
  

  AuthState copyWith({
    bool? isRedirect,
  }) {
    return AuthState(
      isRedirect: isRedirect ?? this.isRedirect,
    );
  }
}

/*
   Internet nasıl çalışır:
1. Sayfa yenilenir → Bağlantı kopar
2. Yeni istek → Yeni bağlantı
3. Sunucu: "Sen kimsin?" (Unutuyor!)

   Token ile:
1. İlk giriş: Şifre + kullanıcı adı
2. Token alıyorsun: "xyz123abc"
3. Sonraki işlemler: Sadece token


Token olmadan (güvensiz):
Haber okurken, profil güncellerken, çıkış yaparken vs her seferinde şifre gönderiliyor
- username: "ali@mail.com"
- password: "123456"  // Her seferinde şifre göndermek güvenli değil hackerlar yakalayabilir
Token ile (güvenli):
token: "eyJhbGciOiJIUzI1NiIs..."  // Şifre gizli kalıyor

// ❌ GEREKSIZ - Firebase otomatik hallediyor
final token = await user.getIdToken();
FirebaseFirestore.instance.collection('news').get(); // Token'ı sen vermiyorsun bile!

// ✅ GEREKLİ - Kendi backend'in için
final token = await user.getIdToken();
final response = await dio.get(
  'https://myapi.com/news',
  options: Options(headers: {'Authorization': 'Bearer $token'}),
);

 */