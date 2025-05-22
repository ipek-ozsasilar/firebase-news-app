//dummy
//neden ref e erısebıldı splashprovıdera erısemedı
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/home/home_view.dart';
import 'package:flutter_firebase_news_app/feature/splash/splash_provider.dart';
import 'package:flutter_firebase_news_app/feature/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

mixin SplashViewListenMixin on ConsumerState<SplashView>{
   void listenAndNavigate(StateNotifierProvider<SplashProvider, SplashState> provider) {
     ref.listen(provider, (previous,next){
      if (next.isRequiredForceUpdate ?? false) {
        return showAboutDialog(context: context);
      }
      if (next.inRedirectHome != null) {
        if (next.inRedirectHome!) {
            context.route.navigateToPage(HomeView());
      }
      else{
            //false

      }
    }});
   }
}