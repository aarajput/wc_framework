import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

class AssetGenerator extends GeneratorForAnnotation<AssetGen> {
  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final path = annotation.read('path').stringValue;
    final createStaticInstances = annotation
        .read('createStaticInstances')
        .boolValue;
    final showExtension = annotation.read('showExtension').boolValue;
    List<Glob>? getGlobs(String key) {
      if (annotation.read(key).isNull) {
        return null;
      }
      return annotation
          .read(key)
          .listValue
          .map((obj) => Glob(obj.toStringValue() ?? ''))
          .toList();
    }

    final includeFileNames = getGlobs('includeFileNames');
    final excludeFileNames = getGlobs('excludeFileNames');
    var generatedClassName =
        annotation.read('generatedClassName').literalValue as String?;
    if (generatedClassName == null) {
      if (element.displayName.startsWith('_\$')) {
        generatedClassName = element.displayName.substring(2);
      } else {
        generatedClassName = element.displayName;
      }
    }
    final dir = Directory(path);
    if (!dir.existsSync()) {
      throw ArgumentError('Directory ${dir.absolute.path} does not exists');
    }
    final sb = StringBuffer();
    sb.writeln('class $generatedClassName {');
    if (createStaticInstances) {
      sb.writeln('const $generatedClassName._();');
    } else {
      sb.writeln('const $generatedClassName();');
    }
    for (final file in dir.listSync().whereType<File>()) {
      if (isFileIgnored(
        file: file,
        includeFileNames: includeFileNames,
        excludeFileNames: excludeFileNames,
      )) {
        continue;
      }
      final baseName = showExtension
          ? basename(file.path)
          : basenameWithoutExtension(file.path);
      final filePath = file.path.replaceAll(
        p.windows.separator,
        p.posix.separator,
      );
      if (createStaticInstances) {
        sb.writeln(
          "static const ${baseName.toConstantCase()}='$filePath';",
        );
      } else {
        sb.writeln(
          "final ${baseName.toCamelCase()}='$filePath';",
        );
      }
    }
    sb.writeln('}');
    return sb.toString();
  }

  bool isFileIgnored({
    required File file,
    required List<Glob>? includeFileNames,
    required List<Glob>? excludeFileNames,
  }) {
    final fileName = basename(file.path);

    // Exclude common system files
    if (_isSystemFile(fileName)) {
      return true;
    }

    if (includeFileNames != null) {
      if (includeFileNames.any((glob) => glob.matches(fileName))) {
        return false;
      } else {
        return true;
      }
    }
    if (excludeFileNames != null) {
      if (excludeFileNames.any((glob) => glob.matches(fileName))) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  bool _isSystemFile(String fileName) {
    // Exclude macOS system files
    if (fileName == '.DS_Store' || fileName.startsWith('._')) {
      return true;
    }
    // Exclude Windows system files
    if (fileName == 'Thumbs.db' || fileName == 'desktop.ini') {
      return true;
    }
    return false;
  }
}
