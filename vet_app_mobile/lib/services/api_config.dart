class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'VET_APP_API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static Uri get baseUri {
    final uri = Uri.parse(baseUrl);
    if (uri.scheme != 'https') {
      throw StateError(
        'VET_APP_API_BASE_URL must use HTTPS in production environments.',
      );
    }
    return uri;
  }
}
