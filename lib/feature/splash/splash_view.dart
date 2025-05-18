import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/enums/icon_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            Image.asset(IconConstants.logo.toPng),
          ],
        ),
      ),
    );
  }
}