import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

void main() async {
  var file = File("pubspec.yaml");
  var str = file.readAsStringSync();
  var doc = loadYaml(str);
  print(jsonEncode(doc));
  var flutterData = doc['flutter'];
  if (flutterData != null) {
    var assetsData = flutterData["assets"];
    if (assetsData != null) {
      print(assetsData.runtimeType);
    }
  }
}
