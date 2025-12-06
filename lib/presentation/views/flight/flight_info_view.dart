import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/flights_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/presentation/views/flight_itinerary/flight_detail_view.dart';

class FlightInfoView extends StatelessWidget {
  const FlightInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FlightsController(GetIt.instance())..loadFlights(),
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
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text('Error: ${controller.errorMessage}'))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.loadFlights();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Trip Summary
                              _buildTripSummary(),
                              
                              // Flight Details
                              _buildFlightDetails(controller.flights),
                              
                              // Travel Tips
                              // _buildTravelTips(),
                              
                              // Action Buttons
                              // _buildActionButtons(),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildTripSummary() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip to Riyadh',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Confirmed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Oct 25 - Oct 30, 2025 (6 days)'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('2 Adults, 1 Child'),
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
                  onPressed: () {
                    // Show booking information
                    _showBookingInfoDialog(context, flight);
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