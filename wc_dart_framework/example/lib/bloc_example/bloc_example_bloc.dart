// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:example/bloc_example/bloc_example_state.dart';
import 'package:example/bloc_example/serializers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

import 'bloc_example_data.dart';

part 'bloc_example_bloc.bloc.g.dart';

final _logger = Logger('bloc_example_bloc.dart');

@BlocGen(
  hydrateState: true,
  hydrateStateKey: 'blocExampleState',
)
class BlocExampleBloc extends Cubit<BlocExampleState>
    with HydratedMixin, _BlocExampleBlocHydratedMixin, _BlocExampleBlocMixin {
  BlocExampleBloc() : super(BlocExampleState()) {
    hydrate();
  }

  factory BlocExampleBloc.of(final BuildContext context) =>
      BlocProvider.of<BlocExampleBloc>(context);

  void updateData() {
    emit(
      state.rebuild(
        (b) {
          b.value1 = 'val1';
          b.value2 = 2;
          b.value3 = 3.1;
          b.value4.replace(BlocExampleData((b) => b
            ..id = 1
            ..name = 'val4'
            ..createdOn = DateTime.now().toUtc()));
          b.value5.add(BlocExampleData((b) => b
            ..id = 2
            ..name = 'val5'
            ..createdOn = DateTime.now().toUtc()));
          b.value9[9] = BlocExampleData((b) => b
            ..id = 9
            ..name = 'val9'
            ..createdOn = DateTime.now().toUtc());
          b.value10['10'] = BlocExampleData((b) => b
            ..id = 10
            ..name = 'val10'
            ..createdOn = DateTime.now().toUtc());
        },
      ),
    );
  }
}
