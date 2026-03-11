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
    final isPureEnum = element is EnumElement;
    if (isPureEnum) {
      for (final field in element.fields) {
        if (field.isEnumConstant) {
          fieldNames.add(field.displayName);
        }
      }
    } else if (element is ClassElement &&
        element.supertype?.getDisplayString() == 'EnumClass') {
      final className = element.name;
      for (final field in element.fields) {
        final fieldReturnTypeName = field.getter?.returnType.getDisplayString();
        if (field.isStatic &&
            field.isConst &&
            fieldReturnTypeName == className) {
          fieldNames.add(field.displayName);
        }
      }
    } else {
      return null;
    }
    final code =
        '''
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
      ${isPureEnum ? '' : 'default: throw Error();'} 
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

      ${isPureEnum ? '' : 'default: return null;'}
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
