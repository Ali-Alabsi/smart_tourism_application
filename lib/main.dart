import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/di/service_locator.dart';
import 'package:smart_tourism_application/presentation/views/auth/login_view.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/home_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/destination_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/booking_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/budget_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/destinations_controller.dart';
import 'package:smart_tourism_application/presentation/controllers/ratings_controller.dart';
import 'package:smart_tourism_application/presentation/views/budget/budget_view.dart';
import 'package:smart_tourism_application/presentation/views/budget/budget_planning_view.dart';
import 'package:smart_tourism_application/presentation/views/budget/budget_list_view.dart';
import 'package:smart_tourism_application/presentation/views/budget/budget_detail_view.dart';
import 'package:smart_tourism_application/presentation/views/profile/profile_view.dart';
import 'package:smart_tourism_application/presentation/views/home/home_view.dart';
import 'package:smart_tourism_application/presentation/views/onboarding/onboarding_screen.dart';

import 'presentation/views/auth/register_view.dart';
import 'presentation/views/auth/verification_view.dart';
import 'presentation/views/splash_screen/splash_screen.dart';
import 'presentation/views/hotel/hotel_list_view.dart';
import 'presentation/views/activities/activities_list_view.dart';
import 'presentation/views/flight/flight_info_view.dart';
import 'presentation/views/notifications/notifications_list_view.dart';
import 'presentation/views/destinations/destinations_list_view.dart';
import 'package:smart_tourism_application/presentation/views/flight_itinerary/flight_detail_view.dart';
import 'package:smart_tourism_application/presentation/views/restaurant/restaurant_list_view.dart';
import 'package:smart_tourism_application/presentation/widgets/side_code_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeController(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => DestinationController(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingController(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetController(getIt(), getIt(), getIt(), getIt(), getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => DestinationsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => RatingsController(getIt()),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => HotelBookingController(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inside the Kingdom',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // builder: (context, child) {
        //   return SideCodeWidget(
        //     child: child!,
        //     leftCode: '// Report ID: L001',
        //     rightCode: '// Report ID: R001',
        //   );
        // },
        initialRoute: '/login',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => LoginView(
            // email: 'a@gmail.com',
          ),
          '/home': (context) => HomeView(),
          '/register': (context) => RegisterView(),
          '/hotels': (context) => const HotelListView(),
          '/activities': (context) => const ActivitiesListView(),
          '/flights': (context) => const FlightInfoView(),
          '/flight-detail': (context) => const FlightDetailView(flightId: 1), // Placeholder, actual ID will be passed through navigation
          '/notifications': (context) => const NotificationsListView(),
          '/restaurants': (context) => const RestaurantListView(),
          '/destinations': (context) => const DestinationsListView(),
          '/budget': (context) => BudgetView(),
          '/budget-list': (context) => BudgetListView(),
          '/profile': (context) => ProfileView(),
        },
        // home: SplashScreen(),
      ),
    );
  }
}