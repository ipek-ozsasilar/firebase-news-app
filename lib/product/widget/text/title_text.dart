import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class TitleText extends StatelessWidget {
   TitleText({super.key, required this.value});
  final String value;
  @override
  Widget build(BuildContext context) {
    return Text(value, style:context.general.appTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),);
  }
}

//Atomik Component = UI'yi en küçük, yeniden kullanılabilir parçalara bölerek organize etme metodudur. 
//Bu yaklaşım, daha temiz, sürdürülebilir ve tutarlı kod yazmanı sağlar.