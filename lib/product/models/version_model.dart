import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';
//map<string,dynamic> veri turunu fırebaseden gelen 2–3 model için 3 ek paket yüklemek bazen gereksiz gelir.
//Başlangıç süresi uzar	flutter pub run build_runner build ile uğraşmak zaman alabilir.
//Değişiklik sonrası build şart	Model değişirse tekrar build alman gerekir.
//O nedenle json seriazible kullanmak küçük projelerde pek mantıklı değildir daha çok manuel
//olarak elle yazmak veya dartj vs kullanmak daha mantıklıdır.
class Version extends BaseFirebaseModel<Version> with EquatableMixin implements IdModel {
  

  final String? number;
  //Kullanmayacağımız için boş string döndürdük
  //Normalde hangı doc'u cekecegımızı belırtmek ıcın id yi kullanırız ama burada gerek duymadık cunku zaten
  //docs ısımlerını androıd ve ios yaptık bu yuzden id cekmemeıze ıhtıyac yok suan tojsona da ıhtıyac yok olmasa da olur
  @override
  final String? id = ''; 

  Version({
    this.number,
  });

  @override
  List<Object?> get props => [number];

  Version copyWith({
    String? number,
  }) {
    return Version(
      number: number ?? this.number,
    );
  }


  //factory methodu bir constructor gibi çalışır: Version.fromJson(json)
  //Version sınıfından yeni bir nesne üretmek için doğru ve doğal yöntemdir.
  //Factory sayesinde daha sonra ister: cache kullanabilirsin,farklı sınıf döndürebilirsin,
  //hiç döndürmeyebilirsin (return null; bile olabilir).
  @override
  Version fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return Version(
      number: json['number'] as String?,
      
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
    };
  }
  


  
}
