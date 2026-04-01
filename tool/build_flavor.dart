import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('❌ You must specify a flavor name');
    exit(1);
  }

  final flavor = args.first;
  final apkOnly = args.contains('--apk-only');
  final aabOnly = args.contains('--aab-only');
  final webOnly = args.contains('--web-only');
  final runWeb = args.contains('--run-web');
  final pubspecFile = File('pubspec.yaml');
  final backupFile = File('pubspec_backup.yaml');

  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found');
    exit(1);
  }

  // Backup pubspec.yaml
  backupFile.writeAsStringSync(pubspecFile.readAsStringSync());
  print('💾 Backup created: pubspec_backup.yaml');

  try {
    print('🔧 Updating pubspec.yaml for flavor: $flavor ...');

    final yamlLines = LineSplitter.split(pubspecFile.readAsStringSync()).toList();
    final newYaml = _updateYamlForFlavor(yamlLines, flavor);

    pubspecFile.writeAsStringSync(newYaml.join('\n'));

    // Ensure asset folders/files exist
    _ensureAssetFolders(flavor);

    if (runWeb) {
      print('🌐 Running Flutter Web for flavor: $flavor ...');
      await _runBuild([
        'run',
        '-d',
        'chrome',
        '-t',
        'lib/main_$flavor.dart',
      ]);
      return;
    }

    print('🚀 Running flutter build for flavor: $flavor ...');

    // build commands
    final buildArgs = <String>[];

    if (webOnly) {
      buildArgs.addAll([
        'build',
        'web',
        '--base-href',
        '/',
        '--release',
        '-t',
        'lib/main_$flavor.dart',
      ]);
    } else if (apkOnly) {
      buildArgs.addAll([
        'build',
        'apk',
        '--flavor',
        flavor,
        '-t',
        'lib/main_$flavor.dart',
        '--no-tree-shake-icons',
      ]);
    } else if (aabOnly) {
      buildArgs.addAll([
        'build',
        'appbundle',
        '--flavor',
        flavor,
        '-t',
        'lib/main_$flavor.dart',
        '--no-tree-shake-icons',
      ]);
    } else {
      // Default → APK + AAB + Web
      await _runBuild([
        'build',
        'apk',
        '--flavor',
        flavor,
        '-t',
        'lib/main_$flavor.dart',
        '--no-tree-shake-icons',
      ]);

      await _runBuild([
        'build',
        'appbundle',
        '--flavor',
        flavor,
        '-t',
        'lib/main_$flavor.dart',
        '--no-tree-shake-icons',
      ]);

      await _runBuild([
        'build',
        'web',
        '--base-href',
        '/',
        '--release',
        '-t',
        'lib/main_$flavor.dart',
      ]);

      print('✅ Build completed successfully for flavor: $flavor');
      return;
    }

    await _runBuild(buildArgs);
    print('✅ Build completed successfully for flavor: $flavor');
  } catch (e) {
    print('❌ Error occurred: $e');
  }
}

void _ensureAssetFolders(String flavor) {
  final requiredPaths = [
    'assets/common/icons/',
    'assets/common/images/',
    'assets/common/fonts/',
    'assets/common/translations/',
    'assets/$flavor/icons/',
    'assets/$flavor/images/',
    'assets/$flavor/fonts/',
    'assets/$flavor/data_$flavor.json',
  ];

  for (var path in requiredPaths) {
    if (path.endsWith('.json')) {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync('{}');
        print('⚡ Created missing file: $path');
      }
    } else {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        print('⚡ Created missing folder: $path');
      }
    }
  }
}

List<String> _updateYamlForFlavor(List<String> yamlLines, String flavor) {
  final result = <String>[];
  bool skipping = false;

  for (var line in yamlLines) {
    // If we hit a key with only 2 spaces (second-level key), check if it's one we manage
    if (line.startsWith('  ') && !line.startsWith('    ')) {
      final key = line.trim();
      if (key == 'assets:' || key == 'fonts:') {
        skipping = true;
        result.add(line);
        continue;
      } else {
        skipping = false;
      }
    } else if (line.isNotEmpty && !line.startsWith(' ')) {
      // Top-level key
      skipping = false;
    }

    if (!skipping) {
      result.add(line);
    }
  }

  // Inject New Assets
  final assetsIndex = result.indexWhere((l) => l.trim() == 'assets:');
  if (assetsIndex != -1) {
    result.insertAll(assetsIndex + 1, [
      '    - assets/common/icons/',
      '    - assets/common/images/',
      '    - assets/common/fonts/',
      '    - assets/common/translations/',
      '    - assets/$flavor/icons/',
      '    - assets/$flavor/images/',
      '    - assets/$flavor/fonts/',
      '    - assets/$flavor/data_$flavor.json',
    ]);
  }

  // Inject New Fonts
  final fontsIndex = result.indexWhere((l) => l.trim() == 'fonts:');
  final fontData = [
    '    - family: store',
    '      fonts:',
    '        - asset: assets/$flavor/fonts/store-Regular.otf',
  ];
  
  if (fontsIndex != -1) {
    result.insertAll(fontsIndex + 1, fontData);
  } else {
    final flutterIndex = result.indexWhere((l) => l.trim() == 'flutter:');
    if (flutterIndex != -1) {
      result.insert(flutterIndex + 1, '  fonts:');
      result.insertAll(flutterIndex + 2, fontData);
    }
  }

  return result;
}

Future<void> _runBuild(List<String> args) async {
  final process = await Process.start('flutter', args, runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (exitCode != 0) throw Exception('Flutter command failed with code $exitCode');
}
