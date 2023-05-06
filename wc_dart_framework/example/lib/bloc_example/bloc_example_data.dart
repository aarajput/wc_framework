import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

import 'serializers.dart';

part 'bloc_example_data.g.dart';

abstract class BlocExampleData
    with BlocHydratedSerializer
    implements Built<BlocExampleData, BlocExampleDataBuilder> {
  factory BlocExampleData([
    final void Function(BlocExampleDataBuilder) updates,
  ]) = _$BlocExampleData;

  BlocExampleData._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final BlocExampleDataBuilder b) {
    b.id = -1;
    b.name = 'test';
    b.createdOn = DateTime.now().toUtc();
  }

  static Serializer<BlocExampleData> get serializer =>
      _$blocExampleDataSerializer;

  int get id;

  String get name;

  DateTime get createdOn;

  BuiltList<int?> get ints;

  BuiltList<BuiltList<int>> get intsDouble;

  BuiltMap<String, String?> get maps;

  BuiltMap<BlocExampleData, BlocExampleData> get mapsDatas;

  static BlocExampleData fromDynamic(final dynamic json) {
    return serializers.deserializeWith(
      serializer,
      json,
    )!;
  }

  static BuiltList<BlocExampleData> fromDynamics(final List<dynamic> list) {
    return BuiltList<BlocExampleData>(list.map(fromDynamic));
  }

  @override
  Object? toDynamic() {
    return serializers.serializeWith(serializer, this);
  }
}
