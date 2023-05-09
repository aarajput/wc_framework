import 'package:meta/meta_meta.dart';

@Target({TargetKind.getter})
class BlocUpdateField {
  const BlocUpdateField();
}

@Target({TargetKind.classType})
class BlocGen {
  final bool hydrateState;

  const BlocGen({
    this.hydrateState = false,
  });
}

@Target({TargetKind.getter})
class BlocHydratedField {
  const BlocHydratedField();
}

@Target({TargetKind.classType})
class BlocHydratedState {
  const BlocHydratedState();
}
