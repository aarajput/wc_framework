import 'dart:io';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

class AssetGenerator extends GeneratorForAnnotation<AssetGen> {
  @override
  String? generateForAnnotatedElement(
    final Element2 element,
    final ConstantReader annotation,
    final BuildStep buildStep,
  ) {
    final path = annotation.read('path').stringValue;
    final createStaticInstances =
        annotation.read('createStaticInstances').boolValue;
    final showExtension = annotation.read('showExtension').boolValue;
    List<Glob>? getGlobs(final String key) {
      if (annotation.read(key).isNull) {
        return null;
      }
      return annotation
          .read(key)
          .listValue
          .map((final obj) => Glob(obj.toStringValue() ?? ''))
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
      if (createStaticInstances) {
        sb.writeln(
          "static const ${baseName.toConstantCase()}='${file.path}';",
        );
      } else {
        sb.writeln(
          "final ${baseName.toCamelCase()}='${file.path}';",
        );
      }
    }
    sb.writeln('}');
    return sb.toString();
  }

  bool isFileIgnored({
    required final File file,
    required final List<Glob>? includeFileNames,
    required final List<Glob>? excludeFileNames,
  }) {
    final fileName = basename(file.path);
    if (includeFileNames != null) {
      if (includeFileNames.any((final glob) => glob.matches(fileName))) {
        return false;
      } else {
        return true;
      }
    }
    if (excludeFileNames != null) {
      if (excludeFileNames.any((final glob) => glob.matches(fileName))) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
