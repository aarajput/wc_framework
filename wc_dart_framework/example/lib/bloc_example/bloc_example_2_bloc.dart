import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:example/bloc_example/bloc_example_state.dart';
import 'package:example/bloc_example/serializers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

import 'bloc_example_data.dart';
import 'bloc_example_enum.dart';
import 'bloc_example_event.dart';

part 'bloc_example_2_bloc.bloc.g.dart';

final _logger = Logger('bloc_example_2_bloc.dart');

@BlocGen()
class BlocExample2Bloc extends Bloc<BlocExampleEvent, BlocExampleState> {
  BlocExample2Bloc() : super(BlocExampleState());
}
