/// Payment Gateways Configuration (Test Mode)
///
/// Place the test credentials from Tabby & Tamara dashboards here.
/// - Tabby  : Dashboard > Settings > API keys  (public key starts with pk_test_)
/// - Tamara : Dashboard > Integration > API credentials
library;

class PaymentGatewayConfig {
  // ═══════════════ Tabby ═══════════════
  static const String tabbyPublicKey = 'pk_test_PLACEHOLDER_TABBY_KEY';
  static const String tabbyMerchantCode = 'sa';
  static const bool tabbySandbox = true;

  // ═══════════════ Tamara ═══════════════
  static const String tamaraAuthToken = 'PLACEHOLDER_TAMARA_AUTH_TOKEN';
  static const String tamaraApiUrlSandbox = 'https://api-sandbox.tamara.co';
  static const String tamaraApiUrlProduction = 'https://api.tamara.co';
  static const String tamaraNotificationWebhookUrl = '';
  static const String tamaraPublicKey = 'PLACEHOLDER_TAMARA_PUBLIC_KEY';
  static const String tamaraNotificationToken = '';
  static const bool tamaraSandbox = true;

  // ═══════════════ Shared ═══════════════
  static const String currencyCode = 'SAR';
  static const String countryCode = 'SA';
  static const String regionName = 'Riyadh';
  static const String storeName = 'El Tarshoby Store';
}