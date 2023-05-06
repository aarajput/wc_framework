import 'package:analyzer/dart/element/element.dart';

extension XPropertyAccessorElement on PropertyAccessorElement {
  bool get isReturnTypeNullable {
    return returnType
        .getDisplayString(
          withNullability: true,
        )
        .endsWith('?');
  }

  bool hasAnnotation(final String annotation) {
    return metadata.indexWhere(
          (final md) => md.element?.displayName == annotation,
        ) >=
        0;
  }
}

extension XClassElement on ClassElement {
  bool hasAnnotation(final String annotation) {
    return metadata.indexWhere(
          (final md) => md.element?.displayName == annotation,
        ) >=
        0;
  }

  bool hasSuperClass(final String superClass) {
    return allSupertypes.indexWhere((final type) =>
            type.getDisplayString(
              withNullability: false,
            ) ==
            superClass) >=
        0;
  }

  bool get isBuiltValue {
    return allSupertypes.indexWhere((final st) {
              final sst = st.toString();
              return sst.startsWith('Built<') ||
                  sst.startsWith('BuiltIterable<');
            }) >=
            0 ||
        displayName == 'BuiltMap';
  }

  bool get isBuiltObject {
    return allSupertypes.indexWhere((final st) {
          return st.toString().startsWith('Built<');
        }) >=
        0;
  }

  bool get isBlocHydratedSerializer {
    return hasSuperClass('BlocHydratedSerializer');
  }

  bool get isIterable {
    return allSupertypes.indexWhere((final st) {
          return st
              .getDisplayString(
                withNullability: false,
              )
              .startsWith('Iterable<');
        }) >=
        0;
  }

  bool get isBuiltMap {
    return displayName == 'BuiltMap' ||
        allSupertypes.indexWhere((final st) {
              return st
                  .getDisplayString(
                    withNullability: false,
                  )
                  .startsWith('BuiltMap<');
            }) >=
            0;
  }
}
