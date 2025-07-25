import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/splash/splash_provider.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/icon_constants.dart';
import 'package:flutter_firebase_news_app/product/mixins/splash_view_listen_navigate.dart';
import 'package:flutter_firebase_news_app/product/widget/text/wavy_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

//ConsumerWidget kullanmak, kodun ileride daha kolay yönetilebilir ve değiştirilebilir
//olmasını sağlayan proaktif bir yaklaşımdır. Belki ileride kullanmak isteyebiliriz.
//Providerı dinleyebilmek için dinlediğimiz sınıfı ConsumerStatefulWidgetdan, Consumerstateşessten turetırız.
//ConsumerStatelessWidget, klasik StatelessWidget gibi davranır ama içinde ref.watch(...) çağrısı yapabilmeni sağlar.
//Provider'ın state’i değişirse, build metodu yeniden çağrılır.
//Kendi içinde widget’a ait local (geçici) bir state varsa (örneğin bir TextEditingController, AnimationController, 
//initState, vs.) işte o zaman ConsumerStatefulWidget kullanman gerekir.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

//SplashProvider state'i yönetecek değiştirecek olan sınıf. Statenotifier sınıfından türer
//Ref başka providerlara da erişebilir. Bir provider içinden diğer provider'lara erişmek için kullanılır.
//SplashState UI’da kullanılan veri (ne gösterileceğini belirler).
//Uygulamanın "anlık durumu"nu tutan veri sınıfı. 
class _State extends ConsumerState<SplashView> with SplashViewListenMixin{

  final splashProvider = StateNotifierProvider<SplashProvider,SplashState>((ref) {
    return SplashProvider();
  });

  //ref.watch Değeri okur ve takip eder
  //Provider değeri değiştiğinde widget'ı otomatik olarak yeniden build eder
  //Değeri doğrudan döndürür, bu yüzden bir değişkene atayabilirsiniz
  
  //ref.listen() Değişiklikleri dinler ama değeri döndürmez Değer değiştiğinde widget'ı yeniden build etmez
  //Değişiklikler olduğunda belirli bir aksiyon gerçekleştirir
  //Yan etkiler (navigasyon, dialog gösterme, toast mesajı) için kullanılır
  @override
  void initState() {
    super.initState();
    ref.read(splashProvider.notifier).checkApplicationVersion('1.0.0');
    
    
  }
 
  
  //build metodu dışında initstate veya baska bır fonksıyonda ref kullanılamaz  
  @override
  Widget build(BuildContext context) {
    listenAndNavigate(splashProvider);
    return Scaffold(
      backgroundColor: ColorConstants.purplePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconConstants.logo.toImage,
            //texthemeya gıttık googledan ve bızım textın boyutu 24 oldugu ıcın
            //24 e karsılık gelen texttheme yazı tıpını kullanıyoruz
            //Bızım textımız bold ve beyaz yapıldıgı ıcın copywıth metodu ıle bu propertylerı degıstırıyoruz

            //animasyonlu splah ekranı yazısını ekledik animatedtextkit paketini kullanarak
            Padding(
              padding: context.padding.onlyTopNormal,
              child: WavyBoldText(title: '${StringConstants.appName}'),
            ),
          ],
        ),
      ),
    );
  }
}

