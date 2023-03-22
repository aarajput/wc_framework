import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:source_gen/source_gen.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

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
        .where((m) => m.element?.displayName != 'BlocGen')
        .map(
          (final m) => m.toSource(),
        )
        .join('\n');
    final superType = superTypes[index];
    if (superType.typeArguments.isEmpty) {
      return null;
    }
    final clsState = superType.typeArguments.first.element;
    if (clsState is! ClassElement) {
      return null;
    }
    final clsStateName = superType.typeArguments.first.toString();
    final isClsStateNullable = clsStateName.endsWith('?');

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

  const ${cls.displayName}Selector({
    final Key? key,
    required this.selector,
    required this.builder,
  }) : super(key: key);
      ''');

    for (final field in clsState.fields) {
      final getter = field.getter;
      if (getter == null) {
        continue;
      }
      if (!getter.isAbstract) {
        continue;
      }
      bool isReturnTypeNullable = getter.returnType.toString().endsWith('?');
      String returnTypeDisplayNameWithNullability =
          '${getter.returnType}${isClsStateNullable && !isReturnTypeNullable ? '?' : ''}';
      sb.writeln('''
  static ${cls.displayName}Selector<$returnTypeDisplayNameWithNullability> ${field.displayName}({
    final Key? key,
    required Widget Function($returnTypeDisplayNameWithNullability ${field.displayName}) builder,
  }) {
    return ${cls.displayName}Selector(
      key: key,
      selector: (state) => state${isClsStateNullable ? '?' : ''}.${field.displayName},
      builder: (value) => builder(value),
    );
  }
          ''');
    }

    sb.writeln('''
  @override
  Widget build(final BuildContext context) {
    return BlocSelector<${cls.displayName}, $clsStateName, T>(
      selector: selector,
      builder: (_,value) => builder(value),
    );
  }
}
      ''');
    // creating bloc-selector ---- end

    // creating bloc-extension ---- start
    sb.writeln('''
mixin _${cls.displayName}Mixin on Cubit<$clsStateName> {
      ''');
    for (final field in clsState.fields) {
      final getter = field.getter;
      if (getter == null) {
        continue;
      }
      if (!getter.isAbstract) {
        continue;
      }
      final isBlocUpdateField = getter.metadata.indexWhere(
            (final md) => md.element?.displayName == 'BlocUpdateField',
          ) >=
          0;
      if (!isBlocUpdateField) {
        continue;
      }
      final returnType = getter.returnType.element;
      bool isReturnTypeNullable = getter.returnType.toString().endsWith('?');
      sb.writeln('''
  @mustCallSuper
  void update${getter.displayName.toPascalCase()}(final ${getter.returnType} ${field.displayName}) {
    if(state.${field.displayName} == ${field.displayName}){
      return;
    }
        ''');
      if (returnType is ClassElement &&
          (returnType.allSupertypes.indexWhere((final st) {
                    final sst = st.toString();
                    return sst.startsWith('Built<') ||
                        sst.startsWith('BuiltIterable<');
                  }) >=
                  0 ||
              returnType.displayName == 'BuiltMap')) {
        sb.writeln('''
    emit(state.rebuild((final b) {
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
    emit(state.rebuild((final b) => b.${field.displayName} = ${field.displayName}));
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

    return sb.toString();
  }
}
