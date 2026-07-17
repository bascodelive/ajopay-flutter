/// Compile-time environment configuration.
///
/// Per ajopay-flutter-blueprint.md Section 3: which backend the app talks to
/// is decided at BUILD time via --dart-define, never hardcoded in source and
/// never committed to git as a literal value.
///
/// Local dev:
///   flutter run \
///     --dart-define=API_BASE_URL=http://localhost:8080 \
///     --dart-define=API_KEY=<dev key>
///
/// Production build:
///   flutter build apk \
///     --dart-define=API_BASE_URL=https://api.ajopayapp.com \
///     --dart-define=API_KEY=<prod key>
abstract final class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  /// Fails loudly at startup rather than silently sending an empty
  /// X-API-Key header — every request needs one (blueprint Section 4),
  /// including pre-login auth endpoints, so a missing key is never a
  /// case worth limping forward on.
  static void assertConfigured() {
    if (apiKey.isEmpty) {
      throw StateError(
        'API_KEY was not supplied via --dart-define. '
        'Every request requires X-API-Key (blueprint Section 4) — '
        'the app cannot run without one, even against localhost.',
      );
    }
  }
}
