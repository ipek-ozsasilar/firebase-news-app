import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/auth/authentication_view.dart';
import 'package:flutter_firebase_news_app/feature/home/home_provider.dart';
import 'package:flutter_firebase_news_app/feature/home/sub_view/home_search_delegate.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/image_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/recommended.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';
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
  ConsumerState<ConsumerStatefulWidget> createState() => _HomState();
}

class _HomState extends ConsumerState<HomeView> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    //ref.read(...) gibi bazı işlemler için ekranın (widget'ın) biraz hazırlık yapması gerekiyor.
    //Eğer hemen çalıştırırsan "daha hazır değilim" diye hata verebilir.
    //bazen bu işlemleri başlatmak için ekranın tamamen hazır olmasını beklememiz gerekir.
    //fetchAndLoad() fonksiyonunu hemen çalıştırma.Birkaç milisaniye bekle, ekran biraz hazırlansın.
    //Sonra çalıştır. Cunku initState içinde bazı işlemler erken yapılırsa hata çıkar.
    //Bazı durumlarda build() çok hızlı davranırsa, microtask build'ten sonra da çalışabilir.
    //Ama genelde initState → microtask → build gibi olur.Yani frame bıttıkten sonra bır logıc yapılır
    Future.microtask(() {
      ref.read(_homeProvider.notifier).fetchAndLoad();
    });

    ref.read(_homeProvider.notifier).addListener((state) {
      if (state.selectedTag != null) {
        _controller.text = state.selectedTag?.name ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //Flutter'da cihazın güvenli alanında içeriği göstermek için kullanılan bir widget'dır. Modern
      //cihazlardaki kesikler, kameralar ve sistem UI elementlerinin üzerine içerik gelmesini önler.
      //Eğer içerik yukarıya denk geliyor gözükmüyorsa vs bu wıdget kullanılabılır veya paddıng
      child: SafeArea(
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
  _CustomTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      onTap: () async {
        final tagList = ref.read(_homeProvider).tagList ?? [];
        if (tagList.isEmpty) {
          print("tagler henüz yüklenmedi");
        }

        final response = await showSearch<Tag?>(
          context: context,
          delegate: HomeSearchDelegate(tagItems: tagList),
        );
        if (response != null) {
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
  const _TagListView({super.key});

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
  const _BrowseHorizontalListView({super.key});

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
  const _RecommendedHeader({super.key});

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
  const _RecommendedListView({super.key});

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


