import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:dio/dio.dart';

class RatingsApi {
  final DioClient _dioClient;

  RatingsApi(this._dioClient);

  Future<void> submitRating({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  }) async {
    try {
      final response = await _dioClient.post(
        '/api/ratings',
        data: {
          'rate': rate,
          'type_id': typeId,
          'type': type,
          'review': review,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Rating submitted successfully');
      } else {
        throw Exception('Failed to submit rating: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to submit rating: ${e.response?.data}');
      } else {
        throw Exception('Failed to submit rating: ${e.message}');
      }
    }
  }
}

