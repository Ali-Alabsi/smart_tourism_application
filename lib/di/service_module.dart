import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/core/use_cases/user/login_user.dart';
import 'package:smart_tourism_application/core/use_cases/user/register_user.dart';
import 'package:smart_tourism_application/core/use_cases/destination/search_destinations.dart';
import 'package:smart_tourism_application/core/use_cases/destination/get_recommendations.dart';
import 'package:smart_tourism_application/core/use_cases/booking/create_booking.dart';
import 'package:smart_tourism_application/core/use_cases/booking/get_user_bookings.dart';
import 'package:smart_tourism_application/core/use_cases/budget/set_budget.dart';
import 'package:smart_tourism_application/core/use_cases/budget/split_group_budget.dart';
import 'package:smart_tourism_application/services/api/auth_service.dart';
import 'package:smart_tourism_application/services/api/destination_service.dart';
import 'package:smart_tourism_application/services/api/booking_service.dart';
import 'package:smart_tourism_application/presentation/controllers/activities_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/hotels_controller.dart';

class ServiceModule {
  static void setup() {
    final getIt = GetIt.instance;

    // Use cases
    getIt.registerLazySingleton(() => LoginUser(getIt()));
    getIt.registerLazySingleton(() => RegisterUser(getIt()));
    getIt.registerLazySingleton(() => SearchDestinations(getIt()));
    getIt.registerLazySingleton(() => GetRecommendations(getIt()));
    getIt.registerLazySingleton(() => CreateBooking(getIt()));
    getIt.registerLazySingleton(() => GetUserBookings(getIt()));
    getIt.registerLazySingleton(() => SetBudget(getIt()));
    getIt.registerLazySingleton(() => SplitGroupBudget(getIt()));

    // Services
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
    getIt.registerLazySingleton(() => DestinationService(getIt(), getIt()));
    getIt.registerLazySingleton(() => BookingService(getIt(), getIt()));
    
    // Controllers
    getIt.registerFactory(() => ActivitiesController(getIt()));
    getIt.registerFactory(() => HotelsController(getIt()));
  }
}