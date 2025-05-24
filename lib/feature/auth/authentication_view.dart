import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/auth/authentication_provider.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/theme/app_theme.dart';
import 'package:flutter_firebase_news_app/product/widget/text/subtitle_text.dart';
import 'package:flutter_firebase_news_app/product/widget/text/title_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kartal/kartal.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends ConsumerState<AuthenticationView> {
  final AuthProvider = StateNotifierProvider<AuthenticationNotifier, AuthState>(
    (ref) {
      return AuthenticationNotifier();
    },
  );

  @override
  void initState() {
    super.initState();
    //Firebase Authentication'da bir kullanıcı bir kez oturum açtığında, oturum otomatik olarak cihazda kalıcı hale gelir.
    // Yani kullanıcıyı manuel olarak çıkış yaptırmadığın sürece, FirebaseAuth.instance.currentUser daima o kullanıcıyı döndürür.
    //Sayfayı yenilemek veya uygulamayı yeniden başlatmak logout işlemi değildir.
    //print(FirebaseAuth.instance.currentUser);
    checkUser(FirebaseAuth.instance.currentUser);
    
  }
  void checkUser(User? user) {
    ref
        .read(AuthProvider.notifier)
        .fetchUserDetail(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //loginview widgetı firebase_auth_ui kütüphanesinden geliyor
      //firebase kutuphanesındne gelen wıdget oldugunu bellı etmek kendı widgetla
      //paketın yanına as firebase dedık ve bu sekılde bu pakete aıt bır wıdget oldugunu soyledık

      //FirebaseUI Login ekranı içinde kullanılır.
      //actions parametresiyle, kullanıcının giriş/kayıt durumunu izleyen fonksiyonlar tanımlarsın
      body: firebase.FirebaseUIActions(
        actions: [
          //Bu, sadece kullanıcı başarıyla giriş yaptığında veya kayıt olduktan sonra otomatik olarak tetiklenir.
          //<SignedIn> generic tipi sayesinde sadece SignedIn olayını yakalarsın (yani oturum açma anı).
          firebase.AuthStateChangeAction<firebase.SignedIn>((context, state) {
            //başarılı giriş yapan kullanıcının bilgilerini (FirebaseUser) kontrol eder.
            if (state.user != null) {
              print('okay'); // yani bu adam bu sisteme kayıt oldu
              checkUser(state.user);
            }
          }),
        ],

        //LoginView FirebaseUI paketinin hazır bir kullanıcı giriş ekranıdır.
        child: SafeArea(
          child: Center(
            //Bu tarz kullanım, sadece LoginView bileşeni için özel bir tema uygulamak istediğin anlamına gelir.
            //Uygulamanın genel temasını bozmadan, yalnızca bu bileşende görünümü özelleştirebilirsin.
            child: Theme(
              //Mesela bu sekılde sadece bu bilesenın butonunun rengını degısebılıriz
              //loginview bılesenının dogrudan style propertysı olmadıgı ıcın dogrudan buton rengını
              //degıstıremedıgımız ıcın bu sekılde yapabılıyoruz
              data: AppTheme.authButtonTheme(context),
              child: Padding(
                padding: context.padding.low,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Header(title: StringConstants.loginWelcomeBack, subtitle: StringConstants.loginWelcomeDetail),
                    Padding(
                      padding: context.padding.normal,
                      child: firebase.LoginView(
                        //showTitle: false,
                        action: firebase.AuthAction.signIn,
                        //providers kısmında Firebase Authentication için yapılandırılmış tüm kimlik doğrulama sağlayıcılarını (providers) otomatik olarak alır
                        //Örneğin, hem email/password hem Google auth etkinleştirdiyseniz, bu fonksiyon otomatik olarak her iki yöntemi de kullanıma hazır hale getirir.
                        //O uygulama için yapılandırılmış giriş sağlayıcılarını (providers) getirir.
                        providers: firebase.FirebaseUIAuth.providersFor(
                          //Şu anki Firebase uygulamasını temsil eder.
                          FirebaseAuth.instance.app,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        StringConstants.loginContinueToApp,
                        textAlign: TextAlign.center,
                        style: context.general.appTheme.textTheme.bodySmall
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
   Header({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          value: title,
        ),

        Padding(
          padding: context.padding.onlyTopLow,
          child: SubTitleText(value:subtitle,)
        ),
      ],
    );
  }
}


