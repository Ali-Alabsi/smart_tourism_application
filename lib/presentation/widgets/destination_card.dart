import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/presentation/views/destinations/destination_detail_view.dart';

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double rating;
  final double price;
  final VoidCallback onTap;

  const DestinationCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to destination detail view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DestinationDetailView(
                destination: Destination(
                  id: '1',
                  name: title,
                  description: 'Beautiful destination with amazing experiences.',
                  imageUrl: imageUrl,
                  rating: rating,
                  location: location,
                  price: price,
                  features: ['Beach', 'Culture', 'Adventure'],
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('$rating'),
                        ],
                      ),
                      Text(
                        '\$$price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}