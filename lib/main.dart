import 'package:erp/app/erp_app_root.dart';
import 'package:erp/core/config/app_flavor.dart';

AppFlavor _parseFlavor(String value) {
  final normalized = value.trim().toLowerCase();

  for (final f in AppFlavor.values) {
    if (f.name.toLowerCase() == normalized) return f;
  }
  return AppFlavor.webstore;
}

Future<void> main() async {
  // Flutter sets this when building/running with `--flavor <name>`.
  const flavorName = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  final flavor = _parseFlavor(flavorName.isEmpty ? 'webstore' : flavorName);
  await bootstrap(flavor);
}