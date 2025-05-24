import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/initialize/app_cache.dart';

enum CacheItems {
  //kaydedeceğimiz tokenı token dşye bir keye kaydedecegız
  token;
  
  String? get read => AppCache.instance.prefs.getString(name) ?? '';

  Future<bool>  write(String value) {
    return AppCache.instance.prefs.setString(name, value);
  }
}
