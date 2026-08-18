class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.11:3000/api/v1';

  static String get baseOrigin => 'http://192.168.1.11:3000';

  static String getImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';

    String clean = path.trim();

    if (clean.startsWith('assets/')) return clean;

    if (clean.startsWith('file:///')) {
      clean = clean.replaceFirst('file:///', '/');
    } else if (clean.startsWith('file://')) {
      clean = clean.replaceFirst('file://', '');
    } else if (clean.startsWith('file:/')) {
      clean = clean.replaceFirst('file:/', '');
    }

    if (clean.contains('localhost:3000')) {
      final relativePath = clean.substring(
        clean.indexOf('localhost:3000') + 'localhost:3000'.length,
      );
      return '$baseOrigin$relativePath';
    }
    if (clean.contains('127.0.0.1:3000')) {
      final relativePath = clean.substring(
        clean.indexOf('127.0.0.1:3000') + '127.0.0.1:3000'.length,
      );
      return '$baseOrigin$relativePath';
    }
    if (clean.contains('rahala.duckdns.org')) {
      final relativePath = clean.substring(
        clean.indexOf('rahala.duckdns.org') + 'rahala.duckdns.org'.length,
      );
      return '$baseOrigin$relativePath';
    }

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }

    final formattedPath = clean.startsWith('/') ? clean : '/$clean';
    return '$baseOrigin$formattedPath';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleAuth = '/auth/google';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
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
  static const String chats = '/chats';
}

