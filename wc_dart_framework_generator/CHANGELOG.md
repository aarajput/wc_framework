## 1.9.4
- default warning for enum generation is fixed.

## 1.9.3
- source_gen: '>=1.4.0 <3.0.0'
- analyzer: '>=6.5.0 <8.0.0'
- storagePrefix added for HydratedBloc

## 1.9.2
- analyzer: '>=7.0.0 <8.0.0'

## 1.9.1
- source_gen updated to 2.0.0

## 1.9.0
- Breaking: added $ in generate class names.
- Breaking: Add support for @BlocListenField. Now _$onUpdateField will only generate if @BlocListenField is used.

## 1.8.2
- buildWhen added in BlocBuilder.

## 1.8.1
- enum generation for custom fields is fixed.

## 1.8.0
- Bloc generator now supports all classes that extends BlocBase.

## 1.7.2
- bloc update generator issue fixed if field name is "state"

## 1.7.1
- bloc update generator issue fixed if field name is "state"

## 1.7.0
- packages updated

## 1.6.1
- blocState is replaced with state in hydration code generation

## 1.6.0
- generateFieldSelectors field support added in BlocGen annotation

## 1.5.1
- Passing bloc in BlocSelect crash fixed.

## 1.5.0
- In BlocSelector you can pass bloc.
- Packages updated

## 1.4.0
- @BlocGenIgnoreFieldSelector support added.

## 1.3.2
- null check fixed in hydrated state.

## 1.3.1
- enum support fixed for hydration.

## 1.3.0
- read hydrateStateKey from @BlocGen.

## 1.2.1
- state is replaced with blocState inside fromJson.

## 1.2.0
- read hydrateState from @BlocGen.

## 1.1.3
- null check added in fromJson.

## 1.1.2
- Generate will generate HydratedMixin only if any hydrated field is present.

## 1.1.1
- toJson state null check added.

## 1.1.0
- BlocHydratedField added.

## 1.0.1
- version sync with wc_dart_framework.

## 1.0.0
- Initial version.