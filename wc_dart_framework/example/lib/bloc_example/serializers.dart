import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:example/bloc_example/bloc_example_data.dart';

import 'custom_builder_factories_data.dart';

part 'serializers.g.dart';

@SerializersFor([
  BlocExampleData,
  CustomBuilderFactoriesData,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
    // ..addBuilderFactory(
    //     const FullType(BuiltList, [FullType(BlocExampleData)]),
    //     () => ListBuilder<BlocExampleData>())
    )
    .build();
