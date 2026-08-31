import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

extension XInterfaceType on InterfaceType {
  InterfaceType? getIterableInterfaceType() {
    return allSupertypes.firstWhereOrNull((st) {
      return st.toString().startsWith('Iterable<');
    });
  }
}
