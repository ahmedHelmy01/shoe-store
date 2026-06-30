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
  final terms_and_conditions = 'common.terms_and_conditions';
  final contact_us = 'common.contact_us';
  final forgot_password = 'common.forgot_password';
  final no_account = 'common.no_account';
  final register_now = 'common.register_now';
  final next = 'common.next';
  final back = 'common.back';
  final get_started = 'common.get_started';
  final try_again = 'common.try_again';
  final error = 'common.error';
  final page_not_found = 'common.page_not_found';
  final home_address = 'common.home_address';
  final subject = 'common.subject';
  final your_message = 'common.your_message';
  final send_message = 'common.send_message';
  final field_required = 'common.field_required';
  final sent_successfully = 'common.sent_successfully';
  final contact_thanks = 'common.contact_thanks';
  final ok = 'common.ok';
  final no_data = 'common.no_data';
  final retry = 'common.retry';
  final unexpected_error = 'common.unexpected_error';
  final check_internet = 'common.check_internet';
  final server_not_responding = 'common.server_not_responding';
  final cart_empty = 'common.cart_empty';
  final cart_empty_subtitle = 'common.cart_empty_subtitle';
  final browse_products = 'common.browse_products';
  final no_orders_yet = 'common.no_orders_yet';
  final no_orders_yet_subtitle = 'common.no_orders_yet_subtitle';
  final no_results = 'common.no_results';
  final no_results_subtitle = 'common.no_results_subtitle';
  final no_internet = 'common.no_internet';
  final timeout = 'common.timeout';
  final login_again = 'common.login_again';
  final cache_error = 'common.cache_error';
  final item_not_found = 'common.item_not_found';
  final timeout_server = 'common.timeout_server';
  final unauthorized = 'common.unauthorized';
  final forbidden = 'common.forbidden';
  final not_found_requested = 'common.not_found_requested';
  final conflict = 'common.conflict';
  final server_error_try_later = 'common.server_error_try_later';
  final request_cancelled = 'common.request_cancelled';
  final session_expired_login_again = 'common.session_expired_login_again';
  final cache_load_error = 'common.cache_load_error';
  final unexpected_error_retry = 'common.unexpected_error_retry';
}

class _WebStore {
  const _WebStore();
  final auth = const _WebStoreAuth();
  final home = const _WebStoreHome();
  final nav = const _WebStoreNav();
  final general = const _WebStoreGeneral();
  final orders = const _WebStoreOrders();
  final wishlist = const _WebStoreWishlist();
  final points = const _WebStorePoints();
  final more = const _WebStoreMore();
  final checkout = const _WebStoreCheckout();
  final profile = const _WebStoreProfile();
  final prescriptions = const _WebStorePrescriptions();
}

