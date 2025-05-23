import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

//Eğer tüm auth butonların rengi aynı vs olacak olsaydı bu themeayı mainde tanımlardık
class AppTheme extends Theme {
  AppTheme({required super.data, required super.child});

  static ThemeData authButtonTheme(BuildContext context) {
    return ThemeData(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
           EdgeInsets.all(12),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          textStyle: MaterialStateProperty.all<TextStyle?>(
            //logın sign in buton textinin heightının 24 oldugunu gorunce texthemedan
            //24 heightlı textın adını aldık ve temadan okuruz
            context.general.appTheme.textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
