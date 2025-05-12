import 'package:flutter_riverpod/flutter_riverpod.dart';

//login view model ıslemlerını burada yapacagız
class LoginProvider extends StateNotifier<int> {
  LoginProvider() : super(0);

  void increment() {
    state = state + 1;
  }
  
  void decrement() {
    state = state - 1;
  }
}