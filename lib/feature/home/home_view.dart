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

    return FutureBuilder(
      //get diyerek read işlemi yapacağız. Ama snapshot.data.Data() diyerek datayı alıp map e atmak sağlıklı değil
      //Her zaman önce internetten çekilecek datanın bir modelini oluşturarak onu kullanmak daha sağlıklı ve güvenlidir
      future: response,
    
      // AsyncSnapshot, future/stream'den gelen datanın durumunu ve verisini tutan bir sınıftır
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<News?>> snapshot,
      ) {
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
