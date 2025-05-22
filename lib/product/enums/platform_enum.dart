import 'dart:io';


enum PlatformEnum {
  android,
  ios;

  static String get versionName {
    //Platform sınıfı dart:io kütüphanesinden geliyor
    if(Platform.isIOS) return PlatformEnum.ios.name;
    if(Platform.isAndroid) return PlatformEnum.android.name;

    throw Exception('Platform unused please check');
  }
}


