import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

final ggFormatter = DartFormatter(useGgModifications: true, pageWidth: 120);
final defaultFormatter = DartFormatter(useGgModifications: false, pageWidth: 120);

// .............................................................................
bool _containsTryStateMent(String file) {
  return file.contains('try {');
}

// .............................................................................
void _fixTryCatch(FileSystemEntity fileSystemEntity) {
  try {
    if (fileSystemEntity is Directory) {
      return;
    }

    final failingFileNames = [
      '/Users/gatzsche/dev/bmw/mobile-connected/repositories/order_center_cn_repository/test/order_center_cn_api_client_test.dart',
    ];

    final fileName = fileSystemEntity.absolute.path;
    if (failingFileNames.contains(fileName)) {
      return;
    }

    final file = File(fileName);

    final source = file.readAsStringSync();

    if (!_containsTryStateMent(source)) {
      return;
    }
    print(fileName);
    final fixedSource = ggFormatter.format(source);
    final formattedSource = defaultFormatter.format(fixedSource);
    File(fileName).writeAsStringSync(formattedSource);
  } on FormatterException catch (ex) {
    print(ex);
  }
}

// .............................................................................
main() {
  const basePath = '/Users/gatzsche/dev/bmw/mobile-connected';
  const subDirs = [
    'common_api',
    'feature_module_components',
    'feature_modules',
    'localizations_sdk',
    'platform_sdk',
    'platform_sdk_test',
    'plugins',
    'repositories',
    'shell',
    'test',
  ];

  const folder = '/Users/gatzsche/dev/bmw/mobile-connected';

  for (final subDir in subDirs) {
    final files = Glob('$folder/$subDir/**test/**.dart', recursive: true);
    for (var entity in files.listSync()) {
      _fixTryCatch(entity);
    }
  }
}
