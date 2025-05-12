import 'package:flutter/material.dart';


/*  @immutable
class ImageConstants{
 const ImageConstants._();
 static final microphone='inside_microphone'.iconToPng ;

}


extension _StringPath on String{
  String get iconToPng => 'assets/icon/$this.png';

}*/


//enhanced enums (gelişmiş enum) yapısı
//extension yazmaya gerek kalmadı bir daha
enum IconConstants {
  microphone('inside_microphone');

  final String value;
  const IconConstants(this.value);

  String get toPng => 'assets/icon/$value.png';
}



class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(IconConstants.microphone.toPng);
  }
}
