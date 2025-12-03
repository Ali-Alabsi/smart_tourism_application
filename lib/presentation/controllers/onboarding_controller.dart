import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Explore the \nworld easily',
      'description': 'To your destination'
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Reach the \nunknown spot',
      'description': 'To your dream trip'
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Make connects \nwith Kingdom',
      'description': 'To your dream trip'
    }
  ];

  List<Map<String, dynamic>> get onboardingPages => _onboardingPages;

  void nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void updatePage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  bool get isLastPage => _currentPage == _onboardingPages.length - 1;
  bool get isFirstPage => _currentPage == 0;
}