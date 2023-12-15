import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';
import 'package:wc_dart_framework_generator/extensions/element.dart';

class BlocGenerator extends GeneratorForAnnotation<BlocGen> {
  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final cls = element;
    if (cls is! ClassElement) {
      return null;
    }
    final isHydrateState = annotation.read('hydrateState').boolValue;
    final hydrateStateKeyAnnotation = annotation.read('hydrateStateKey');
    final hydrateStateKey = hydrateStateKeyAnnotation.isString
        ? hydrateStateKeyAnnotation.stringValue
        : null;
    final generateFieldSelectors =
        annotation.read('generateFieldSelectors').boolValue;
    final superTypes = cls.allSupertypes;
    final index = superTypes.indexWhere(
      (final type) => type
          .getDisplayString(
            withNullability: false,
          )
          .startsWith('Cubit<'),
    );
    if (index.isNegative) {
      throw ArgumentError(
        '@BlocGen can only be on classes that are extended from Cubit',
      );
    }
    final clsMetaTags = cls.metadata
        .where((m) => ![
              'BlocGen',
              'BlocHydratedState',
            ].contains(m.element?.displayName))
        .map(
          (final m) => m.toSource(),
        )
        .join('\n');
    final superType = superTypes[index];
    if (superType.typeArguments.isEmpty) {
      return null;
    }
    final clsStateType = superType.typeArguments.first;
    final clsState = clsStateType.element;
    if (clsState is! ClassElement) {
      return null;
    }
    final clsStateName = superType.typeArguments.first.toString();
    final isClsStateNullable = clsStateName.endsWith('?');
    final clsStateNullableEscapeCharacter = isClsStateNullable ? '?' : '';
    final clsStateNameWithoutNullCharacter =
        superType.typeArguments.first.getDisplayString(
      withNullability: false,
    );
    final fields = clsState.fields.where((field) {
      final getter = field.getter;
      if (getter == null) {
        return false;
      }
      if (!getter.isAbstract) {
        return false;
      }
      return true;
    }).toList();
    final sb = StringBuffer();

    // creating bloc-builder ---- start
    sb.writeln('''
$clsMetaTags
class ${cls.displayName}Builder extends StatelessWidget {
  final BlocWidgetBuilder<$clsStateName> builder;

  const ${cls.displayName}Builder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<${cls.displayName}, $clsStateName>(
      builder: builder,
    );
  }
}
      ''');
    // creating bloc-builder ---- end

    // creating bloc-selector ---- start
    sb.writeln('''
$clsMetaTags
class ${cls.displayName}Selector<T> extends StatelessWidget {
  final BlocWidgetSelector<$clsStateName, T> selector;
  final Widget Function(T state) builder;
  final ${cls.displayName}? bloc;

  const ${cls.displayName}Selector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);
      ''');
    if (generateFieldSelectors) {
      for (final field in fields) {
        final getter = field.getter!;
        if (getter.hasAnnotation('BlocGenIgnoreFieldSelector')) {
          continue;
        }
        String returnTypeDisplayNameWithNullability =
            '${getter.returnType}${isClsStateNullable && !getter.isReturnTypeNullable ? '?' : ''}';
        sb.writeln('''
  static ${cls.displayName}Selector<$returnTypeDisplayNameWithNullability> ${field.displayName}({
    final Key? key,
    required Widget Function($returnTypeDisplayNameWithNullability ${field.displayName}) builder,
    final ${cls.displayName}? bloc,
  }) {
    return ${cls.displayName}Selector(
      key: key,
      selector: (state) => state$clsStateNullableEscapeCharacter.${field.displayName},
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }
          ''');
      }
    }

    sb.writeln('''
  @override
  Widget build(final BuildContext context) {
    return BlocSelector<${cls.displayName}, $clsStateName, T>(
      selector: selector,
      builder: (_,value) => builder(value),
      bloc:bloc,
    );
  }
}
      ''');
    // creating bloc-selector ---- end

    // creating bloc-extension ---- start
    sb.writeln('''
mixin _${cls.displayName}Mixin on Cubit<$clsStateName> {
      ''');
    for (final field in fields) {
      final getter = field.getter!;
      if (!getter.hasAnnotation('BlocUpdateField')) {
        continue;
      }
      final returnType = getter.returnType.element;
      bool isReturnTypeNullable = getter.returnType.toString().endsWith('?');
      sb.writeln('''
  @mustCallSuper
  void update${getter.displayName.toPascalCase()}(final ${getter.returnType} ${field.displayName}) {
    if(state$clsStateNullableEscapeCharacter.${field.displayName} == ${field.displayName}){
      return;
    }
        ''');
      if (returnType is ClassElement && returnType.isBuiltValue) {
        sb.writeln('''
    emit(state$clsStateNullableEscapeCharacter.rebuild((final b) {
        ''');
        if (isReturnTypeNullable) {
          sb.writeln('''
      if (${field.displayName} == null)
        b.${field.displayName} = null;
      else
            ''');
        }
        sb.writeln('''
        b.${field.displayName}.replace(${field.displayName});
          ''');
        sb.writeln('''
    }));
        ''');
      } else {
        sb.writeln('''
    emit(state$clsStateNullableEscapeCharacter.rebuild((final b) => b.${field.displayName} = ${field.displayName}));
        ''');
      }
      sb.writeln('''
        \$onUpdate${getter.displayName.toPascalCase()}();
  }   
      @protected
      void \$onUpdate${getter.displayName.toPascalCase()}() {}
      ''');
    }
    sb.writeln('''
}
      ''');
    // creating bloc-extension ---- end

