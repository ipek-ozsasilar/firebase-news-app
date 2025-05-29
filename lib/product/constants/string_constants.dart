import 'package:flutter/material.dart';

//Bu kural sınıfın kendisini değil, sınıftan oluşturulan nesnelerin içindeki değişkenlerin değiştirilmemesini şart koşar
//Eğer @immutable yazarsan, sınıfın içindeki değişkenlerin tümü final olmak zorundadır.
//Static alanlar için Dart linter bu kurala karışmaz. Sadece bu sınıfın nesnesinin değişkenleri içindir.
@immutable
class StringConstants {
  const StringConstants._();
  static const appName = "Nuntium";

  //Login
  static const loginWelcomeBack = "Welcome Back 👋";
  static const loginWelcomeDetail ="I am happy to see you again. You can continue where you left off by logging in";
  static const loginContinueToApp = "Continue to app";
  
  //HomeCreate
  static const addItemTitle=  "add new item";
  
  //Home
  static const homeBrowse=  "Browse";
  static const homeDiscoverWorld = "Discover things of this world";
  static const homeRecommendTitle = "Recommend for you";
  static const homeSeeAll = "See all";
  static const homeSearchHint = "Search";

  //Components
  static const dropdownHint = "Select Items";
  static const dropdownTitle = "Title";
  static const buttonSave = "Save";

}
