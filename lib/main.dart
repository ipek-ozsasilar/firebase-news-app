import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/home/home_view.dart';
import 'package:flutter_firebase_news_app/feature/splash/splash_view.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/initialize/application_start.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bazı kodlar runapp cagrılmadan once cagrılmalı uygulama baslamadan ınıtılazer olması ıcın firebase bunlardan bırı
// Kullanıcı arka planda giriş ekranını aça anımasyonu ızlerken bizde logiclerimizi yaparız
Future<void> main() async {
  await ApplicationStart.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashView(),
    );
  }
}

