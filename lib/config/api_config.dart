class ApiConfig {
  // Base URLs
  static const String baseUrl = 'https://insidethekingdom.online';
  static const String authBaseUrl = '$baseUrl/auth';
  static const String destinationBaseUrl = '$baseUrl/destinations';
  static const String bookingBaseUrl = '$baseUrl/bookings';
  static const String userBaseUrl = '$baseUrl/users';
  
  // API Endpoints
  // Auth
  static const String registerEndpoint = '$authBaseUrl/register';
  static const String loginEndpoint = '$authBaseUrl/login';
  static const String logoutEndpoint = '$authBaseUrl/logout';
  
  // Destinations
  static const String searchDestinationsEndpoint = '$destinationBaseUrl/search';
  static const String getRecommendationsEndpoint = '$destinationBaseUrl/recommendations';
  
  // Bookings
  static const String createBookingEndpoint = '$bookingBaseUrl';
  static const String getUserBookingsEndpoint = '$bookingBaseUrl/user';
  
  // Users
  static const String updateUserProfileEndpoint = '$userBaseUrl/profile';
  
  // Headers
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';
  static const String applicationJson = 'application/json';
}