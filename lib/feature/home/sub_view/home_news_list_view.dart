/*part of '../home_view.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance ile Firestore servisine bağlanılır
    CollectionReference news = FirebaseFirestore.instance.collection('news');

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
                shrinkWrap: true,
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
}*/