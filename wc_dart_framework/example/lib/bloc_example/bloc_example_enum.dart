import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'bloc_example_enum.g.dart';
part 'bloc_example_enum.enum.g.dart';

@EnumGen()
class BlocExampleEnum extends EnumClass {
  static Serializer<BlocExampleEnum> get serializer => _$blocExampleEnumSerializer;
  static BuiltSet<BlocExampleEnum> get values => _$values;
  static BlocExampleEnum valueOf(String name) => _$valueOf(name);

  static const BlocExampleEnum e1 = _$e1;
  static const BlocExampleEnum e2 = _$e2;

  const BlocExampleEnum._(String name) : super(name);
}
