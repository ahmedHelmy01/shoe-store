abstract class LocaleKeys {
  static const common = _Common();
  static const webstore = _WebStore();
}

class _Common {
  const _Common();
  final app_name = 'common.app_name';
  final welcome_message = 'common.welcome_message';
  final home = 'common.home';
  final sales = 'common.sales';
  final purchases = 'common.purchases';
  final inventory = 'common.inventory';
  final reports = 'common.reports';
  final accounts = 'common.accounts';
  final representatives = 'common.representatives';
  final invoices = 'common.invoices';
  final products = 'common.products';
  final customers = 'common.customers';
  final suppliers = 'common.suppliers';
  final settings = 'common.settings';
  final profile = 'common.profile';
  final logout = 'common.logout';
  final login = 'common.login';
  final register = 'common.register';
  final email = 'common.email';
  final password = 'common.password';
  final phone = 'common.phone';
  final name = 'common.name';
  final save = 'common.save';
  final cancel = 'common.cancel';
  final delete = 'common.delete';
  final edit = 'common.edit';
  final add = 'common.add';
  final search = 'common.search';
  final noImage = 'common.noImage';
  final emailRequired = 'common.emailRequired';
  final invalidEmail = 'common.invalidEmail';
  final passwordRequired = 'common.passwordRequired';
  final passwordInvalid = 'common.passwordInvalid';
  final confirmPasswordRequired = 'common.confirmPasswordRequired';
  final passwordsDoNotMatch = 'common.passwordsDoNotMatch';
  final phoneRequired = 'common.phoneRequired';
  final invalidPhone = 'common.invalidPhone';
  final nameRequired = 'common.nameRequired';
  final enterDescription = 'common.enterDescription';
  final dashboard = 'common.dashboard';
  final orders = 'common.orders';
  final collections = 'common.collections';
  final daily_report = 'common.daily_report';
  final notifications = 'common.notifications';
  final about_us = 'common.about_us';
  final contact_us = 'common.contact_us';
  final forgot_password = 'common.forgot_password';
  final no_account = 'common.no_account';
  final register_now = 'common.register_now';
  final next = 'common.next';
  final back = 'common.back';
  final get_started = 'common.get_started';
}

class _WebStore {
  const _WebStore();
  final auth = const _WebStoreAuth();
  final home = const _WebStoreHome();
  final nav = const _WebStoreNav();
  final general = const _WebStoreGeneral();
}

class _WebStoreAuth {
  const _WebStoreAuth();
  final login_title = 'webstore.auth.login_title';
  final login_subtitle = 'webstore.auth.login_subtitle';
  final register_title = 'webstore.auth.register_title';
  final register_subtitle = 'webstore.auth.register_subtitle';
  final forgot_password_title = 'webstore.auth.forgot_password_title';
  final forgot_password_subtitle = 'webstore.auth.forgot_password_subtitle';
  final otp_title = 'webstore.auth.otp_title';
  final otp_subtitle = 'webstore.auth.otp_subtitle';
  final reset_password_title = 'webstore.auth.reset_password_title';
  final reset_password_subtitle = 'webstore.auth.reset_password_subtitle';
  final mobile_label = 'webstore.auth.mobile_label';
  final password_label = 'webstore.auth.password_label';
  final confirm_password_label = 'webstore.auth.confirm_password_label';
  final name_label = 'webstore.auth.name_label';
  final login_button = 'webstore.auth.login_button';
  final register_button = 'webstore.auth.register_button';
  final send_code_button = 'webstore.auth.send_code_button';
  final verify_button = 'webstore.auth.verify_button';
  final save_password_button = 'webstore.auth.save_password_button';
  final no_account = 'webstore.auth.no_account';
  final have_account = 'webstore.auth.have_account';
  final register_now = 'webstore.auth.register_now';
  final login_now = 'webstore.auth.login_now';
  final register_success = 'webstore.auth.register_success';
}

class _WebStoreHome {
  const _WebStoreHome();
  final search_hint = 'webstore.home.search_hint';
  final shop_now = 'webstore.home.shop_now';
  final categories = 'webstore.home.categories';
  final featured_products = 'webstore.home.featured_products';
  final latest_products = 'webstore.home.latest_products';
  final view_all = 'webstore.home.view_all';
}

class _WebStoreNav {
  const _WebStoreNav();
  final home = 'webstore.nav.home';
  final store = 'webstore.nav.store';
  final cart = 'webstore.nav.cart';
  final profile = 'webstore.nav.profile';
}

class _WebStoreGeneral {
  const _WebStoreGeneral();
  final exit_confirm = 'webstore.general.exit_confirm';
  final coming_soon = 'webstore.general.coming_soon';
}
