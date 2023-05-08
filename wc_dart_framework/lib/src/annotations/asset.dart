import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class AssetGen {
  final String path;
  final String? generatedClassName;
  final bool createStaticInstances;
  final bool showExtension;
  final List<String>? includeFileNames;
  final List<String>? excludeFileNames;

  const AssetGen({
    required this.path,
    this.generatedClassName,
    this.createStaticInstances = true,
    this.showExtension = true,
    this.includeFileNames,
    this.excludeFileNames,
  });
}
