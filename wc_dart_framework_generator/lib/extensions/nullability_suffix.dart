import 'package:analyzer/dart/element/nullability_suffix.dart';

extension XNullabilitySuffix on NullabilitySuffix {
  toCharacter() {
    switch (this) {
      case NullabilitySuffix.question:
        return '?';
      case NullabilitySuffix.star:
        return '*';
      case NullabilitySuffix.none:
        return '';
    }
  }
}
