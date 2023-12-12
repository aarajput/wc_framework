import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'bloc_example_string_bloc.bloc.g.dart';

@BlocGen(
  generateFieldSelectors: false
)
class BlocExampleStringBloc extends Cubit<String?> {
  BlocExampleStringBloc() : super(null);

  factory BlocExampleStringBloc.of(final BuildContext context) =>
      BlocProvider.of<BlocExampleStringBloc>(context);
}
