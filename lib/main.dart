import 'package:dwflutter/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dw flutter',
      debugShowCheckedModeBanner: false,
     // debugShowMaterialGrid: true,
     
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0XFF3FC1C9),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0XFF364F6B),
          brightness: Brightness.dark, 
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark, 
      home: const Home(),
    );
  }
}
