import 'package:assets_generate/assets_annotation.dart';
import 'package:assets_generate_example/main.assets.g.dart';
import 'package:flutter/material.dart';

@AssetsGenerate()
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset(AssetsImages.aJpg),
      ),
    );
  }
}
