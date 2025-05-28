// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';

class HomeNotifier extends StateNotifier<HomeState> with FirebaseUtility{
  HomeNotifier(): super(HomeState());

   Future<void> fetchNews() async {
      final items=await fetchList<News,News>(News(),FirebaseCollections.news);
      if(items!=null){
        state=state.copyWith(newsList: items);
      }

  }



  Future<void> fetchTags() async {

    final items=await fetchList<Tag,Tag>(Tag(),FirebaseCollections.tag);
    if(items!=null){
      state=state.copyWith(tagList: items);
    }

    
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

  
  //isloadıngı yukarıda yazmadık cunku metodları kendı ısı dısına cıkarmamalıyız
  Future<void> fetchAndLoad() async {
    state = state.copyWith(isLoading: true);
    await fetchNews();
    await fetchTags();
    state = state.copyWith(isLoading: false);

  }

  
  
}

class HomeState extends Equatable {


  final List<News>? newsList;
  final List<Tag>? tagList;
  bool? isLoading;

  HomeState({this.newsList,this.tagList,this.isLoading});
  @override
  // TODO: implement props
  List<Object?> get props => [newsList, isLoading, tagList];
  

  HomeState copyWith({
    List<News>? newsList,
    bool? isLoading,
    List<Tag>? tagList,
  }) {
    return HomeState(
      newsList: newsList ?? this.newsList,
      isLoading: isLoading ?? this.isLoading,
      tagList: tagList ?? this.tagList,
    );
  }
}
