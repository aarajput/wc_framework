import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class BuiltEnumGenerator extends Generator {
  @override
  FutureOr<String?> generate(
    final LibraryReader library,
    final BuildStep buildStep,
  ) async {
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
