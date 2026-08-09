class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.7:3000/api/v1';

  static String get baseOrigin => 'http://192.168.1.7:3000';

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';

    if (path.startsWith('assets/')) return path;

    if (path.contains('localhost:3000')) {
      final relativePath = path.substring(
        path.indexOf('localhost:3000') + 'localhost:3000'.length,
      );
      return '$baseOrigin$relativePath';
    }
    if (path.contains('127.0.0.1:3000')) {
      final relativePath = path.substring(
        path.indexOf('127.0.0.1:3000') + '127.0.0.1:3000'.length,
      );
      return '$baseOrigin$relativePath';
    }
    if (path.contains('rahala.duckdns.org')) {
      final relativePath = path.substring(
        path.indexOf('rahala.duckdns.org') + 'rahala.duckdns.org'.length,
      );
      return '$baseOrigin$relativePath';
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseOrigin$cleanPath';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleAuth = '/auth/google';
  static const String refreshToken = '/auth/refresh-token';
  static const String profile = '/user/profile';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String companies = '/companies';
  static const String favorites = '/favorites';

  /// admin
  static const String adminStats = '/admin/stats';
  static const String adminCompanyStats = '/admin/company-stats';
  static const String adminTrips = '/trips';
  static const String trips = '/trips';
  static const String bookings = '/bookings';
}