class _WebStorePrescriptions {
  const _WebStorePrescriptions();
  final title = 'webstore.prescriptions.title';
  final upload = 'webstore.prescriptions.upload';
  final upload_title = 'webstore.prescriptions.upload_title';
  final upload_subtitle = 'webstore.prescriptions.upload_subtitle';
  final tap_to_upload = 'webstore.prescriptions.tap_to_upload';
  final change_image = 'webstore.prescriptions.change_image';
  final additional_notes = 'webstore.prescriptions.additional_notes';
  final notes_hint = 'webstore.prescriptions.notes_hint';
  final confirm_send = 'webstore.prescriptions.confirm_send';
  final uploading = 'webstore.prescriptions.uploading';
  final select_image_source = 'webstore.prescriptions.select_image_source';
  final camera = 'webstore.prescriptions.camera';
  final gallery = 'webstore.prescriptions.gallery';
  final pick_image_failed = 'webstore.prescriptions.pick_image_failed';
  final pick_image_first = 'webstore.prescriptions.pick_image_first';
  final empty_title = 'webstore.prescriptions.empty_title';
  final empty_subtitle = 'webstore.prescriptions.empty_subtitle';
  final upload_new = 'webstore.prescriptions.upload_new';
  final status_pending = 'webstore.prescriptions.status_pending';
  final status_reviewed = 'webstore.prescriptions.status_reviewed';
  final status_rejected = 'webstore.prescriptions.status_rejected';
  final status_approved = 'webstore.prescriptions.status_approved';
  final no_notes = 'webstore.prescriptions.no_notes';
  final edit_notes = 'webstore.prescriptions.edit_notes';
  final edit_notes_hint = 'webstore.prescriptions.edit_notes_hint';
  final delete_prescription = 'webstore.prescriptions.delete_prescription';
  final delete_confirm = 'webstore.prescriptions.delete_confirm';
  final deleted_success = 'webstore.prescriptions.deleted_success';
  final updating = 'webstore.prescriptions.updating';
  final updated_success = 'webstore.prescriptions.updated_success';
  final update_failed = 'webstore.prescriptions.update_failed';
  final retry = 'webstore.prescriptions.retry';
  final detail_title = 'webstore.prescriptions.detail_title';
  final pinch_to_zoom = 'webstore.prescriptions.pinch_to_zoom';
  final order_status = 'webstore.prescriptions.order_status';
  final status_sent = 'webstore.prescriptions.status_sent';
  final status_ready = 'webstore.prescriptions.status_ready';
  final attached_notes = 'webstore.prescriptions.attached_notes';
  final no_attached_notes = 'webstore.prescriptions.no_attached_notes';
  final sent_date = 'webstore.prescriptions.sent_date';
  final prescription_number = 'webstore.prescriptions.prescription_number';
  final delete_this = 'webstore.prescriptions.delete_this';
  final success_title = 'webstore.prescriptions.success_title';
  final success_subtitle = 'webstore.prescriptions.success_subtitle';
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
  final otp_sent = 'webstore.auth.otp_sent';
  final otp_verified = 'webstore.auth.otp_verified';
  final otp_resent = 'webstore.auth.otp_resent';
  final password_reset_success = 'webstore.auth.password_reset_success';
  // ─── New keys ──────────────────────────
  final select_branch = 'webstore.auth.select_branch';
  final select_branch_hint = 'webstore.auth.select_branch_hint';
  final branch_required = 'webstore.auth.branch_required';
  final register_success_title = 'webstore.auth.register_success_title';
  final register_success_message = 'webstore.auth.register_success_message';
  final login_success_title = 'webstore.auth.login_success_title';
  final login_success_message = 'webstore.auth.login_success_message';
  final logout_title = 'webstore.auth.logout_title';
  final logout_confirm = 'webstore.auth.logout_confirm';
  final logout_button = 'webstore.auth.logout_button';
  final login_or_register = 'webstore.auth.login_or_register';
  final welcome_back = 'webstore.auth.welcome_back';
  final welcome_family = 'webstore.auth.welcome_family';
  final guest_title = 'webstore.auth.guest_title';
  final guest_subtitle = 'webstore.auth.guest_subtitle';
  final resend_timer = 'webstore.auth.resend_timer';
}

class _WebStoreHome {
  const _WebStoreHome();
  final search_hint = 'webstore.home.search_hint';
  final shop_now = 'webstore.home.shop_now';
  final categories = 'webstore.home.categories';
  final featured_products = 'webstore.home.featured_products';
  final latest_products = 'webstore.home.latest_products';
  final view_all = 'webstore.home.view_all';
  final medical_services = 'webstore.home.medical_services';
  final most_ordered = 'webstore.home.most_ordered';
  final exclusive_offers = 'webstore.home.exclusive_offers';
  final trusted_brands = 'webstore.home.trusted_brands';
  final tarshooby_offers = 'webstore.home.tarshooby_offers';
  final vouchers_title = 'webstore.home.vouchers_title';
  final voucher_first_order = 'webstore.home.voucher_first_order';
  final voucher_skincare = 'webstore.home.voucher_skincare';
  final use_voucher = 'webstore.home.use_voucher';
  final select_branch = 'webstore.home.select_branch';
  final no_products = 'webstore.home.no_products';
  final search_results = 'webstore.home.search_results';
  final filter_results = 'webstore.home.filter_results';
  final no_search_results = 'webstore.home.no_search_results';
  final no_filter_results = 'webstore.home.no_filter_results';
  final my_points = 'webstore.home.my_points';
  final wallet = 'webstore.home.wallet';
  final coupons = 'webstore.home.coupons';
  final no_offers = 'webstore.home.no_offers';
  final wait_for_offers = 'webstore.home.wait_for_offers';
  final explore_now = 'webstore.home.explore_now';
  final feature_products = 'webstore.home.feature_products';
  final feature_categories = 'webstore.home.feature_categories';
  final feature_discounts = 'webstore.home.feature_discounts';
  final feature_new_arrivals = 'webstore.home.feature_new_arrivals';
  final feature_best_sellers = 'webstore.home.feature_best_sellers';
  final feature_special_picks = 'webstore.home.feature_special_picks';
  final no_exclusive_offers = 'webstore.home.no_exclusive_offers';
  final no_exclusive_offers_subtitle = 'webstore.home.no_exclusive_offers_subtitle';
}

