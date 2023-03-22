import 'package:built_value/built_value.dart';

part 'bloc_example_state.g.dart';

abstract class BlocExampleState
    implements Built<BlocExampleState, BlocExampleStateBuilder> {
  factory BlocExampleState([
    final void Function(BlocExampleStateBuilder) updates,
  ]) = _$BlocExampleState;

  BlocExampleState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final BlocExampleStateBuilder b) => b;

  String get value1;

  int get value2;

  double get value3;
}
