import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

class EnumGenerator extends GeneratorForAnnotation<EnumGen> {
  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final sb = StringBuffer();

    final fieldNames = <String>[];
    if (element is EnumElement) {
      for (final field in element.fields) {
        if (field.isEnumConstant) {
          fieldNames.add(field.displayName);
        }
      }
    } else if (element is ClassElement &&
        element.supertype?.getDisplayString(withNullability: false) ==
            'EnumClass') {
      for (final field in element.fields) {
        if (field.isStatic && field.isConst) {
          fieldNames.add(field.displayName);
        }
      }
    } else {
      return null;
    }
    final code = '''
extension X${element.displayName} on ${element.displayName} {
  R when<R>({
    ${fieldNames.map((final fn) => 'required R Function() $fn').join(',\n')},
  }) {
    switch (this) {
    ${fieldNames.map(
              (final fn) => '''
      case ${element.displayName}.$fn:
        return $fn();
    ''',
            ).join()}
      default:
        throw Error();
    }
  }
  
  R? whenOrNull<R>({
    ${fieldNames.map((final fn) => 'R? Function()? $fn').join(',\n')},
  }) {
    switch (this) {
    ${fieldNames.map(
              (final fn) => '''
      case ${element.displayName}.$fn:
        return $fn?.call();
    ''',
            ).join()}
      default:
        return null;
    }
  }
  
  R maybeWhen<R>({
    ${fieldNames.map((final fn) => 'R Function()? $fn').join(',\n')},
    required R orElse(),
  }) {
    ${fieldNames.map(
              (final fn) => '''
    if (this == ${element.displayName}.$fn && $fn != null) {
      return $fn();
    }
        ''',
            ).join()}
    return orElse();
  }
}
      ''';
    sb.writeln(code);
    return sb.toString();
  }
}

class EnumGeneratorr extends Generator {
  @override
  FutureOr<String?> generate(
    final LibraryReader library,
    final BuildStep buildStep,
  ) {
    final sb = StringBuffer();
    for (final cls in library.classes) {
      final superClass =
          cls.supertype?.getDisplayString(withNullability: false);
      if (superClass != 'EnumClass') {
        continue;
      }
      final fieldNames = <String>[];
      for (final field in cls.fields) {
        if (field.isStatic && field.isConst) {
          fieldNames.add(field.displayName);
        }
      }
      final code = '''
extension X${cls.displayName} on ${cls.displayName} {
  R when<R>({
    ${fieldNames.map((final fn) => 'required R Function() $fn').join(',\n')},
  }) {
    switch (this) {
    ${fieldNames.map(
                (final fn) => '''
      case ${cls.displayName}.$fn:
        return $fn();
    ''',
              ).join()}
      default:
        throw Error();
    }
  }
  
  R? whenOrNull<R>({
    ${fieldNames.map((final fn) => 'R? Function()? $fn').join(',\n')},
  }) {
    switch (this) {
    ${fieldNames.map(
                (final fn) => '''
      case ${cls.displayName}.$fn:
        return $fn?.call();
    ''',
              ).join()}
      default:
        return null;
    }
  }
  
  R maybeWhen<R>({
    ${fieldNames.map((final fn) => 'R Function()? $fn').join(',\n')},
    required R orElse(),
  }) {
    ${fieldNames.map(
                (final fn) => '''
    if (this == ${cls.displayName}.$fn && $fn != null) {
      return $fn();
    }
        ''',
              ).join()}
    return orElse();
  }
}
      ''';
      sb.writeln(code);
    }
    return sb.toString();
  }
}
