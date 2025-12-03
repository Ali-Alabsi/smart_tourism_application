import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/logo.png', // Ensure you have a logo image in assets
          height: 40,
          width: 40,
        ),
        title: Text(
          'Inside the Kindom', // Note: Keep the spelling as shown
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.account_circle,
            color: Color(0xFF003366),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/budget-list');
            },
            icon: Icon(Icons.account_balance_wallet,
            color: Color(0xFF003366),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: Icon(Icons.notifications ,
            color: Color(0xFF003366),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 167,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundHome.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Where do you want to go?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Q, Search destinations, hotels, activities',

                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  // Features Section
                  Text(
                    'Explore Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _FeatureItem(
                        icon: Icons.hotel, 
                        label: 'Hotels',
                        color: Color(0xFF003366),
                        onTap: () {
                          Navigator.pushNamed(context, '/hotels');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.flight, 
                        label: 'Flights',
                        color: Color(0xFFFFCC33),
                        onTap: () {
                          Navigator.pushNamed(context, '/flights');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.local_activity, 
                        label: 'Activities',
                        color: Color(0xFF918E6D),
                        onTap: () {
                          Navigator.pushNamed(context, '/activities');
                        },
                      ),
                      Consumer<AuthController>(
                        builder: (context, authController, child) {
                          return _FeatureItem(
                            icon: Icons.food_bank_outlined,
                            label: 'restaurants',
                            color: Color(0xFFD2A15B),
                            onTap: () {
                              Navigator.pushNamed(context, '/restaurants');
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Popular Destinations Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Destinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/destinations');
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _DestinationCard(
                        cityName: 'Riyadh',
                        rating: 4.8,
                      ),
                      SizedBox(width: 16),
                      _DestinationCard(
                        cityName: 'Taft',
                        rating: 4.5,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Special Offers Section
                  Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                     // tow colors gradient
                      gradient: LinearGradient(
                        colors: [AppColors.primary,
                          Color(0xFFEDC9AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summer Sale',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Get 25% off on all bookings',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // Handle book now
                          },
                          child: Text('Book Now'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 3) { // Profile tab
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  
  const _FeatureItem({
    required this.icon,
    required this.label, 
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String cityName;
  final double rating;

  const _DestinationCard({
    required this.cityName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
         image: DecorationImage(
            image: AssetImage('assets/images/backImageItem.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                cityName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('$rating',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}