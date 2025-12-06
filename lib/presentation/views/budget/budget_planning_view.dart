import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/local/shared_prefs.dart';
import '../../controllers/budget_controller.dart';
import '../../../data/models/budgets_responce_model.dart';
import '../../../core/entities/city.dart' as entities;
import '../flight_itinerary/flight_detail_view.dart';
import '../restaurant/restaurant_list_view.dart';
import '../activities/activities_list_view.dart';
import '../hotel/hotel_list_view.dart';

class BudgetPlanningView extends StatefulWidget {
  @override
  _BudgetPlanningViewState createState() => _BudgetPlanningViewState();
}

class _BudgetPlanningViewState extends State<BudgetPlanningView> {
  final _formKey = GlobalKey<FormState>();
  final _travelersController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  int? _selectedCityId;
  int? _selectedFromCityId;
  int? _selectedToCityId;

  bool _showSuggestions = false;
  List<BudgetSuggestion> _suggestions = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadCities();
    _loadBudgets();
  }

  Future<void> _loadUserId() async {
    final sharedPrefs = SharedPrefs();
    final userId = await sharedPrefs.getString('userId');
    setState(() {
      _userId = userId;
    });
  }

  void _loadCities() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final budgetController = Provider.of<BudgetController>(context, listen: false);
      await budgetController.loadCities();
      if (!mounted) return;
      final cities = budgetController.cities;
      if (cities.isNotEmpty) {
        setState(() {
          _selectedCityId ??= cities.first.id;
          _selectedFromCityId ??= cities.first.id;
          _selectedToCityId ??= cities.first.id;
        });
      }
    });
  }

  void _loadBudgets() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final budgetController = Provider.of<BudgetController>(context, listen: false);
      await budgetController.loadBudgets();
      if (!mounted) return;
      if (budgetController.budgetsError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading budgets: ${budgetController.budgetsError}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (budgetController.budgets.isNotEmpty) {
        // Convert API data to suggestions
        setState(() {
          _suggestions = _convertBudgetsToSuggestions(budgetController.budgets.first);
        });
      }
    });
  }

  List<BudgetSuggestion> _convertBudgetsToSuggestions(Datum budget) {
    final suggestions = <BudgetSuggestion>[];
    final totalBudget = double.tryParse(budget.amount) ?? 0.0;

    for (var subcategory in budget.subcategories) {
      final category = _getCategoryFromType(subcategory.type);
      final title = _getTitleFromDescription(subcategory.description);

      final allocatedAmount = totalBudget * (subcategory.percentage / 100);

      suggestions.add(BudgetSuggestion(
        id: subcategory.id,
        category: category,
        title: title,
        isEnabled: true,
        subcategory: subcategory,
        allocatedAmount: allocatedAmount,
        percentage: subcategory.percentage.toDouble(),
      ));
    }

    return suggestions;
  }

  String _getCategoryFromType(Type type) {
    switch (type) {
      case Type.HOTEL:
        return 'Accommodation';
      case Type.RESTAURANT:
        return 'Food';
      case Type.ACTIVITIES:
        return 'Activities';
      case Type.PLANE:
        return 'Transportation';
      case Type.OTHER:
        return 'Other';
    }
  }

  String _getTitleFromDescription(Description description) {
    switch (description) {
      case Description.HOTEL_BUDGET:
        return 'Hotel Recommendations';
      case Description.RESTAURANT_BUDGET:
        return 'Dining Suggestions';
      case Description.ACTIVITIES_BUDGET:
        return 'Attractions & Tours';
      case Description.DESC:
        return 'Other Recommendations';
    }
  }

  @override
  void dispose() {
    _travelersController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planning'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              'Plan Your Trip Budget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            // Input fields section
            _buildInputSection(),
            
            SizedBox(height: 24),
            
            // Map placeholder
            _buildMapSelection(),
            
            SizedBox(height: 24),

            
            SizedBox(height: 24),
            
            // Create Budget Plan Button
            Center(
              child: Consumer<BudgetController>(
                builder: (context, budgetController, child) {
                  final isLoading = budgetController.isLoading;
                  return ElevatedButton(
                    onPressed: (_userId != null && !isLoading) ? _createBudgetPlan : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Create Budget Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 24),
            
            // Suggestions section
            if (_showSuggestions) _buildSuggestionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    final budgetController = Provider.of<BudgetController>(context);
    return Column(
      children: [
        TextField(
          controller: _travelersController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of Travelers',
            hintText: 'Enter number of people',
            prefixIcon: Icon(Icons.people),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Total Trip Budget (\$)',
            hintText: 'Enter your total budget',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        TextField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Trip Duration (days)',
            hintText: 'Enter number of days',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Trip Location',
            hintText: 'Enter destination or select on map',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Plan Name',
            hintText: 'Enter plan name',
            prefixIcon: Icon(Icons.label),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter address',
            prefixIcon: Icon(Icons.home),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildCitySelectors(budgetController),
      ],
    );
  }

  Widget _buildCitySelectors(BudgetController budgetController) {
    if (budgetController.isCitiesLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (budgetController.citiesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budgetController.citiesError!,
            style: TextStyle(color: Colors.red),
          ),
          TextButton(
            onPressed: _loadCities,
            child: Text('Retry'),
          ),
        ],
      );
    }

    if (budgetController.cities.isEmpty) {
      return Text(
        'No cities available. Please try again later.',
        style: TextStyle(color: Colors.grey[700]),
      );
    }

    final dropdownItems = budgetController.cities
        .map<DropdownMenuItem<int>>(
          (entities.City city) => DropdownMenuItem<int>(
            value: city.id,
            child: Text('${city.name}, ${city.country}'),
          ),
        )
        .toList();

    return Column(
      children: [
        DropdownButtonFormField<int>(
          value: _selectedCityId,
          isExpanded: true,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              _selectedCityId = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Destination City',
            prefixIcon: Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: (value) => value == null ? 'Please select a destination city' : null,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _selectedFromCityId,
          isExpanded: true,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              _selectedFromCityId = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'From City',
            prefixIcon: Icon(Icons.flight_takeoff),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: (value) => value == null ? 'Please select the departure city' : null,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _selectedToCityId,
          isExpanded: true,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              _selectedToCityId = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'To City',
            prefixIcon: Icon(Icons.flight_land),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: (value) => value == null ? 'Please select the arrival city' : null,
        ),
      ],
    );
  }

  Future<void> _createBudgetPlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID not found. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final budgetController = Provider.of<BudgetController>(context, listen: false);
    
    // Get percentages from suggestions (from API)
    final percentages = <String, double>{};
    // if (_suggestions.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please load budget data first'),
    //       backgroundColor: Colors.orange,
    //     ),
    //   );
    //   return;
    // }
    
    for (var suggestion in _suggestions) {
      if (suggestion.isEnabled) {
        switch (suggestion.category.toLowerCase()) {
          case 'accommodation':
            percentages['hotels'] = suggestion.percentage / 100;
            break;
          case 'food':
            percentages['food'] = suggestion.percentage / 100;
            break;
          case 'activities':
            percentages['activities'] = suggestion.percentage / 100;
            break;
          case 'transportation':
            percentages['transport'] = suggestion.percentage / 100;
            break;
        }
      }
    }
    //
    // // If no percentages from suggestions, show error
    // if (percentages.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('No budget categories available. Please load budget data first.'),
    //       backgroundColor: Colors.orange,
    //     ),
    //   );
    //   return;
    // }

    await budgetController.planTrip(
      userId: _userId!,
      totalBudget: int.tryParse(_budgetController.text) ?? 0,
      peopleCount: int.tryParse(_travelersController.text) ?? 1,
      days: int.tryParse(_durationController.text) ?? 1,
      destination: _locationController.text.trim(),
      cityId: _selectedCityId ?? (budgetController.cities.isNotEmpty ? budgetController.cities.first.id : 1),
      percentages: percentages,
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      fromCityId: _selectedFromCityId ?? (budgetController.cities.isNotEmpty ? budgetController.cities.first.id : 1),
      toCityId: _selectedToCityId ?? (budgetController.cities.isNotEmpty ? budgetController.cities.first.id : 1),
    );

    if (budgetController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(budgetController.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (budgetController.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(budgetController.successMessage!),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back or clear form
      Navigator.of(context).pop();
    }
  }

  Widget _buildMapSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Location on Map',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 50,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 10),
                Text(
                  'Interactive Map Placeholder',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Click to select destination',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Adjust allocations and toggle suggestions:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 16),
        ..._suggestions.map((suggestion) {
          return _SuggestionCard(
            suggestion: suggestion,
            onChanged: (updatedSuggestion) {
              setState(() {
                final index = _suggestions.indexWhere((s) => s.id == updatedSuggestion.id);
                if (index != -1) {
                  _suggestions[index] = updatedSuggestion;
                }
              });
            },
          );
        }).toList(),
        
        SizedBox(height: 24),
        
        // Category allocation sliders
        Text(
          'Manual Allocation Adjustment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ..._suggestions.map((suggestion) {
          return _CategorySlider(
            category: suggestion.category,
            percentage: suggestion.percentage,
            amount: suggestion.allocatedAmount,
            totalBudget: double.tryParse(_budgetController.text) ?? 0,
            onChanged: (newPercentage) {
              setState(() {
                final index = _suggestions.indexWhere((s) => s.id == suggestion.id);
                if (index != -1) {
                  final totalBudget = double.tryParse(_budgetController.text) ?? 0;
                  _suggestions[index] = suggestion.copyWith(
                    percentage: newPercentage,
                    allocatedAmount: (totalBudget * newPercentage / 100).roundToDouble(),
                  );
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }
}

class BudgetSuggestion {
  final int id;
  final String category;
  final String title;
  final bool isEnabled;
  final Subcategory subcategory;
  final double allocatedAmount;
  final double percentage;

  BudgetSuggestion({
    required this.id,
    required this.category,
    required this.title,
    required this.isEnabled,
    required this.subcategory,
    required this.allocatedAmount,
    required this.percentage,
  });

  BudgetSuggestion copyWith({
    int? id,
    String? category,
    String? title,
    bool? isEnabled,
    Subcategory? subcategory,
    double? allocatedAmount,
    double? percentage,
  }) {
    return BudgetSuggestion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      isEnabled: isEnabled ?? this.isEnabled,
      subcategory: subcategory ?? this.subcategory,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      percentage: percentage ?? this.percentage,
    );
  }
}

class _SuggestionCard extends StatefulWidget {
  final BudgetSuggestion suggestion;
  final Function(BudgetSuggestion) onChanged;

  const _SuggestionCard({
    required this.suggestion,
    required this.onChanged,
  });

  @override
  __SuggestionCardState createState() => __SuggestionCardState();
}

class __SuggestionCardState extends State<_SuggestionCard> {
  late bool _isEnabled;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.suggestion.isEnabled;
  }

  void _navigateToDetail(BuildContext context, Type type, int itemId) {
    switch (type) {
      case Type.PLANE:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailView(flightId: itemId),
          ),
        );
        break;
      case Type.RESTAURANT:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailView(restaurantId: itemId),
          ),
        );
        break;
      case Type.ACTIVITIES:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailView(activityId: itemId),
          ),
        );
        break;
      case Type.OTHER:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detail page not available for this item'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case Type.HOTEL:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailView(hotelId: itemId),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              widget.suggestion.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${widget.suggestion.category} - \$${widget.suggestion.allocatedAmount.toStringAsFixed(0)} (${widget.suggestion.percentage.toStringAsFixed(0)}%)',
            ),
            trailing: Switch(
              value: _isEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                  widget.onChanged(widget.suggestion.copyWith(isEnabled: value));
                });
              },
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display subcategory details from API
                  if (widget.suggestion.subcategory.name != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Name: ${widget.suggestion.subcategory.name}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.suggestion.subcategory.descriptionText.isNotEmpty 
                              ? widget.suggestion.subcategory.descriptionText 
                              : 'No description available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          'Percentage: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${widget.suggestion.subcategory.percentage}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.suggestion.subcategory.allocatedAmount != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Allocated Amount: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${widget.suggestion.subcategory.allocatedAmount}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.suggestion.subcategory.spentAmount.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Spent Amount: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${widget.suggestion.subcategory.spentAmount}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Suggested Items:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (widget.suggestion.subcategory.items.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No items available - This item is currently unavailable',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...widget.suggestion.subcategory.items.map((item) => InkWell(
                      onTap: () => _navigateToDetail(context, widget.suggestion.subcategory.type, item.typeId),
                      child: Card(
                        margin: EdgeInsets.only(bottom: 8),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: ${item.id}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Amount: \$${item.amount}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    if (item.types != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Type: ${item.types.toString().split('.').last}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    if (item.purchasedAt != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Purchased At: ${item.purchasedAt}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategorySlider extends StatefulWidget {
  final String category;
  final double percentage;
  final double amount;
  final double totalBudget;
  final Function(double) onChanged;

  const _CategorySlider({
    required this.category,
    required this.percentage,
    required this.amount,
    required this.totalBudget,
    required this.onChanged,
  });

  @override
  __CategorySliderState createState() => __CategorySliderState();
}

class __CategorySliderState extends State<_CategorySlider> {
  late double _percentage;

  @override
  void initState() {
    super.initState();
    _percentage = widget.percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.category,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_percentage.toStringAsFixed(0)}% (\$${(widget.totalBudget * _percentage / 100).toStringAsFixed(0)})',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: _percentage,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_percentage.round()}%',
            onChanged: (value) {
              setState(() {
                _percentage = value;
                widget.onChanged(value);
              });
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}