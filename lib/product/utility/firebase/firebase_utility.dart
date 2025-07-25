import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';
import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';

mixin FirebaseUtility{

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
  Future<List<T>?> fetchList<T extends IdModel, R extends BaseFirebaseModel<T>>(R data,FirebaseCollections collection) async {
      // FirebaseFirestore.instance ile Firestore servisine bağlanılır
      CollectionReference tagCollectionsReference = collection.reference;
     final response =await  tagCollectionsReference
        //Tip vermemiz daha korumalı bir alan sunacaktır
        .withConverter<T>(
          fromFirestore: (snapshot, options) {
            return data.fromFirebase(snapshot);
          },
          toFirestore: (value, options) {
            //suan kullanmaycagımız ıcın boyle yaoptık
            return {};
            /*if (value == null)
              throw FirebaseCustomException(description: "$value not null");
            return value is T
                ? value.toJson()
                : throw FirebaseCustomException(
                    description: "$value is not Tag",
                  );*/
          },
        )
        //Kodda kullanılan get() fonksiyonu, Firestore'dan bir koleksiyondaki tüm belgeleri çeker.
        .get();

        if (response.docs.isNotEmpty) {
          final values=response.docs.map((e) => e.data()).toList();
          //Eski state'in bir kopyasını alıyor,sadece tagList kısmını yeni values ile değiştiriyor,
          //Sonra o yeni kopyayı tekrar state değişkenine atıyor. Diğer alanları (örneğin isLoading) değiştirmez, olduğu gibi alır
          return values;
        }
        return null;
    
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