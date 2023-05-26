import 'package:meta/meta_meta.dart';

@Target({TargetKind.getter})
class BlocUpdateField {
  const BlocUpdateField();
}

@Target({TargetKind.classType})
class BlocGen {
  final bool hydrateState;
  final String? hydrateStateKey;

  const BlocGen({
    this.hydrateState = false,
    this.hydrateStateKey,
  });
}

@Target({TargetKind.getter})
class BlocGenIgnoreFieldSelector {
  const BlocGenIgnoreFieldSelector();
}

@Target({TargetKind.getter})
class BlocHydratedField {
  const BlocHydratedField();
}

@Target({TargetKind.classType})
class BlocHydratedState {
  const BlocHydratedState();
}
