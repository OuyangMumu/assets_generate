# assets_generate_example

## 资源文件路径生成

## Install

```yaml

dev_dependencies:
  ...
  build_runner: ^1.10.0
  assets_generate:
    git:
      url: https://gitlab.deepexi.top/deepexi/deepexi_devices/flu_packages.git
      ref: dev
      path: assets_generate

```

## DOC

> 设置资源路径

```yaml
flutter:
  assets:
    - assets/
    - assets/svg/
    - assets/images/
```

> 在启动入口添加注解

```dart

@AssetsGenerate()
void main() {
  runApp(MyApp());
}
```

> 执行命令生成类文件

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

执行完命令后会在使用注解类型的目录下生成一个`*.g.dart`文件

可以根据找个目录结构生成如下代码

![](md/2.png)

`文件夹层次用驼峰命名发拼接`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: AssetsAutoBuilder
// **************************************************************************

class Assets {
  Assets._();

  static final String aJpg = 'assets/a.jpg';
  static final String bJpg = 'assets/b.jpg';
}

class AssetsSvg {
  AssetsSvg._();

  static final String a1Svg = 'assets/svg/a1.svg';
  static final String bSvg = 'assets/svg/b.svg';
  static final String cSvg = 'assets/svg/c.svg';
}

class AssetsImages {
  AssetsImages._();

  static final String a1Jpg = 'assets/images/a1.jpg';
  static final String a2Png = 'assets/images/a2.png';
}


```
