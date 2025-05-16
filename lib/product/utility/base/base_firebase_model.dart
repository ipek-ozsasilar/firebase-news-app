import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';

//Firestore'dan veri çekerken her model için tekrar tekrar aynı kodları yazmak yerine,ortak bir temel yapı oluşturduk
//Her modelin bir id'si olmalı (çünkü Firestore'da her dökümanın bir ID'si var).
//Her modelin JSON'dan nesneye (fromJson) ve Firestore dökümanından nesneye (fromFirebase) dönüşümünü kolaylaştırmak için


//Tüm modellerin (örneğin News) bir id alanı olmasını zorunlu kıldık
//Yani, bu soyut sınıfı extend eden her modelde id olacak.
abstract class IdModel{
  String? get id;
}

//Farklı modellerle (örneğin News, User, vs.) kullanılabilsin diye generic (T) olarak tanımlanmış.
abstract class BaseFirebaseModel <T extends IdModel> {
   T fromJson(Map<String, dynamic> json);

   //Firestore’dan gelen dökümanı alır, önce veriyi çeker, sonra Firestore’daki döküman ID’sini de ekler, 
   //en son fromJson ile model nesnesi oluşturur.
   T? fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final value=snapshot.data();
    if (value==null) {
      return null;
    }
    //fixme: idyi key olarak çıkarıcağız
    value.addEntries([MapEntry("id", snapshot.id)]);
    return fromJson(value);
  }
   
}