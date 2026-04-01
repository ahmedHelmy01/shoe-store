import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('❌ You must specify a flavor name (e.g.,)');
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
    'assets/$flavor/icons/',
    'assets/$flavor/images/',
    'assets/$flavor/fonts/',
    'assets/$flavor/data_${flavor.replaceAll('_', '')}.json',
  ];

  for (var path in requiredPaths) {
    final file = File(path);
    final dir = Directory(path);
    if (path.endsWith('.json')) {
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync('{}'); // empty JSON
        print('⚡ Created missing file: $path');
      }
    } else {
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        print('⚡ Created missing folder: $path');
      }
    }
  }
}

List<String> _updateYamlForFlavor(List<String> yamlLines, String flavor) {
  final result = <String>[];
  bool inAssets = false;

  for (var line in yamlLines) {
    final trimmed = line.trim();

    if (trimmed.startsWith('assets:')) {
      inAssets = true;
      result.add(line);
      continue;
    }

    if (inAssets && !trimmed.startsWith('-') && trimmed.isNotEmpty) {
      inAssets = false;
    }

    if (inAssets && trimmed.startsWith('-')) continue;

    result.add(line);
  }

  final assetLines = [
    '    - assets/common/icons/',
    '    - assets/common/images/',
    '    - assets/common/fonts/',
    '    - assets/$flavor/icons/',
    '    - assets/$flavor/images/',
    '    - assets/$flavor/fonts/',
    '    - assets/$flavor/data_${flavor.replaceAll('_', '')}.json',
  ];

  final insertionIndex = result.indexWhere((line) => line.trim().startsWith('fonts:'));
  if (insertionIndex != -1) {
    result.insertAll(insertionIndex, assetLines);
  } else {
    result.addAll(assetLines);
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
