import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_news_app/product/models/recommended.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';

class HomeNotifier extends StateNotifier<HomeState> with FirebaseUtility{
  HomeNotifier(): super(HomeState());

  List<Tag>? _fullTextTagList= [];
  List<Tag>? get fullTextTagList => fullTextTagList;

   Future<void> fetchNews() async {
      final items=await fetchList<News,News>(News(),FirebaseCollections.news);
      if(items!=null){
        state=state.copyWith(newsList: items);
      }

  }

  Future<void> fetchRecommended() async {
      final items=await fetchList<Recommended,Recommended>(Recommended(),FirebaseCollections.recommended);
      if(items!=null){
        state=state.copyWith(recommendedList: items);
      }

  }



  Future<void> fetchTags() async {

    final items=await fetchList<Tag,Tag>(Tag(),FirebaseCollections.tag);
    if(items!=null){
      state=state.copyWith(tagList: items);
    }

    _fullTextTagList=items ?? [];


    
    /*CollectionReference tagCollectionsReference = FirebaseCollections.tag.reference;
    final response =await  tagCollectionsReference
        //Tip vermemiz daha korumalı bir alan sunacaktır
        .withConverter<Tag>(
          fromFirestore: (snapshot, options) {
            return Tag().fromFirebase(snapshot);
          },
          toFirestore: (value, options) {
            if (value == null)
              throw FirebaseCustomException(description: "$value not null");
            return value is Tag
                ? value.toJson()
                : throw FirebaseCustomException(
                    description: "$value is not Tag",
                  );
          },
        )
        //Kodda kullanılan get() fonksiyonu, Firestore'dan bir koleksiyondaki tüm belgeleri çeker.
        .get();

        if (response.docs.isNotEmpty) {
          final values=response.docs.map((e) => e.data()).toList();
          //Eski state'in bir kopyasını alıyor,sadece tagList kısmını yeni values ile değiştiriyor,
          //Sonra o yeni kopyayı tekrar state değişkenine atıyor. Diğer alanları (örneğin isLoading) değiştirmez, olduğu gibi alır
          state = state.copyWith(tagList: values,);
        }*/



  }

  void updateSelectedTag(Tag? tag) {
    if (tag != null) {
      state=state.copyWith(selectedTag: tag);
    }
    else{
      return;
    }
  }

  
  //isloadıngı yukarıda yazmadık cunku metodları kendı ısı dısına cıkarmamalıyız
  //Burada Sırayla çalışıyor - her biri diğerinin bitmesini bekliyor!
  Future<void> fetchAndLoad() async {
    state = state.copyWith(isLoading: true);
    //Eğer bu 3 metodu aynı anda hepsi başlasın yani paralel çalışsın istersek future.wait kullanabiliriz
    //Tabi bunu sayfa bağımlılığımız yoksa yapabiliriz yani ornegın ılk cekılen fetchnewsten bellı degerlerı alıp
    //sonra dıgerlerı bu degerlerı kullanarak data cekme ıslemı yapacaksa bu bagımlılık olur ve sırayla yapılması gerekır
    //Bunu yapmak ıcın future.wait kullanılır cunku bırbırlerıne bır bagımlılıkları yoktur
    //Boylelıkle 3 unu de aynı anda future queue (kuyruguna) koyar ve calıstırır
    //Future.wait([...]) ise bir bekleme noktası (checkpoint) oluşturur:
    //Bu fonksiyonlar asenkron (async) ve await kullanılmadığı için, Dart beklemez, başlatır ve sonraki satıra hemen geçer!
    
    //yani 3 u eszamanlı calısır ve hepsi bitene kadar bekler ardından diger koda gecer
    await Future.wait([
      fetchNews(),
      fetchTags(),
      fetchRecommended(),
    ]);
    state = state.copyWith(isLoading: false);

  }

  
  
}

class HomeState extends Equatable {


  final List<News>? newsList;
  final List<Tag>? tagList;
  final List<Recommended>? recommendedList;
  bool? isLoading;
  final Tag? selectedTag;

  HomeState({this.newsList,this.tagList,this.isLoading,this.recommendedList,this.selectedTag});
  @override
  // TODO: implement props
  List<Object?> get props => [newsList, isLoading, tagList,recommendedList,selectedTag];
  

  HomeState copyWith({
    List<News>? newsList,
    bool? isLoading,
    List<Tag>? tagList,
    List<Recommended>? recommendedList,
    Tag? selectedTag,
  }) {
    return HomeState(
      newsList: newsList ?? this.newsList,
      isLoading: isLoading ?? this.isLoading,
      tagList: tagList ?? this.tagList, 
      recommendedList: recommendedList ?? this.recommendedList,
      selectedTag: selectedTag ?? this.selectedTag,
    );
  }
}
