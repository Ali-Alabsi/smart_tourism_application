class AppConfig {
  static const String appName = 'Inside the Kingdom';
  static const String appVersion = '1.0.0';
  static const bool isDebugMode = true;
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.insidethekingdom.com';
  static const int apiTimeout = 30; // seconds
  
  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableAIRecommendations = true;
}