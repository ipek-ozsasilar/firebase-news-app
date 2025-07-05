import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/auth/authentication_view.dart';
import 'package:flutter_firebase_news_app/feature/home/home_create/home_create_view.dart';
import 'package:flutter_firebase_news_app/feature/home/home_provider.dart';
import 'package:flutter_firebase_news_app/feature/home/sub_view/home_search_delegate.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/image_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/recommended.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:flutter_firebase_news_app/product/widget/card/home_browse_card.dart';
import 'package:flutter_firebase_news_app/product/widget/card/recommended_card.dart';
import 'package:flutter_firebase_news_app/product/widget/text/subtitle_text.dart';
import 'package:flutter_firebase_news_app/product/widget/text/title_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

part 'sub_view/home_chip.dart';

//bu provider global kullanımı genelde yapılır
//sadece bu sayfadakılerın bu provıderı kullanması ıcın prıvate yaptık
//Dosyanın en üstünde her yerden erişilebilir
final _homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeView> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    //işin bitince controlerı dispose et
    //Aksi halde bellekte sızıntı yapabilir.
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    //ref.read(...) gibi bazı işlemler için ekranın (widget'ın) biraz hazırlık yapması gerekiyor.
    //Eğer hemen çalıştırırsan "daha hazır değilim" diye hata verebilir.
    //fetchAndLoad() fonksiyonunu hemen çalıştırma.Birkaç milisaniye bekle, ekran biraz hazırlansın.
    //Ama genelde initState → microtask → build gibi olur.Yani frame bıttıkten sonra bır logıc yapılır
    //Bu satırla, fetchAndLoad() fonksiyonu şu anda değil, bir sonraki mikro görev kuyruğunda (event loop sonunda) çalıştırılır.
    //İnitstate çalışır bittikten hemen sonra microtask çalışır
    // O anki senkron (eşzamanlı) işlemler biter bitmez, hemen sonra çalışır.
    //Yani: event queue'ya gitmeden önce, öncelikli olarak çalışır.
    Future.microtask(() {
      ref.read(_homeProvider.notifier).fetchAndLoad();
    });
    //Bu satır eşzamanlı, hemen çalışır. Önce super.initState() calısır sonra es zamanlı olan read okuması calısır
    //microtask -> Bu görev şu anda çalıştırılmaz, sadece microtask kuyruğuna eklenir.
    //initState biter	Artık method bitmiştir, sıradaki microtask'lar kontrol edilir ve çalışır

    //ref.listen oncekı ve sonrakı state karsılastırmaya da yarar , dınler, rebuıld etmez , sayfa gecıslerınde
    //kulllanılır genelde ve dıalog vs gosterır ardından ısı bıtınce otomatık olrak dıspose eder kendını
    // dınlemeyı bırakır. ref.Addlistener oncekı ve sonrakı state e ulasamaz , dınler, rebuıld etmez ekranı,
    // listen gıbı su ıslem gerceklesınce su olsun der ama kucuk ısler yapar controller.text guncelle ornegın vs gıbı
    //Ayrıca kendısının yok etmez manuel yapman gereklı Sen controller.text = "yeni değer" yazdığında, TextField’ın
    // içindeki controller kendisi rebuild ediyor (kendine bağlı olan TextField’ı güncelliyor).
    //Yani bu bir Widget rebuild'i değil, controller iç mekanizmasının yaptığı bir güncelleme.
    ref.read(_homeProvider.notifier).addListener((state) {
      if (state.selectedTag != null) {
        _controller.text = state.selectedTag?.name ?? '';
      }
    });
  }

  //image_picker paketiGaleriden resim veya video seçmek Kamera ile
  // anlık fotoğraf veya video çekmek için kullanılır.



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton.large(
        child: Icon(Icons.add),
        onPressed: () {
          context.route.navigateToPage(HomeCreateView());
                }
        ),
      //Flutter'da cihazın güvenli alanında içeriği göstermek için kullanılan bir widget'dır. Modern
      //cihazlardaki kesikler, kameralar ve sistem UI elementlerinin üzerine içerik gelmesini önler.
      //Eğer içerik yukarıya denk geliyor gözükmüyorsa vs bu wıdget kullanılabılır veya paddıng
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: context.padding.horizontalLow,
              children: [
                Header(
                  title: StringConstants.homeBrowse,
                  subtitle: StringConstants.homeDiscoverWorld,
                ),
                _CustomTextField(controller: _controller),
                //iç içe ıkı tane sonsuzluk olan wıdget kullanamazsın bu yuzden buraya sızedbox ıle sarmaladık
                //Ve widgetın ne kadar yer kapladığını söyledik
                _TagListView(),

                _BrowseHorizontalListView(),

                _RecommendedHeader(),

                _RecommendedListView(),
              ],
            ),

            if (ref.watch(_homeProvider).isLoading ?? false)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends ConsumerWidget {
  _CustomTextField({required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      onTap: () async {
        final tagList = ref.read(_homeProvider).tagList ?? [];
        if (tagList.isEmpty) {
          throw FirebaseCustomException(description: 'tags dont upload yet');
        }
        
        //showSearch, Flutter SDK içindeki yerleşik (built-in) bir fonksiyondur ve şunu yapar:
        //Ekrana tam sayfa bir arama UI’ı getirir (search bar + otomatik listeleme), kullanıcı
        // bir şey arayabilir, sonuçları görebilir ve seçim yapabilir.
        //showSearch() bir Future döner, çünkü: Kullanıcı için tam sayfa bir arama ekranı açıyor
        //Kullanıcı ya bir öğe seçiyor, ya da geri çıkıyor. İşlem tamamlandığında bir sonuç dönüyor
        //delegate, yani "temsilci", arama ekranının UI'ını ve davranışını tanımlayan sınıftır.
        //Yani arama ekranını tagList’e göre çalıştır diyorsun.
        final response = await showSearch<Tag?>(
          context: context,
          delegate: HomeSearchDelegate(tagItems: tagList),
        );
        if (response != null) {
          //search fieldına yazılan tag değerine gidecek uygulama ve o tag actif olacak rengi degisecek
          ref.read(_homeProvider.notifier).updateSelectedTag(response);
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_outlined),
        suffixIcon: Icon(Icons.mic_outlined),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        fillColor: ColorConstants.grayLighter,
        filled: true,
        hintText: StringConstants.homeSearchHint,
      ),
    );
  }
}

