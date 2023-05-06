import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'bloc_example_data.dart';

part 'custom_builder_factories_data.g.dart';

abstract class CustomBuilderFactoriesData
    implements
        Built<CustomBuilderFactoriesData, CustomBuilderFactoriesDataBuilder> {
  factory CustomBuilderFactoriesData([
    final void Function(CustomBuilderFactoriesDataBuilder) updates,
  ]) = _$CustomBuilderFactoriesData;

  CustomBuilderFactoriesData._();

  static Serializer<CustomBuilderFactoriesData> get serializer =>
      _$customBuilderFactoriesDataSerializer;

  BuiltList<BlocExampleData> get f1;

  BuiltMap<int, BlocExampleData> get f2;
}
