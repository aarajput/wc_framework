import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

extension XPropertyAccessorElement on GetterElement {
  bool get isReturnTypeNullable {
    return returnType.nullabilitySuffix == NullabilitySuffix.question;
  }

  bool hasAnnotation(final String annotation) {
    return metadata.annotations.indexWhere(
          (final md) => md.element?.displayName == annotation,
        ) >=
        0;
  }
}

extension XClassElement on ClassElement {
  bool hasAnnotation(final String annotation) {
    return metadata.annotations.indexWhere(
          (final md) => md.element?.displayName == annotation,
        ) >=
        0;
  }

  bool hasSuperClass(final String superClass) {
    return allSupertypes.indexWhere(
          (final type) => type.getDisplayString() == superClass,
        ) >=
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
          return st.getDisplayString().startsWith('Iterable<');
        }) >=
        0;
  }

  bool get isBuiltMap {
    return displayName == 'BuiltMap' ||
        allSupertypes.indexWhere((final st) {
              return st.getDisplayString().startsWith('BuiltMap<');
            }) >=
            0;
  }
}
