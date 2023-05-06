import 'package:analyzer/dart/element/nullability_suffix.dart';

extension XNullabilitySuffix on NullabilitySuffix {
  toCharacter() {
    switch (this) {
      case NullabilitySuffix.question:
        return '?';
        break;
      case NullabilitySuffix.star:
        return '*';
        break;
      case NullabilitySuffix.none:
        return '';
        break;
    }
  }
}
