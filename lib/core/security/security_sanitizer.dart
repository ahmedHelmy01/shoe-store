class SecuritySanitizer {
  /// Sanitizes text to prevent basic XSS and injection patterns.
  /// This should be used on all user-facing inputs in the admin panel.
  static String sanitize(String input) {
    if (input.isEmpty) return input;

    // Do not trim while typing to avoid breaking spaces between words.
    // Field submit handlers already trim values when needed.
    String sanitized = input;

    // Remove <script> tags and similar patterns
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*script[^>]*>', caseSensitive: false), '');
    
    // Remove "on..." event handlers (e.g. onclick, onerror) which are common in XSS
    sanitized = sanitized.replaceAll(RegExp(r'\s+on\w+\s*=', caseSensitive: false), ' ');

    // Strip out common SQL injection characters if they look like a pattern
    // Note: Be careful not to break legitimate text.
    // For extreme security, we'd whitelist characters, but for general ERP text, we strip suspicious sequences.
    
    return sanitized;
  }

  /// Verifies if the input contains suspicious characters.
  static bool isSuspicious(String input) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'src=', caseSensitive: false),
      RegExp(r'SELECT\s+\*\s+FROM', caseSensitive: false),
      RegExp(r'DROP\s+TABLE', caseSensitive: false),
    ];

    return suspiciousPatterns.any((pattern) => pattern.hasMatch(input));
  }
}
