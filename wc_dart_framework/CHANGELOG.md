# Changelog

## 1.13.0

- Fix: Generated code no longer marks parameters as `final`, which is an error on Dart 3.13 and
  above.

## 1.12.1

- Version matched with 'wc_dart_framework_generator'

## 1.12.0

- Version matched with 'wc_dart_framework_generator'

## 1.11.0

- Version matched with 'wc_dart_framework_generator'

## 1.10.0

- Migration: aligned with analyzer 7.4 new element model (elements2/fragments).

## 1.9.1

- Documentation added by [@alihamza0173](https://github.com/alihamza0173).

## 1.9.0

- Breaking: Added @BlocListenField. Now \_$onUpdateField will only generate if @BlocListenField is
  used.

## 1.8.0

- Bloc generator now supports all classes that extends BlocBase.

## 1.7.0

- packages updated

## 1.6.0

- generateFieldSelectors field added in BlocGen annotation

## 1.5.0

- In BlocSelector you can pass bloc.
- Packages updated

## 1.4.0

- @BlocGenIgnoreFieldSelector added.

## 1.3.0

- hydrateStateKey added in @BlocGen.

## 1.2.0

- hydrateState added in @BlocGen.

## 1.1.0

- BlocHydratedField added.
- LoggingUtils added.

## 1.0.1

- EnumGen's TargetKind updated.

## 1.0.0

- Initial version.
