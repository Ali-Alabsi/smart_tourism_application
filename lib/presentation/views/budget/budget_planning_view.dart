import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BudgetPlanningView extends StatefulWidget {
  @override
  _BudgetPlanningViewState createState() => _BudgetPlanningViewState();
}

class _BudgetPlanningViewState extends State<BudgetPlanningView> {
  final _travelersController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();

  bool _showSuggestions = false;
  List<BudgetSuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    // Mock data for suggestions
    _suggestions = [
      BudgetSuggestion(
        id: 1,
        category: 'Accommodation',
        title: 'Hotel Recommendations',
        isEnabled: true,
        items: [
          'Grand Plaza Hotel - \$120/night',
          'Seaside Resort - \$150/night',
          'City Center Inn - \$80/night'
        ],
        allocatedAmount: 600,
        percentage: 40,
      ),
      BudgetSuggestion(
        id: 2,
        category: 'Transportation',
        title: 'Travel Options',
        isEnabled: true,
        items: [
          'Airport Transfer - \$25',
          'Daily Car Rental - \$45/day',
          'Public Transit Pass - \$10/day'
        ],
        allocatedAmount: 150,
        percentage: 10,
      ),
      BudgetSuggestion(
        id: 3,
        category: 'Food',
        title: 'Dining Suggestions',
        isEnabled: true,
        items: [
          'Local Restaurant - \$15/meal',
          'Fine Dining Experience - \$50/meal',
          'Street Food Tour - \$10/person'
        ],
        allocatedAmount: 200,
        percentage: 15,
      ),
      BudgetSuggestion(
        id: 4,
        category: 'Activities',
        title: 'Attractions & Tours',
        isEnabled: true,
        items: [
          'City Walking Tour - \$20/person',
          'Museum Entry - \$15/person',
          'Adventure Park - \$40/person'
        ],
        allocatedAmount: 250,
        percentage: 20,
      ),
    ];
  }

  @override
  void dispose() {
    _travelersController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _locationController.dispose();
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
            
            // AI Process Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showSuggestions = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Generate AI Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Suggestions section
            if (_showSuggestions) _buildSuggestionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
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
      ],
    );
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
            totalBudget: double.tryParse(_budgetController.text) ?? 1000,
            onChanged: (newPercentage) {
              setState(() {
                final index = _suggestions.indexWhere((s) => s.id == suggestion.id);
                if (index != -1) {
                  final totalBudget = double.tryParse(_budgetController.text) ?? 1000;
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
  final List<String> items;
  final double allocatedAmount;
  final double percentage;

  BudgetSuggestion({
    required this.id,
    required this.category,
    required this.title,
    required this.isEnabled,
    required this.items,
    required this.allocatedAmount,
    required this.percentage,
  });

  BudgetSuggestion copyWith({
    int? id,
    String? category,
    String? title,
    bool? isEnabled,
    List<String>? items,
    double? allocatedAmount,
    double? percentage,
  }) {
    return BudgetSuggestion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      isEnabled: isEnabled ?? this.isEnabled,
      items: items ?? this.items,
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
                  Text(
                    'Suggested Items:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...widget.suggestion.items.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
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