class _WebStoreNav {
  const _WebStoreNav();
  final home = 'webstore.nav.home';
  final store = 'webstore.nav.store';
  final cart = 'webstore.nav.cart';
  final profile = 'webstore.nav.profile';
  final more = 'webstore.nav.more';
}

class _WebStoreGeneral {
  const _WebStoreGeneral();
  final exit_confirm = 'webstore.general.exit_confirm';
  final coming_soon = 'webstore.general.coming_soon';
}

class _WebStoreOrders {
  const _WebStoreOrders();
  final title = 'webstore.orders.title';
  final status_processing = 'webstore.orders.status_processing';
  final status_shipped = 'webstore.orders.status_shipped';
  final status_delivered = 'webstore.orders.status_delivered';
  final order_number = 'webstore.orders.order_number';
  final total = 'webstore.orders.total';
  final date = 'webstore.orders.date';
  final details = 'webstore.orders.details';
  final order_items = 'webstore.orders.order_items';
  final quantity = 'webstore.orders.quantity';
  final payment_summary = 'webstore.orders.payment_summary';
  final subtotal = 'webstore.orders.subtotal';
  final delivery_fee = 'webstore.orders.delivery_fee';
  final reorder = 'webstore.orders.reorder';
  final rate_order = 'webstore.orders.rate_order';
  final added_to_cart = 'webstore.orders.added_to_cart';
  final success_order = 'webstore.orders.success_order';
  final payment = 'webstore.orders.payment';
  final order_cancelled = 'webstore.orders.order_cancelled';
  final address = 'webstore.orders.address';
  final coupon = 'webstore.orders.coupon';
  final discount = 'webstore.orders.discount';
  final tax = 'webstore.orders.tax';
  final notes = 'webstore.orders.notes';
  final track_order = 'webstore.orders.track_order';
  final reorder_success = 'webstore.orders.reorder_success';
  final cancel_order = 'webstore.orders.cancel_order';
  final cancel_order_confirm = 'webstore.orders.cancel_order_confirm';
  final cancel_reason_hint = 'webstore.orders.cancel_reason_hint';
  final confirm_cancel = 'webstore.orders.confirm_cancel';
  final cancel_success = 'webstore.orders.cancel_success';
  final each = 'webstore.orders.each';
  final status_cancelled = 'webstore.orders.status_cancelled';
  final status_pending = 'webstore.orders.status_pending';
  final items_count = 'webstore.orders.items_count';
  final item_count = 'webstore.orders.item_count';
  final order_tracking = 'webstore.orders.order_tracking';
  final order_id = 'webstore.orders.order_id';
  final arriving_in = 'webstore.orders.arriving_in';
  final order_placed = 'webstore.orders.order_placed';
  final order_placed_subtitle = 'webstore.orders.order_placed_subtitle';
  final processing_subtitle = 'webstore.orders.processing_subtitle';
  final out_for_delivery = 'webstore.orders.out_for_delivery';
  final out_for_delivery_subtitle = 'webstore.orders.out_for_delivery_subtitle';
  final delivered_subtitle = 'webstore.orders.delivered_subtitle';
  final delivery_partner = 'webstore.orders.delivery_partner';
  final your_rating = 'webstore.orders.your_rating';
  final experience_question = 'webstore.orders.experience_question';
  final update_rating_hint = 'webstore.orders.update_rating_hint';
  final improve_service_hint = 'webstore.orders.improve_service_hint';
  final rate_delivery_service = 'webstore.orders.rate_delivery_service';
  final excellent_service = 'webstore.orders.excellent_service';
  final tap_to_rate = 'webstore.orders.tap_to_rate';
  final could_be_better = 'webstore.orders.could_be_better';
  final add_feedback = 'webstore.orders.add_feedback';
  final feedback_hint = 'webstore.orders.feedback_hint';
  final update_rating = 'webstore.orders.update_rating';
  final submit_feedback = 'webstore.orders.submit_feedback';
  final rating_success = 'webstore.orders.rating_success';
}

