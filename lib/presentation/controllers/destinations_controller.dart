import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';

class DestinationsController with ChangeNotifier {
  // Sample destinations data
  final List<Destination> _destinations = [
    Destination(
      id: '1',
      name: 'Riyadh',
      description: 'The capital and largest city of Saudi Arabia, known for its modern architecture and rich history.',
      imageUrl: 'assets/images/riyadh.jpg',
      rating: 4.8,
      location: 'Saudi Arabia',
      price: 120.0,
      features: ['Museums', 'Shopping', 'Cultural Sites'],
    ),
    Destination(
      id: '2',
      name: 'Jeddah',
      description: 'A coastal city in western Saudi Arabia and the major port of the country.',
      imageUrl: 'assets/images/jeddah.jpg',
      rating: 4.6,
      location: 'Saudi Arabia',
      price: 100.0,
      features: ['Beaches', 'Historic Sites', 'Cuisine'],
    ),
    Destination(
      id: '3',
      name: 'Medina',
      description: 'The second holiest city in Islam, home to the Prophet\'s Mosque.',
      imageUrl: 'assets/images/medina.jpg',
      rating: 4.9,
      location: 'Saudi Arabia',
      price: 90.0,
      features: ['Religious Sites', 'History', 'Culture'],
    ),
    Destination(
      id: '4',
      name: 'NEOM',
      description: 'A planned cross-border city in the Tabuk Province of northwestern Saudi Arabia.',
      imageUrl: 'assets/images/neom.jpg',
      rating: 4.9,
      location: 'Saudi Arabia',
      price: 200.0,
      features: ['Futuristic', 'Technology', 'Nature'],
    ),
    Destination(
      id: '5',
      name: 'AlUla',
      description: 'An ancient city with thousands of years of history, known for its archaeological sites.',
      imageUrl: 'assets/images/alula.jpg',
      rating: 4.7,
      location: 'Saudi Arabia',
      price: 150.0,
      features: ['Archaeology', 'History', 'Landscapes'],
    ),
    Destination(
      id: '6',
      name: 'Abha',
      description: 'Mountain city known for its cool climate and natural beauty.',
      imageUrl: 'assets/images/abha.jpg',
      rating: 4.5,
      location: 'Saudi Arabia',
      price: 80.0,
      features: ['Mountains', 'Cool Climate', 'Nature'],
    ),
  ];

  List<Destination> get destinations => _destinations;

  // Get featured destinations
  List<Destination> get featuredDestinations {
    return _destinations.where((destination) => destination.rating >= 4.7).toList();
  }

  // Get popular destinations
  List<Destination> get popularDestinations {
    return _destinations.take(3).toList();
  }

  // Search destinations by name
  List<Destination> searchDestinations(String query) {
    if (query.isEmpty) return _destinations;
    
    return _destinations.where((destination) {
      return destination.name.toLowerCase().contains(query.toLowerCase()) ||
          destination.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get destination by ID
  Destination? getDestinationById(String id) {
    try {
      return _destinations.firstWhere((destination) => destination.id == id);
    } catch (e) {
      return null;
    }
  }
}