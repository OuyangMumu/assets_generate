// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:io';

var _nodeReg = RegExp("\s*[a-zA-Z0-9]+:.*");
void main() async {
  await _parseYamlAssetsNode();
}

Future<List<String>> _parseYamlAssetsNode() async {
  var file = File("pubspec.yaml");
  if (!file.existsSync()) {
    throw "pubspec.yaml not find";
  }
  var str = await file.readAsString();
  var assetsIndex = str.trim().indexOf("assets:");
  if (assetsIndex == -1) {
    return [];
  }
  str = str.substring(assetsIndex, str.length);
  var arr = str.split("\n");

  var paths = <String>[];
  for (int i = 0; i < arr.length; i++) {
    var element = arr[i].trim();
    if (element.trim().startsWith("#")) {
      continue;
    }
    if (_nodeReg.firstMatch(element) != null &&
        !element.startsWith("assets:")) {
      break;
    }
    if (element.startsWith("-")) {
      paths.add(element);
    }
  }
  for (int i = 0; i < paths.length; i++) {
    var path = paths[i];
    path = path.replaceAll("-", "");
    path = path.trim().replaceAll("\\", "/");
    if (path.endsWith("/")) {
      path = path.substring(0, path.length - 1);
    }

    paths[i] = path;
  }
  List<String> dirArr = [];

  for (String element in paths) {
    var isFile = await FileSystemEntity.isFile(element);
    if (!isFile) {
      dirArr.add(element);
    }
  }

  print(dirArr);
  return dirArr;
}
