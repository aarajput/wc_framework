import 'dart:async';

import 'package:bloc/bloc.dart';

typedef BlocListenWhenCondition<S> = bool Function(S previous, S current);

class BlocBasicListener<B extends BlocBase<State>, State> {
  Stream<State> get stream => bloc.stream.where(
        (final state) {
          final result = listenWhen(_lastState, state);
          _lastState = state;
          return result;
        },
      );

  final BlocBase<State> bloc;
  final BlocListenWhenCondition<State> listenWhen;
  late State _lastState;

  BlocBasicListener({
    required this.bloc,
    required this.listenWhen,
  }) : _lastState = bloc.state;
}
