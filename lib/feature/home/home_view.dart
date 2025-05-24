import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/auth/authentication_view.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/widget/text/subtitle_text.dart';
import 'package:flutter_firebase_news_app/product/widget/text/title_text.dart';
import 'package:kartal/kartal.dart';

part 'sub_view/home_chip.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      //Flutter'da cihazın güvenli alanında içeriği göstermek için kullanılan bir widget'dır. Modern
      //cihazlardaki kesikler, kameralar ve sistem UI elementlerinin üzerine içerik gelmesini önler.
      //Eğer içerik yukarıya denk geliyor gözükmüyorsa vs bu wıdget kullanılabılır veya paddıng
      child: SafeArea(
        child: ListView(
          padding: context.padding.horizontalLow,
          children: [
            Header(
              title: StringConstants.homeBrowse,
              subtitle: StringConstants.homeDiscoverWorld,
            ),
            _CustomTextField(),
            //iç içe ıkı tane sonsuzluk olan wıdget kullanamazsın bu yuzden buraya sızedbox ıle sarmaladık
            //Ve widgetın ne kadar yer kapladığını söyledik
            _TagListView(),

            _BrowseHorizontalListView(),

            _RecommendedHeader(),

            _RecommendedListView(),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_outlined),
        suffixIcon: Icon(Icons.mic_outlined),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        fillColor: ColorConstants.grayLighter,
        filled: true,
        hintText: StringConstants.homeSearchHint,
      ),
    );
  }
}

class _TagListView extends StatelessWidget {
  const _TagListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(0.1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          if(index.isOdd){
            return _ActiveChip();
          }
          return _PassiveChip();
        },
      ),
    );
  }
}



class _BrowseHorizontalListView extends StatelessWidget {
  const _BrowseHorizontalListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(0.2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: context.padding.onlyRightNormal,
            child: Placeholder(),
          );
        },
      ),
    );
  }
}

class _RecommendedHeader extends StatelessWidget {
  const _RecommendedHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(value: StringConstants.homeRecommendTitle),
          TextButton(onPressed: (){}, child: SubTitleText(value: StringConstants.homeSeeAll)),
        ],
      ),
    );
  }
}

class _RecommendedListView extends StatelessWidget {
  const _RecommendedListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //Normal şartlarda ListView, mevcut olan tüm alanı kaplamaya çalışır. Yani parent
      //widget'ın verdiği alanın tamamını kullanır ve sonsuz yükseklikte genişlemeye çalışır.
      //shrinkWrap: true olduğunda ListView: Sadece içeriği kadar yer kaplar
      shrinkWrap: true,
      //Scroll sınırlarında durur (bounce/sekme efekti yoktur)
      //Glow efekti gösterir (Android'deki mavi parıldama) Over-scroll yapmaz
      physics: ClampingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: context.padding.onlyBottomLow,
          child: Placeholder(),
        );
      },
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:kartal/kartal.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Datayı okumak ve gostermek ıcın ıkı secenek var ya futurebuilder kullanmak
      // ikinci olarak da datayi init oldugu anda cekip setstate ile göstermek
      body: _HomeListView(),
    );
  }
}

class _HomeListView extends StatelessWidget {
  const _HomeListView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance ile Firestore servisine bağlanılır
    CollectionReference news = FirebaseFirestore.instance.collection('news');

    // withConverter, Firestore'dan gelen JSON verileri News modelimize dönüştürür yani gelen objeyı parse eder
    // fromFirestore: JSON'dan News nesnesine dönüştürür
    // toFirestore: News nesnesinden JSON'a dönüştürür

    //fromJson()	JSON verisini Dart modeline çevirir
    //withConverter()	Firestore verisini otomatik olarak modele çevirir ve tersini yapar
    //ID'yi sen eklemiyorsun, fromFirestore fonksiyonu zaten ekliyor. Model dönüşümü otomatik oluyor.
    //Get işlemi sonucu news koleksiyonundaki verilerin tamamı gelir. Yani tüm dokümanlar geliyor.
    //Firestore’dan veri çekmek için isteği gönderir.
    //Sonucu Future<QuerySnapshot<News>> tipinde bir “gelecek veri” olarak verir.
    //Future döner, yani henüz veriler değil, veriler geleceğine dair bir söz (promise/future) verir.
    final response = 
        news
            .withConverter(
              fromFirestore: (snapshot, options) {
                return News().fromFirebase(snapshot);
              },
              toFirestore: (value, options) {
                if (value == null)
                  throw FirebaseCustomException(description: "$value not null");
                return value is News
                    ? value.toJson()
                    : throw FirebaseCustomException(
                      description: "$value is not News",
                    );
              },
            )
            .get();

    //final List<News> allNews = response.docs.map((doc) => doc.data()).toList();
    return FutureBuilder(
      //get diyerek read işlemi yapacağız. Ama snapshot.data.Data() diyerek datayı alıp map e atmak sağlıklı değil
      //Her zaman önce internetten çekilecek datanın bir modelini oluşturarak onu kullanmak daha sağlıklı ve güvenlidir
      future: response,
    
      // AsyncSnapshot, future/stream'den gelen datanın durumunu ve verisini tutan bir sınıftır
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<News?>> snapshot,
      ) {
        //snapshot dediğimiz şey, response gelecekte döndüğünde onu sarmalayan bir nesnedir.
        switch (snapshot.connectionState) {
          //datanın farklı internetsiz, aktif vs vs durumlarında ona göre kod yazılır
          case ConnectionState.none:
            // TODO: Handle this case.
            return Placeholder();
          case ConnectionState.waiting:
            // TODO: Handle this case.
            return LinearProgressIndicator();
          case ConnectionState.active:
            // TODO: Handle this case.
            return LinearProgressIndicator();
          case ConnectionState.done:
            // TODO: Handle this case.
            if (snapshot.hasData) {
              // snapshot.data!  Yani bütün koleksiyonun verisi burada.
              //snapshot.data!.docs → Bütün dökümanların listesi
              //e.data() → Her bir dökümandan News modelini alırsın.
              //snpshot.data  Yani koleksiyonun tamamı
               final values=snapshot.data!.docs.map((e) => e.data()).toList();
               return ListView.builder(
                 itemCount: values.length,
                 itemBuilder: (BuildContext context, int index) {
                   return Card(
                    child: Column(
                      children: [
                         Image.network(
                          values[index]?.backgroundImage ?? "",
                          //kartal paketini kullanarak ekranın yuzde 10unu kapsayan bir alan oluşturuyoruz
                          height: context.sized.dynamicHeight(0.1),
                         ),
                         Text(values[index]?.title ?? "", style: context.general.textTheme.labelLarge,),
    
                      ],
                    ),
                   );
                 },
               );
            } else {
              return const SizedBox.shrink();
            }
        }
      },
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

*/
