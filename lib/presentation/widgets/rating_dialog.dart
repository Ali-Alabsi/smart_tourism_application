import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/presentation/controllers/ratings_controller.dart';

class RatingDialog extends StatefulWidget {
  final int typeId;
  final String type; // "restaurant", "hotel", "activities", "flight"
  final String itemName;

  const RatingDialog({
    Key? key,
    required this.typeId,
    required this.type,
    required this.itemName,
  }) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingsController>(
      builder: (context, controller, child) {
        return AlertDialog(
          title: Text('Rate ${widget.itemName}'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Rating',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildStarRating(),
                  SizedBox(height: 24),
                  Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please write a review';
                      }
                      return null;
                    },
                  ),
                  if (controller.errorMessage != null) ...[
                    SizedBox(height: 12),
                    Text(
                      controller.errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: controller.isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedRating == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a rating'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        await controller.submitRating(
                          rate: _selectedRating,
                          typeId: widget.typeId,
                          type: widget.type,
                          review: _reviewController.text.trim(),
                        );

                        if (controller.errorMessage == null) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(controller.successMessage ?? 'Rating submitted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: controller.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starIndex;
            });
          },
          child: Icon(
            starIndex <= _selectedRating ? Icons.star : Icons.star_border,
            color: starIndex <= _selectedRating ? Colors.amber : Colors.grey,
            size: 40,
          ),
        );
      }),
    );
  }
}

