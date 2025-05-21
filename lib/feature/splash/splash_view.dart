import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/icon_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

//Ne kadar splash ekranı basic olsa bile comsumer widget kullandık yani statelessin riverpod halını
//Burada cok rıverpod ıle ılgılı ıslem yapmayacak da olsak best practice oldugu için kullanıyoruz.
//ConsumerWidget kullanmak, kodun ileride daha kolay yönetilebilir ve değiştirilebilir
//olmasını sağlayan proaktif bir yaklaşımdır. Belki ileride kullanmak isteyebiliriz.
class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            IconConstants.logo.toImage,
            //texthemeya gıttık googledan ve bızım textın boyutu 24 oldugu ıcın
            //24 e karsılık gelen texttheme yazı tıpını kullanıyoruz
            //Bızım textımız bold ve beyaz yapıldıgı ıcın copywıth metodu ıle bu propertylerı degıstırıyoruz

            //animasyonlu splah ekranı yazısını ekledik animatedtextkit paketini kullanarak
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'StringConstants.appName',
                  textStyle: context.general.textTheme.headlineSmall?.copyWith(
                    color: ColorConstants.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          ],
        ),
      ),
    );
  }
}