class _TagListView extends ConsumerWidget {
  const _TagListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagItems = ref.watch(_homeProvider).tagList ?? [];
    return SizedBox(
      height: context.sized.dynamicHeight(0.1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tagItems.length ?? 0,
        itemBuilder: (context, index) {
          final tagItem = tagItems[index];
          if (tagItem.active ?? false) {
            return _ActiveChip(tag: tagItem);
          }
          return _PassiveChip(tag: tagItem);
        },
      ),
    );
  }
}

class _BrowseHorizontalListView extends ConsumerWidget {
  const _BrowseHorizontalListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsItem = ref.watch(_homeProvider).newsList ?? [];
    return SizedBox(
      height: context.sized.dynamicHeight(0.3),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsItem.length ?? 0,
        itemBuilder: (context, index) {
          return HomeBrowseCard(newsItem: newsItem[index]);
        },
      ),
    );
  }
}

class _RecommendedHeader extends StatelessWidget {
  const _RecommendedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(value: StringConstants.homeRecommendTitle),
          TextButton(
            onPressed: () {},
            child: SubTitleText(value: StringConstants.homeSeeAll),
          ),
        ],
      ),
    );
  }
}

class _RecommendedListView extends ConsumerWidget {
  const _RecommendedListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = ref.watch(_homeProvider).recommendedList ?? [];
    return SizedBox(
      height: 700,
      child: ListView.builder(
        //Normal şartlarda ListView, mevcut olan tüm alanı kaplamaya çalışır. Yani parent
        //widget'ın verdiği alanın tamamını kullanır ve sonsuz yükseklikte genişlemeye çalışır.
        //shrinkWrap: true olduğunda ListView: Sadece içeriği kadar yer kaplar
        //ama bu shrinkwrap true olduğunda bütün içeriği tek seferde hesapladığı için performans düşebilir.
        //Çünkü shrinkWrap: true olduğunda tüm elemanları önceden ölçmek zorunda kalır. lazy loading etkısı azaltır.
        shrinkWrap: true,
        //Scroll sınırlarında durur (bounce/sekme efekti yoktur)
        //Glow efekti gösterir (Android'deki mavi parıldama) Over-scroll yapmaz
        //physics parametresi, scroll'un: Nerede duracağını,Hangi hızda yavaşlayacağını,
        //Üste/alta çarpınca sekme mi yapacağını, parıldama mı olacağını İki parmakla aynı anda kaydırma gibi özellikleri belirler.
        physics: ClampingScrollPhysics(),
        itemCount: values.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: context.padding.onlyBottomLow,
            //normalde listtile kullanılır ama row ile yapıyoruz çünkü listtile kullanırsak resmin sizenı oturtamadıgımı gorunce row yapalım dedık
            //tum componentler tum hepsıne uyacak dıye bır sey yok bazen bariz listtile gibi gözukse de degerler vs uymayabılır
            child: RecommendedCard(recommended: values[index]),
          );
        },
      ),
    );
  }
}



