// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_firebase_news_app/product/enums/cache_items.dart';
import 'package:flutter_firebase_news_app/product/initialize/app_cache.dart';

class AuthenticationNotifier extends StateNotifier<AuthState> {
  AuthenticationNotifier(): super(AuthState());
  Future<void> fetchUserDetail(User? user) async {
    if (user == null) return;
     //Token, dijital dünyada kimlik kartı gibi düşünebilirsiniz. kullanıcının ID Token'ını alır ve yazdırır.
     // internet üzerinde "Ben bu kullanıcıyım" demenin yoludur.Token geçici - çalınsa bile belirli süre sonra işe yaramaz
     //mesela WhatsApp'ta: Mesaj gönderirken token ile kimliğiniz doğrulanır
     //Bu mesajı gerçekten bu kişi mi gönderiyor?" kontrolü, ya da netflixte premıum uye mı kontrolu
     final token=await user.getIdToken();
     await tokenSaveCache(token);
     tokenReadCache();
     state=state.copyWith(isRedirect: true);

  }


  Future<void> tokenSaveCache(String? tokenValue) async {
    await CacheItems.token.write(tokenValue ?? '');
    
  }
  

  String tokenReadCache() {
    return CacheItems.token.read ?? '';
    
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

 */