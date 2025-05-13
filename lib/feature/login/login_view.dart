import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/login/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/* class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        //bunu bir padding sınıfı yaparak hepsini oradan da çekebilirdik ama onun yerine kartal paketinin (extension paketi) bu gücünü kullandık
        padding: context.padding.low,
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}

*/

// Statefulldan farklı olarak ConsumerState geldi demek ki riverpod üzerinde yapacağımız bir işlem
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {


  final loginProvider = StateNotifierProvider<LoginProvider,int>((ref) {
    return LoginProvider();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(ref.watch(loginProvider).toString()),
    );
  }
}

// Firebasede bir kullanıcıya ait bilgileri bir dokumanda tutuyoruz bu okumayı kolaylastırır
// Fakat güncellemek ısteyınce bu bıraz daha zor olacaktır

//Image upload, kullanıcının cihazındaki bir resmi uygulamanın sunucularına yüklemesi işlemidir.
//Firestore'da büyük dosyaları saklamak veritabanını yavaşlatır, Dosya saklamak için tasarlanmamıştır
//Storage, dosyaları optimize edilmiş şekilde saklar ve CDN üzerinden hızlı dağıtım sağlar
//Firestore dökümanında sadece Storage'daki görselin URL'i tutulur


// Flutterfire configure komutu calıstırınca bıze gelen bazı google servıces ve .plist dosyalarına ignore ekledik
// Yani bu dosyaların git tarafından izlenmemesini sağlamış olduk
// Bu, genellikle gizli bilgiler içeren veya her kullanıcı için farklı olabilecek dosyalar için yapılır
// FlutterFire CLI, firebase_options.dart gibi dosyaları oluştururken, bu dosyaların genellikle her kullanıcı 
// için farklı olabileceğini ve bu nedenle sürüm kontrolüne dahil edilmemesi gerektiğini düşünür. 
// Bu nedenle, bu dosyaları .gitignore dosyasına eklemek yaygın bir uygulamadır..
