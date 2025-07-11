import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_news_app/product/enums/platform_enum.dart';
import 'package:flutter_firebase_news_app/product/models/version_model.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:flutter_firebase_news_app/product/utility/version_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Splash provider sınıfı uygulamanın splash ekranı gibi başlangıç durumlarını kontrol eden bir state provider
//SplashState: Bu provider’ın tuttuğu veri modelidir (durumun kendisi).
//Bu yapıyla uygulamanın splash ekranında örneğin "güncelleme gerekiyor mu?" gibi bir bilgi yönetilir.
//Biz şimdi device sürümü ile databasede yazan sürümü karşılaştırıp güncelleme gerekiyorsa dialog göstericez

//yarın şu bilgiler de gerekebilir:
//- Kullanıcı giriş yaptı mı?
//- Splash ekranı gösterildi mi?
//- Güncelleme zorunlu mu?
//- Kullanıcıya tanıtım videosu gösterildi mi?


//SplashProvider sınıfı StateNotifier<SplashState> türünden türetilmiş.
//Yani bu sınıf içinde state kelimesi, SplashState türünde bir değişkeni temsil eder.
class SplashProvider extends StateNotifier<SplashState>{
  SplashProvider() : super(SplashState(false, false));

  Future<void> checkApplicationVersion(String clientVersion) async {
    final databaseValue= await getVersionNumberFromDatabase();
    if(databaseValue==null || databaseValue.isEmpty){
      //state kelimesi genelde uygulamanın bir ekranındaki veya bileşenindeki veri durumunu (UI state) temsil eder. 
      //copyWith metodu, var olan state nesnesinin kopyasını oluşturur ama bazı alanlarını değiştirmeni sağlar.
      //Riverpod vey state yönetim kütüphanelerinde state = ... yapınca ilgili widget'lar yeniden build edilir.
      //state, o anki veri durumudur.
      state= state.copyWith(isRequiredForceUpdate: true);
      return;
    }
    final checkIsNeedForceUpdate=VersionManager(deviceValue: clientVersion, databaseValue: databaseValue);
    
    //eger guncelleme ıhtıyacı true donmusse isRequiredForceUpdate: true yapılır
    if(checkIsNeedForceUpdate.isNeedUpdate()){
      state= state.copyWith(isRequiredForceUpdate: true);
      return;
    }

    //eger guncelleme ıhtıyacı yoksa inRedirectHome: true yapılır
    state=state.copyWith(inRedirectHome: true);
  }

  //burada tek belge cekılecegı yanı tek bır sey number cektıgımız ıcın fetchlıst generıc fırebase verı
  //cekme yapısını kullanmadık
  Future<String?> getVersionNumberFromDatabase() async {
    //cunku eger proje web ise direkt siteyi güncelleyip atabiliriz force update yapmaya gerek yok
    if(kIsWeb) return null;
    //withConverter, Firestore'dan okunan Map<String, dynamic> verisini doğrudan Dart modeline çevirmeni,
    //ve tam tersi şekilde modeli Firestore’a yazarken Map’e dönüştürmeni sağlar.
    final response=await FirebaseCollections.version.reference.withConverter(
      //Firestore'dan bir belge (DocumentSnapshot) geldiğinde, bu belgeyi Version sınıfına nasıl çevireceğimi burada tanımlıyorum.
      fromFirestore: (snapshot, options) => Version().fromFirebase(snapshot),
      toFirestore: (value, options) {
        return value.toJson();
      },
    ).doc(PlatformEnum.versionName).get();
    
    return response.data()?.number;

    }
  
}

//Equatable olmadan:
//state1 == state2 // false döner çünkü farklı referanslar
//Equatable ile:
//state1 == state2 // true döner çünkü içerikleri aynı
//Dart varsayılan olarak referansa baktığı için, aynı içeriğe sahip yeni bir nesne bile olsa rebuild olabilir.
//Gereksiz rebuildleri önlemek adına equatable kullanıyoruz
//equatable içerikleri aynı ise referansları karşılaştırmak yerine içeriklerini karşılaştırır.
//Riverpod'da mantık ve veri (state) ayrı tanımlanır. SplashState veri(state) sınıfı,
// SplashProvider ise bu veriyi yöneten mantık sınıfıdır.
class SplashState extends Equatable {
  final bool? isRequiredForceUpdate;
  final bool? inRedirectHome;

  SplashState(this.inRedirectHome, this.isRequiredForceUpdate);
  
  @override
  // TODO: implement props
  List<Object?> get props => [isRequiredForceUpdate, inRedirectHome];



  SplashState copyWith({
    bool? isRequiredForceUpdate,
    bool? inRedirectHome,
  }) {
    return SplashState(
      isRequiredForceUpdate ?? this.isRequiredForceUpdate,
      inRedirectHome ?? this.inRedirectHome,
    );
  }
}
