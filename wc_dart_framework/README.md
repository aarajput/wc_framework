The `wc_dart_framework` package is designed to provide common code utilities for Flutter projects, reducing boilerplate code and improving development efficiency.

### **Features**

- AssetGen
- BlocGen
- BlocUpdateField
- EnumGen

---

<details>

<summary>AssetGen</summary>

### **AssetGen**

Instead of manually referencing asset paths, `AssetGen` generates a class with static references to all assets within a specified folder structure.

#### **How It Works**

Use the `@AssetGen` annotation to specify the paths to your asset directories.

```dart
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'images.asset.g.dart'; // Generated file

@AssetGen(
  path: 'assets/svgs', // Path to your SVG assets
  showExtension: false,
)
// ignore: unused_element
class _$SvgImages {} // Class for SVG assets

// You can add multiple asset paths
@AssetGen(
  path: 'assets/others',
  showExtension: false,
)
// ignore: unused_element
class _$OtherImages {}
```
This will generate a file named `images.asset.g.dart` containing the asset classes.

#### Use the Generated Classes

Access your assets using the generated classes.

```dart
// Access SVG assets
Image.asset(SvgImages.IC_HOME); // 'assets/svgs/ic_home.svg'

// Access other image assets
Image.asset(OtherImages.RED); // 'assets/others/red.jpeg'
```

</details>

<details>

<summary>BlocGen</summary>

### BlocGen

`BlocGen` is a code generation tool that automates the creation of BLoC classes, selectors, and listener callbacks. It simplifies working with `flutter_bloc` and `built_value` by reducing boilerplate code.

#### **How It Works**

Add the `@BlocGen()` annotation to your BLoC class.

```dart
part 'example_bloc.bloc.g.dart';

@BlocGen()
class ExampleBloc extends Cubit<ExampleState> {
  ExampleBloc() : super(ExampleState());
}

class ExampleState {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;

  ExampleState({
    this.isLoading = false, 
    this.hasError = false, 
    this.errorMessage = '',
  });
}
```

#### Using Generated Selectors

Use the generated selectors to access state fields in a type-safe manner.

```dart
ExampleBlocSelector(
  selector: (state) => state.hasError,
  builder: (hasError) {
    // Your UI code
  },
)
```

For `built_value` states, the selectors are even simpler:

```dart
ExampleBlocSelector.errorMessage(
  builder: (errorMessage) {
    // Your UI code
  },
)
```

</details>

<details>

<summary>BlocUpdateField</summary>

### BlocUpdateField

The `@BlocUpdateField` annotation is used to auto-generate methods for updating state fields in BLoC classes.

#### How It Works

Use the `@BlocUpdateField()` annotation on the fields you want to generate update methods for.

```dart
abstract class ExampleState implements Built<ExampleState, ExampleStateBuilder> {
  ExampleState._();
  factory ExampleState([void Function(ExampleStateBuilder) updates]) = _$ExampleState;

  @BlocUpdateField()
  String get errorMessage;
}
```

#### Add the Mixin to Your BLoC

```dart
@BlocGen()
class ExampleBloc extends Cubit<ExampleState> with _$ExampleBlocMixin {
  ExampleBloc() : super(ExampleState());
}
```

#### Using the Generated Update Methods

```dart
final bloc = BlocProvider.of<ExampleBloc>(context);
bloc.updateErrorMessage('Hello Error!');
```

### Listener Callbacks

Use the `@BlocListenField()` annotation to generate a callback method that is triggered when the field is updated.

```dart
@BlocUpdateField()
@BlocListenField()
String get errorMessage;
```

Override the generated callback method in your BLoC:

```dart
@override
void _$onUpdateErrorMessage() {
  print('Error Message: ${state.errorMessage}');
}
```

</details>

<details>

<summary>EnumGen</summary>

### EnumGen

The `@EnumGen` annotation generates extension methods (`when`, `whenOrNull`, `maybeWhen`) for Dart enums, simplifying enum handling with type-safe, concise code. It reduces boilerplate and prevents compile-time errors by ensuring all enum cases are handled correctly.

#### How It Works

Add the `@EnumGen()` annotation to your enum.

```dart
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'example_enum.enum.g.dart';

@EnumGen()
enum ExampleEnum { enum1, enum2 }
```

### Using The Generated Methods
```dart
final ExampleEnum en = ExampleEnum.enum1;

en.when(
  enum1: () => print('This is enum1'),
  enum2: () => print('This is enum2'),
);
```

</details>

#### Installation and Running the Code Generator

1. Add the `wc_dart_framework` package to your `pubspec.yaml` file:

```yaml
dependencies:
  wc_dart_framework: latest_version
```

2. Add the generator to your dev dependencies:

```yaml
dev_dependencies:
  wc_dart_framework_generator: latest_version
```

3. Run the code generator to generate the missing `.g.dart` files:

```bash
dart run build_runner build
```
