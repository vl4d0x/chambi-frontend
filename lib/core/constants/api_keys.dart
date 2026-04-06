class ApiKeys {
  ApiKeys._();

  // TODO(backend): Move to --dart-define or secure env config before production.
  // Mapbox public tokens are designed for client-side use; restrict by bundle ID
  // in the Mapbox account dashboard.
  static const String mapboxPublicToken = 'pk.YOUR_MAPBOX_PUBLIC_TOKEN_HERE';
}
