import 'package:flutter/material.dart';

//Bu kural sınıfın kendisini değil, sınıftan oluşturulan nesnelerin içindeki değişkenlerin değiştirilmemesini şart koşar
//Eğer @immutable yazarsan, sınıfın içindeki değişkenlerin tümü final olmak zorundadır.
//Static alanlar için Dart linter bu kurala karışmaz. Sadece bu sınıfın nesnesinin değişkenleri içindir.
@immutable
class StringConstants {
  const StringConstants._();
  static const appName = "Nuntium";

  //login
  static const loginWelcomeBack = "Welcome Back 👋";
  static const loginWelcomeDetail =
      "I am happy to see you again. You can continue where you left off by logging in";
}
