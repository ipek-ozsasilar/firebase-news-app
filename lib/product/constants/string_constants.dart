import 'package:flutter/material.dart';

//Bu kural sınıfın kendisini değil, sınıftan oluşturulan nesnelerin içindeki değişkenlerin değiştirilmemesini şart koşar
//Eğer @immutable yazarsan, sınıfın içindeki değişkenlerin tümü final olmak zorundadır.
//Static alanlar için Dart linter bu kurala karışmaz. Sadece bu sınıfın nesnesinin değişkenleri içindir.
@immutable
class StringConstants{
 const StringConstants._();
 static const appName="Nuntium";

}

