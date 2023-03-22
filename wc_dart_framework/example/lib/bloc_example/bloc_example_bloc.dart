import 'package:example/bloc_example/bloc_example_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'bloc_example_bloc.bloc.g.dart';

@BlocGen()
class BlocExampleBloc extends Cubit<BlocExampleState> {
  BlocExampleBloc() : super(BlocExampleState());

  factory BlocExampleBloc.of(final BuildContext context) =>
      BlocProvider.of<BlocExampleBloc>(context);
}
