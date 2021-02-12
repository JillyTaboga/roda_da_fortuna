import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roda_da_fortuna/gui/screens/config_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Roda da Fortuna',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.blue.shade900,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              minimumSize: Size(100, 45),
            ),
          ),
          toggleButtonsTheme: ToggleButtonsThemeData(
            fillColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            focusColor: Colors.yellowAccent,
            borderColor: Colors.orange,
            borderWidth: 2,
            selectedBorderColor: Colors.orange,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            constraints: BoxConstraints(
              minWidth: 100,
              minHeight: 45,
            ),
          ),
        ),
        home: ConfigScreen(),
      ),
    );
  }
}
