import 'package:erp/app/erp_app_root.dart';
import 'package:erp/core/config/app_flavor.dart';

Future<void> main() async {
  await bootstrap(AppFlavor.full);
}
