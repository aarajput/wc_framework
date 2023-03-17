import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/asset_generator.dart';
import 'src/bloc_generator.dart';
import 'src/built_enum_generator.dart';

Builder builtEnumBuilder(final BuilderOptions options) => PartBuilder(
      [BuiltEnumGenerator()],
      '.eg.dart',
      options: options,
      header: '// ignore_for_file: type=lint, unused_element',
    );

Builder blocBuilder(final BuilderOptions options) => PartBuilder(
      [BlocGenerator()],
      '.bg.dart',
      options: options,
      header:
          '// ignore_for_file: type=lint, unused_element, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member',
    );

Builder assetBuilder(final BuilderOptions options) => PartBuilder(
      [AssetGenerator()],
      '.ag.dart',
      options: options,
      header:
          '// ignore_for_file: type=lint, unused_element, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member',
    );
