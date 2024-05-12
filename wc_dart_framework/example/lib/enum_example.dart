import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'enum_example.enum.g.dart';
part 'enum_example.g.dart';

@EnumGen()
enum EnumExample {
  valueE1,
  valueE2,
  valueE3,
}

@EnumGen()
class BuiltEnumExample extends EnumClass {
  static Serializer<BuiltEnumExample> get serializer =>
      _$builtEnumExampleSerializer;

  static BuiltSet<BuiltEnumExample> get values => _$values;

  static BuiltEnumExample valueOf(String name) => _$valueOf(name);

  static const BuiltEnumExample value1 = _$value1;
  static const BuiltEnumExample value2 = _$value2;
  static const BuiltEnumExample value3 = _$value3;

  static const someValues = [
    value1,
    value2,
  ];

  const BuiltEnumExample._(String name) : super(name);
}
