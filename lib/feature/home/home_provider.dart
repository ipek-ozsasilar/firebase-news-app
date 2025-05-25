// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(): super(HomeState());

   Future<void> fetchNews() async {
    // FirebaseFirestore.instance ile Firestore servisine bağlanılır
    CollectionReference newsCollectionsReference = FirebaseCollections.news.reference;

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
    final response =await  newsCollectionsReference
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
        //Kodda kullanılan get() fonksiyonu, Firestore'dan bir koleksiyondaki tüm belgeleri çeker.
        .get();

        if (response.docs.isNotEmpty) {
          final values=response.docs.map((e) => e.data()).toList();
          state = state.copyWith(newsList:values );
        }



  }
  
  //isloadıngı yukarıda yazmadık cunku metodları kendı ısı dısına cıkarmamalıyız
  Future<void> fetchAndLoad() async {
    state = state.copyWith(isLoading: true);
    await fetchNews();
    state = state.copyWith(isLoading: false);

  }

  
  
}

class HomeState extends Equatable {


  final List<News>? newsList;
  bool? isLoading;

  HomeState({this.newsList,this.isLoading});
  @override
  // TODO: implement props
  List<Object?> get props => [newsList, isLoading];
  

  HomeState copyWith({
    List<News>? newsList,
    bool? isLoading,
  }) {
    return HomeState(
      newsList: newsList ?? this.newsList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
