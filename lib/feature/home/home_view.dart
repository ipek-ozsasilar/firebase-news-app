import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance ile Firestore servisine bağlanılır
    CollectionReference news = FirebaseFirestore.instance.collection('news');

    // withConverter, Firestore'dan gelen JSON verileri News modelimize dönüştürür yani gelen objeyı parse eder
    // fromFirestore: JSON'dan News nesnesine dönüştürür
    // toFirestore: News nesnesinden JSON'a dönüştürür
    final response = news.withConverter(
      fromFirestore: (snapshot, options) {
          final jsonBody= snapshot.data();
          if (jsonBody!=null) {
              return News.fromJson(jsonBody)..copyWith(id: snapshot.id);
            
          }
          return null;
      },
      toFirestore: (value,options){
        if (value==null) throw FirebaseCustomException(description: "$value not null");
        return value.toJson();
        }
    );
    return Scaffold(
      appBar: AppBar(),
      // Datayı okumak ve gostermek ıcın ıkı secenek var ya futurebuilder kullanmak
      // ikinci olarak da datayi init oldugu anda cekip setstate ile göstermek
      body: FutureBuilder(
        //get diyerek read işlemi yapacağız. Ama snapshot.data.Data() diyerek datayı alıp map e atmak sağlıklı değil
        //Her zaman önce internetten çekilecek datanın bir modelini oluşturarak onu kullanmak daha sağlıklı ve güvenlidir
        future: news.get(), 

        // AsyncSnapshot, future/stream'den gelen datanın durumunu ve verisini tutan bir sınıftır
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //datanın farklı internetsiz, aktif vs vs durumlarında ona göre kod yazılır
            case ConnectionState.none:
              // TODO: Handle this case.
              throw Placeholder();
            case ConnectionState.waiting:
              // TODO: Handle this case.
              throw LinearProgressIndicator();
            case ConnectionState.active:
              // TODO: Handle this case.
              throw LinearProgressIndicator();
            case ConnectionState.done:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        }
        
        
        )
      



    );
  }
}
