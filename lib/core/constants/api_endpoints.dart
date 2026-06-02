class ApiEndpoints {
  static const String baseUrl = "http://192.168.1.16:5000";

  
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  
  
  static const String scan = "/api/scan";
  static const String confirmScan = "/api/confirm-scan";
  static const String overview = "/api/overview";
  static const String inventory = "/api/inventory";
  static const String logs = "/api/logs";
}