import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/presentation/controllers/onboarding_controller.dart';
import 'package:smart_tourism_application/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      child: const OnboardingScreenContent(),
    );
  }
}

class OnboardingScreenContent extends StatefulWidget {
  const OnboardingScreenContent({super.key});

  @override
  State<OnboardingScreenContent> createState() => _OnboardingScreenContentState();
}

class _OnboardingScreenContentState extends State<OnboardingScreenContent> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<OnboardingController>(
          builder: (context, controller, child) {
            return Stack(
              children: [
                // Background gradient
                Container(
                  decoration: const BoxDecoration(

                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      // Skip button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: () {
                              // Navigate to login screen
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Page content
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: controller.onboardingPages.length,
                          itemBuilder: (context, index) {
                            return OnboardingPage(
                              pageData: controller.onboardingPages[index],
                            );
                          },
                          onPageChanged: (index) {
                            controller.updatePage(index);
                          },
                        ),
                      ),
                      // Navigation
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Previous button
                            if (!controller.isFirstPage)
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              )
                            else
                              const SizedBox(width: 48), // Space for alignment
                            // Page indicators
                            Row(
                              children: List.generate(controller.onboardingPages.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.currentPage == index
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                );
                              }),
                            ),
                            // Next button
                            if (!controller.isLastPage)
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  // Navigate to login screen
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}