class _WebStoreWishlist {
  const _WebStoreWishlist();
  final title = 'webstore.wishlist.title';
  final remove = 'webstore.wishlist.remove';
  final empty = 'webstore.wishlist.empty';
  final add_to_cart = 'webstore.wishlist.add_to_cart';
}

class _WebStorePoints {
  const _WebStorePoints();
  final title = 'webstore.points.title';
  final balance = 'webstore.points.balance';
  final earned = 'webstore.points.earned';
  final spent = 'webstore.points.spent';
  final point = 'webstore.points.point';
  final history = 'webstore.points.history';
}

class _WebStoreProfile {
  const _WebStoreProfile();
  final title = 'webstore.profile.title';
  final personal_info = 'webstore.profile.personal_info';
  final store_location = 'webstore.profile.store_location';
  final full_name = 'webstore.profile.full_name';
  final email_address = 'webstore.profile.email_address';
  final phone_number = 'webstore.profile.phone_number';
  final new_password = 'webstore.profile.new_password';
  final home_address = 'webstore.profile.home_address';
  final your_branch = 'webstore.profile.your_branch';
  final select_branch = 'webstore.profile.select_branch';
  final save_changes = 'webstore.profile.save_changes';
  final delete_account = 'webstore.profile.delete_account';
  final delete_confirm = 'webstore.profile.delete_confirm';
  final delete_button = 'webstore.profile.delete_button';
  final points = 'webstore.profile.points';
  final points_earned = 'webstore.profile.points_earned';
  final update_success = 'webstore.profile.update_success';
}

class _WebStoreMore {
  const _WebStoreMore();
  final appearance = 'webstore.more.appearance';
  final dark_mode = 'webstore.more.dark_mode';
  final language = 'webstore.more.language';
  final arabic = 'webstore.more.arabic';
  final english = 'webstore.more.english';
  final wishlist = 'webstore.more.wishlist';
  final my_orders = 'webstore.more.my_orders';
  final my_points = 'webstore.more.my_points';
}

class _WebStoreCheckout {
  const _WebStoreCheckout();
  final title = 'webstore.checkout.title';
  final delivery_address = 'webstore.checkout.delivery_address';
  final payment_method = 'webstore.checkout.payment_method';
  final promo_code = 'webstore.checkout.promo_code';
  final enter_promo_code = 'webstore.checkout.enter_promo_code';
  final apply = 'webstore.checkout.apply';
  final order_amount = 'webstore.checkout.order_amount';
  final delivery_fee = 'webstore.checkout.delivery_fee';
  final free = 'webstore.checkout.free';
  final total_amount = 'webstore.checkout.total_amount';
  final discount = 'webstore.checkout.discount';
  final place_order = 'webstore.checkout.place_order';
  final visa_mastercard = 'webstore.checkout.visa_mastercard';
  final instapay = 'webstore.checkout.instapay';
  final cash_on_delivery = 'webstore.checkout.cash_on_delivery';
  final cart_empty_error = 'webstore.checkout.cart_empty_error';
  final currency_egp = 'webstore.checkout.currency_egp';
  final coupon_applied_success_discount = 'webstore.checkout.coupon_applied_success_discount';
  final coupon_applied_success = 'webstore.checkout.coupon_applied_success';
  final choose_delivery_address = 'webstore.checkout.choose_delivery_address';
  final no_registered_addresses = 'webstore.checkout.no_registered_addresses';
  final add_new_address = 'webstore.checkout.add_new_address';
  final manage_registered_addresses = 'webstore.checkout.manage_registered_addresses';
  final order_executed_successfully = 'webstore.checkout.order_executed_successfully';
  final order_number_msg = 'webstore.checkout.order_number_msg';
  final thanks_for_shopping_track_order = 'webstore.checkout.thanks_for_shopping_track_order';
  final track_order_btn = 'webstore.checkout.track_order_btn';
  final back_to_home = 'webstore.checkout.back_to_home';
}
