import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:assets_generate/assets_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder build(BuilderOptions options) {
  return LibraryBuilder(AssetsAutoBuilder(),
      generatedExtension: ".assets.g.dart");
}

class AssetsAutoBuilder extends GeneratorForAnnotation<AssetsGenerate> {
  final _nameReg = RegExp("^[0-9]+");

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    var list = await this._parseYamlAssetsNode();

    StringBuffer sb = StringBuffer();
    for (var element in list) {
      var str = await this._handleElement(element);
      sb.write(str);
    }
    return sb.toString();
  }

  Future<String> _handleElement(String dirPath) async {
    var dir = Directory(dirPath);
    var dirExists = await dir.exists();
    if (!dirExists) {
      throw "'$dirPath' Folder does not exist";
    }
    return _handleDir(dir);
  }

  /// 根据文件夹生成相应的类文件
  Future<String> _handleDir(Directory dir) async {
    String dirPath = dir.path;
    var className = _getDirClassName(dirPath);

    var classSB = StringBuffer("""
      class $className{
        $className._();
        [-field-]
      }
      """);

    var fieldSB = StringBuffer();

    var childList = dir.listSync();

    print(childList);
    for (var child in childList) {
      var childPath = child.path;
      var isFile = await FileSystemEntity.isFile(childPath);
      if (isFile) {
        var fieldName = this._getFileFieldName(childPath);
        childPath = childPath.replaceAll("\\", "/");
        fieldSB.write("\nstatic final String $fieldName='$childPath';");
      }
      //  else {
      // var childClassSB = await _handleDir(Directory(childPath));
      // classSB.write(childClassSB);
      // }
    }

    var classStr = classSB.toString();
    classStr = classStr.replaceAll("[-field-]", fieldSB.toString());
    return classStr;
  }

  /// 判断文件名字是否合法
  void _judgeNameLegal(String name) {
    if (_nameReg.firstMatch(name) != null) {
      throw "Filename or folder name cannot begin with a number:$name";
    }
  }

  /// 获取文件生成的属性名称
  String _getFileFieldName(String path) {
    String absPath = "$path";
    absPath = absPath.replaceAll("\\", "/");
    var arr = absPath.split("/");
    var fileName = arr[arr.length - 1];

    var filenameArr = fileName.split(".");
    if (filenameArr.length > 1) {
      for (var i = 1; i < filenameArr.length; i++) {
        if (filenameArr[i].length > 1) {
          filenameArr[i] =
              "${filenameArr[i][0].toUpperCase()}${filenameArr[i].substring(1, filenameArr[i].length)}";
        } else {
          filenameArr[i] = "${filenameArr[i][0].toUpperCase()}";
        }
      }
      var filenameSB = StringBuffer();
      for (var item in filenameArr) {
        filenameSB.write(item);
      }
      fileName = filenameSB.toString();
    }

    this._judgeNameLegal(fileName);
    return fileName;
  }

  /// 获取根据文件夹生成的类名
  _getDirClassName(String path) {
    String absPath = "$path";
    absPath = absPath.replaceAll('\\', "/");
    var arr = absPath.split("/");
    var classNameSB = StringBuffer("");
    for (var element in arr) {
      if (element.isNotEmpty) {
        var newName = "";
        if (element.length == 1) {
          newName = element.toUpperCase();
        } else {
          newName =
              "${element[0].toUpperCase()}${element.substring(1, element.length)}";
        }

        classNameSB.write(newName);
      }
    }
    String name = classNameSB.toString();
    this._judgeNameLegal(name);
    return name;
  }

  Future<List<String>> _parseYamlAssetsNode() async {
    var paths = <String>[];

    var file = File("pubspec.yaml");
    var str = file.readAsStringSync();
    var doc = loadYaml(str);
    print(jsonEncode(doc));
    var flutterData = doc['flutter'];
    if (flutterData != null) {
      var assetsData = flutterData["assets"];
      if (assetsData != null) {
        for (var item in assetsData) {
          paths.add(item);
        }
      }
    }
    for (int i = 0; i < paths.length; i++) {
      var path = paths[i];
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
}
