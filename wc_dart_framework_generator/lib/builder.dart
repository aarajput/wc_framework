import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/asset_generator.dart';
import 'src/bloc_generator.dart';
import 'src/built_enum_generator.dart';

Builder builtEnumBuilder(final BuilderOptions options) => PartBuilder(
      [BuiltEnumGenerator()],
      '.enum.g.dart',
      options: options,
      header: '// ignore_for_file: type=lint, unused_element',
    );

Builder blocBuilder(final BuilderOptions options) => PartBuilder(
      [BlocGenerator()],
      '.bloc.g..dart',
      options: options,
      header:
          '// ignore_for_file: type=lint, unused_element',
    );

Builder assetBuilder(final BuilderOptions options) => PartBuilder(
      [AssetGenerator()],
      '.asset.g.dart',
      options: options,
      header:
          '// ignore_for_file: type=lint, unused_element',
    );
