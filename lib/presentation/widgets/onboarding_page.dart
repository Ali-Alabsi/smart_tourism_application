import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Map<String, dynamic> pageData;

  const OnboardingPage({
    Key? key,
    required this.pageData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Image.asset(
              pageData['image'],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            pageData['title'],
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),

          ),
          const SizedBox(height: 10),
          Text(
            pageData['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}