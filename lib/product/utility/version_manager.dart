import 'package:flutter_firebase_news_app/product/utility/exception/custom_exception.dart';

class VersionManager {
  final String deviceValue;
 final String databaseValue;

  VersionManager({required this.deviceValue, required this.databaseValue});
 
  //Version numarası . içerdıgı ıcın karsılastırma yapabılmek ıcın splıtledık.
  bool isNeedUpdate() {
    //Bu, bir String'i . karakterine göre parçalar ve bir liste (List<String>) döndürür.
    //split işlemi yapınca ve ardından joinleyınce string doner ardından bunu int e parse ettık
    final deviceNumberSplited= deviceValue.split('.').join(''); 
    final databaseNumberSplited= databaseValue.split('.').join(''); 

    final deviceNumber= int.tryParse(deviceNumberSplited);
    final databaseNumber= int.tryParse(databaseNumberSplited);

    if (deviceNumber == null || databaseNumber == null) {
     throw VersionCustomException(description: '$deviceNumber or $databaseNumber is not valid for parse');
      
    }
    //deviceNumber < databaseNumber update e ıhtıyacın var true donmelı isNeedUpdate fonksiyonun
    return deviceNumber < databaseNumber ;
    }
}