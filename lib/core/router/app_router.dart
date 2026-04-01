import 'package:auto_route/auto_route.dart';
import 'package:erp/features/splash/presentation/splash_screen.dart';
import 'package:erp/features/auth/presentation/login_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
  ];
}
