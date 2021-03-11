import 'package:flutter/material.dart';
import 'package:humangen/splashscreen.dart';

//import '../flutter/packages/flutter/lib/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Human Generator',
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}