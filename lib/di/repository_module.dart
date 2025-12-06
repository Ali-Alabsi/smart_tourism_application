import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_destination_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_booking_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_activities_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_hotels_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_flights_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_notifications_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_restaurants_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_ratings_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_city_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/data/datasources/remote/auth_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/destination_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/activities_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/hotels_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/flights_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/notifications_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/restaurants_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/ratings_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/cities_api.dart';
import 'package:smart_tourism_application/data/datasources/remote/budget_api.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';
import 'package:smart_tourism_application/data/repositories/user_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/destination_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/activities_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/hotels_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/flights_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/notifications_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/restaurants_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/booking_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/ratings_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/budget_repository_impl.dart';
import 'package:smart_tourism_application/data/repositories/city_repository_impl.dart';
import 'package:smart_tourism_application/config/api_config.dart';

class RepositoryModule {
  static Future<void> setup() async {
    final getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton(() => DioClient(baseUrl: ApiConfig.baseUrl));
    getIt.registerLazySingleton(() => SharedPrefs());
    getIt.registerLazySingleton(() => AuthApi(getIt(), getIt()));
    getIt.registerLazySingleton(() => DestinationApi(getIt()));
    getIt.registerLazySingleton(() => ActivitiesApi(getIt()));
    getIt.registerLazySingleton(() => HotelsApi(getIt()));
    getIt.registerLazySingleton(() => FlightsApi(getIt()));
        getIt.registerLazySingleton(() => NotificationsApi(getIt()));
        getIt.registerLazySingleton(() => RestaurantsApi(getIt()));
        getIt.registerLazySingleton(() => RatingsApi(getIt()));
        getIt.registerLazySingleton(() => BudgetApi(getIt(), getIt()));
        getIt.registerLazySingleton(() => CitiesApi(getIt()));

    // Repositories
    getIt.registerLazySingleton<IUserRepository>(
      () => UserRepositoryImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<IDestinationRepository>(
      () => DestinationRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IActivitiesRepository>(
      () => ActivitiesRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IHotelsRepository>(
      () => HotelsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IFlightsRepository>(
      () => FlightsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<INotificationsRepository>(
      () => NotificationsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IRestaurantsRepository>(
      () => RestaurantsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IBookingRepository>(
      () => BookingRepositoryImpl(),
    );
    getIt.registerLazySingleton<IRatingsRepository>(
      () => RatingsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<IBudgetRepository>(
      () => BudgetRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<ICityRepository>(
      () => CityRepositoryImpl(getIt()),
    );
  }
}