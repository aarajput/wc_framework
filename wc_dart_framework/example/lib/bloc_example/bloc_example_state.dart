import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:example/bloc_example/bloc_example_data.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

import 'bloc_example_enum.dart';

part 'bloc_example_state.g.dart';

abstract class BlocExampleState
    implements Built<BlocExampleState, BlocExampleStateBuilder> {
  factory BlocExampleState([
    final void Function(BlocExampleStateBuilder) updates,
  ]) = _$BlocExampleState;

  BlocExampleState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final BlocExampleStateBuilder b) => b;

  @BlocHydratedField()
  String? get value1;

  @BlocHydratedField()
  int? get value2;

  @BlocHydratedField()
  double? get value3;

  @BlocHydratedField()
  BlocExampleData? get value4;

  @BlocHydratedField()
  BuiltList<BlocExampleData>? get value5;

  // @BlocHydratedField()
  BuiltList<BuiltList<BlocExampleData>> get value6;

  // @BlocHydratedField()
  BuiltList<BuiltList<BlocExampleData?>> get value7;

  // @BlocHydratedField()
  BuiltList<BuiltSet<BlocExampleData?>> get value8;

  @BlocHydratedField()
  BuiltMap<int, BlocExampleData> get value9;

  @BlocHydratedField()
  BuiltMap<String, BlocExampleData> get value10;

  // @BlocHydratedField()
  BuiltList<BuiltMap<String, BlocExampleData>> get value11;

  @BlocHydratedField()
  @BlocGenIgnoreFieldSelector()
  BlocExampleEnum? get value12;
}
