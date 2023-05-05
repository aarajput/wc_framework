// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:example/bloc_example/bloc_example_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

import 'bloc_example_data.dart';

part 'bloc_example_bloc.bloc.g.dart';

const dynamic _logger = '';

@BlocGen()
class BlocExampleBloc extends Cubit<BlocExampleState?> {
  BlocExampleBloc() : super(BlocExampleState());
}
