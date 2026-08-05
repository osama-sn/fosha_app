class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://rahala.duckdns.org/api/v1';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String profile = '/user/profile';
  static const String categories = '/categories';

  /// admin
  static const String adminStats = '/admin/stats';
  static const String adminTrips = '/trips/admin/all';
  static const String trips = '/trips';
}
