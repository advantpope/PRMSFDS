class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String refreshToken = '/auth/token/refresh/';

  // Properties (matches Django's properties/urls.py)
  static const String properties = '/properties/';
  static String propertyDetail(String id) => '/properties/$id/';
  static const String propertySearch = '/properties/search/';
  static const String propertyUploadImage = '/properties/upload-image/';

  // Ownership (matches Django's ownership/urls.py)
  static const String ownership = '/ownership/';
  static String ownershipDetail(String id) => '/ownership/$id/';
  static const String ownershipTransfer = '/ownership/transfer/';
  static const String ownershipHistory = '/ownership/history/';

  // Valuation (matches Django's valuation/urls.py)
  static const String valuations = '/valuation/';
  static const String calculateValuation = '/valuation/calculate/';

  // Taxation (matches Django's taxation/urls.py)
  static const String taxes = '/taxation/';
  static const String generateBill = '/taxation/generate-bill/';
  static const String paymentHistory = '/taxation/payments/';
  static const String clearanceCertificate = '/taxation/clearance/';

  // Reports (matches Django's reports/urls.py)
  static const String reports = '/reports/';
  static const String dashboardStats = '/reports/dashboard-stats/';
  static const String generateReport = '/reports/generate/';
}