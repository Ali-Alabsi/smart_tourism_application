import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/flights_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/presentation/views/flight_itinerary/flight_detail_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_tourism_application/core/entities/city.dart' as entities;
import 'package:smart_tourism_application/core/use_cases/city/get_cities.dart';

class FlightInfoView extends StatefulWidget {
  const FlightInfoView({super.key});

  @override
  State<FlightInfoView> createState() => _FlightInfoViewState();
}

class _FlightInfoViewState extends State<FlightInfoView> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCityId;
  int? _selectedRating;
  List<entities.City> _cities = [];
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    setState(() {
      _isLoadingCities = true;
    });
    try {
      final getCities = GetIt.instance<GetCities>();
      final cities = await getCities.execute();
      setState(() {
        _cities = cities;
      });
    } catch (_) {
      // يمكن لاحقًا إظهار رسالة خطأ
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCities = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          FlightsController(GetIt.instance())..loadFlights(),
      child: Consumer<FlightsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Flight Information',
              actions: [
                IconButton(
                  onPressed: () {
                    // Handle notifications
                  },
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(
                        child: Text('Error: ${controller.errorMessage}'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.loadFlights(
                            name: _searchController.text,
                            cityId: _selectedCityId,
                            rating: _selectedRating,
                          );
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search & Trip Summary
                              _buildSearchSection(controller),

                              // Flight Details
                              _buildFlightDetails(controller.flights),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSection(FlightsController controller) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search airlines...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              controller.loadFlights(
                name: _searchController.text,
                cityId: _selectedCityId,
                rating: _selectedRating,
              );
            },
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destination city',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 8),
                        _isLoadingCities
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : DropdownButton<int>(
                                value: _selectedCityId,
                                hint: const Text('All cities'),
                                underline: const SizedBox.shrink(),
                                items: _cities
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(c.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCityId = value;
                                  });
                                  controller.loadFlights(
                                    name: _searchController.text,
                                    cityId: _selectedCityId,
                                    rating: _selectedRating,
                                  );
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rating (1-5)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedRating,
                          hint: const Text('Any rating'),
                          underline: const SizedBox.shrink(),
                          items: List.generate(
                            5,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1} Stars'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedRating = value;
                            });
                            controller.loadFlights(
                              name: _searchController.text,
                              cityId: _selectedCityId,
                              rating: _selectedRating,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetails(List<Flight> flights) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Airlines',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...flights.map((flight) {
            return Column(
              children: [
                _AirlineCard(flight: flight),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTravelTips() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _TipCard(
            icon: Icons.luggage,
            title: 'Baggage Information',
            description: '2 checked bags (23kg each) and 1 carry-on bag included',
          ),
          SizedBox(height: 12),
          _TipCard(
            icon: Icons.access_time,
            title: 'Arrival Time',
            description: 'Arrive at the airport at least 2 hours before departure',
          ),
          SizedBox(height: 12),
          _TipCard(
            icon: Icons.local_taxi,
            title: 'Transportation',
            description: 'Airport shuttle service available to major hotels',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Show information about managing flight
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Flight information is managed through the airline\'s website'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Manage Flight',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle download boarding pass
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Download Boarding Pass',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class _AirlineCard extends StatelessWidget {
  final Flight flight;

  const _AirlineCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // Using a placeholder since we don't have actual logos in the API response
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    image: flight.logo.isNotEmpty 
                        ? DecorationImage(
                            image: NetworkImage(flight.logo),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                  child: flight.logo.isEmpty 
                      ? Icon(Icons.airline_stops, color: AppColors.primary)
                      : null,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            flight.averageRating?.toString() ?? 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.location_on, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            '${flight.plainTravelsCount} destinations',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              flight.details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Navigate to flight details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightDetailView(flightId: flight.id),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('View Details'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async{
                    final Uri uri = Uri.parse(flight.url??'');

                    if (!await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication, // فتح المتصفح الخارجي
                    )) {
                    throw 'لا يمكن فتح الرابط $flight.url';
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Book Flights'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingInfoDialog(BuildContext context, Flight flight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Flight Booking'),
          content: Text(
            'Flight bookings for ${flight.name} are available through our partner platforms. '
            'You will be redirected to a secure external website to search and book flights.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, this would open the external booking site
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Redirecting to booking partner...'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}