import 'package:flutter/material.dart';
import 'Controller/Widget/responsividade.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Você pode adicionar configurações gerais aqui
      home: ResponsividadeApp(), // Use o widget de responsividade como tela inicial
      debugShowCheckedModeBanner: false,
    );
  }
}
