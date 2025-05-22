import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends ConsumerState<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //loginview widgetı firebase_auth_ui kütüphanesinden geliyor
      //firebase kutuphanesındne gelen wıdget oldugunu bellı etmek kendı widgetla
      //paketın yanına as firebase dedık ve bu sekılde bu pakete aıt bır wıdget oldugunu soyledık

      //LoginView FirebaseUI paketinin hazır bir kullanıcı giriş ekranıdır.
      body: firebase.LoginView(
        action: firebase.AuthAction.signIn,
        //providers kısmında Firebase Authentication için yapılandırılmış tüm kimlik doğrulama sağlayıcılarını (providers) otomatik olarak alır
        //Örneğin, hem email/password hem Google auth etkinleştirdiyseniz, bu fonksiyon otomatik olarak her iki yöntemi de kullanıma hazır hale getirir.
        //O uygulama için yapılandırılmış giriş sağlayıcılarını (providers) getirir.
        providers: firebase.FirebaseUIAuth.providersFor(
          //Şu anki Firebase uygulamasını temsil eder.
          FirebaseAuth.instance.app,
        ),
      ),
    );
  }
}