    // creating bloc-hydration ---- start
    final hydratedFields = isHydrateState
        ? <FieldElement>[]
        : fields.where(
            (field) {
              final getter = field.getter!;
              if (!getter.hasAnnotation('BlocHydratedField')) {
                return false;
              }
              return true;
            },
          ).toList();
    if (hydratedFields.isNotEmpty || isHydrateState) {
      if (!isHydrateState && isClsStateNullable) {
        throw ArgumentError(
          'BlocHydratedField is not supported for nullable state',
        );
      }
      sb.writeln('''
mixin _${cls.displayName}HydratedMixin on HydratedMixin<$clsStateName> {
    ''');
      sb.writeln('''
      @override
      Map<String, dynamic>? toJson($clsStateName state) {
          final json = <String, dynamic>{};
        ''');
      String getFullType(DartType type) {
        final typeName = type.element!.displayName;
        String specifiedType;
        if (type.nullabilitySuffix == NullabilitySuffix.question) {
          specifiedType = 'FullType.nullable($typeName,[';
        } else {
          specifiedType = 'FullType($typeName,[';
        }
        if (type is InterfaceType) {
          for (final genericType in type.typeArguments) {
            specifiedType += getFullType(genericType);
          }
        }
        specifiedType += ']),';
        return specifiedType;
      }

      if (isHydrateState) {
        sb.writeln('''
        try {
          json['${hydrateStateKey ?? clsStateNameWithoutNullCharacter}'] = serializers.serialize(state, specifiedType: const ${getFullType(clsStateType)});
        } catch (e) {
          _logger.severe('toJson->${hydrateStateKey ?? clsStateNameWithoutNullCharacter}: \$e');
        }
          ''');
      } else {
        for (final field in hydratedFields) {
          final getter = field.getter!;
          sb.writeln('''
        try {
          json['${field.displayName}'] = serializers.serialize(state.${field.displayName}, specifiedType: const ${getFullType(getter.returnType)});
        }catch (e) {
          _logger.severe('toJson->${field.displayName}: \$e');
        }
          ''');
        }
      }
      sb.writeln('''
        return json;
      }
        ''');
      sb.writeln('''
      @override
      $clsStateNameWithoutNullCharacter? fromJson(Map<String, dynamic> json) {
        ''');
      if (isHydrateState) {
        sb.writeln('''
        try {
          return serializers.deserialize(json['${hydrateStateKey ?? clsStateNameWithoutNullCharacter}'], specifiedType: const ${getFullType(clsStateType)}) as $clsStateName;
        } catch (e) {
          _logger.severe('fromJson->${hydrateStateKey ?? clsStateNameWithoutNullCharacter}: \$e');
          return null;
        }
            ''');
      } else {
        sb.writeln('''
          final b = state.toBuilder();
            ''');
        for (final field in hydratedFields) {
          final getter = field.getter!;
          final returnTypeElement = getter.returnType.element;
          sb.writeln('''
        if (json.containsKey('${field.name}')) {
          try {
          ''');
          final deserializedCode = '''
              serializers.deserialize(json['${field.displayName}'], specifiedType: const ${getFullType(getter.returnType)}) as ${getter.returnType.getDisplayString(
            withNullability: false,
          )}''';
          sb.writeln('''
            if (json['${field.displayName}'] == null) {
              b.${field.displayName} = null;
            } else {
          ''');
          if (returnTypeElement is ClassElement &&
              returnTypeElement.isBuiltValue) {
            sb.writeln('''
              b.${field.displayName}.replace($deserializedCode);
              ''');
          } else {
            sb.writeln('''
              b.${field.displayName} = $deserializedCode;
          ''');
          }
          sb.writeln('''
            }
          } catch (e) {
            _logger.severe('fromJson->${field.displayName}: \$e');
          }
        }
          ''');
        }
        sb.writeln('''
          return b.build();
        ''');
      }
      sb.writeln('''
      }
        ''');
      sb.writeln('''
}
    ''');
    }
    // creating bloc-hydration ---- end

    return sb.toString();
  }
}
