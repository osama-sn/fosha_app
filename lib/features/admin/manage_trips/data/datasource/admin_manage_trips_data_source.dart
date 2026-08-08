import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/manage_trips/data/models/trip_request_model.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

abstract class AdminManageTripsDataSource {
  Future<TripModel> createTrip(
    CreateTripRequest tripRequest, {
    XFile? coverImage,
    List<XFile>? galleryImages,
  });
  Future<TripModel> updateTrip(
    String tripId,
    CreateTripRequest tripRequest, {
    XFile? coverImage,
    List<XFile>? galleryImages,
  });
  Future<void> deleteTrip(String tripId);
  Future<TripModel> republishTrip(String tripId);
}

class AdminManageTripsDataSourceImpl implements AdminManageTripsDataSource {
  final DioClient _dioClient;
  AdminManageTripsDataSourceImpl(this._dioClient);

  @override
  Future<TripModel> createTrip(
    CreateTripRequest tripRequest, {
    XFile? coverImage,
    List<XFile>? galleryImages,
  }) async {
    try {
      final formData = await _buildFormData(
        tripRequest,
        coverImage: coverImage,
        galleryImages: galleryImages,
      );
      final response = await _dioClient.dio.post(
        ApiEndpoints.trips,
        data: formData,
      );
      return TripModel.fromJson(_parseTripData(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TripModel> updateTrip(
    String tripId,
    CreateTripRequest tripRequest, {
    XFile? coverImage,
    List<XFile>? galleryImages,
  }) async {
    try {
      final formData = await _buildFormData(
        tripRequest,
        coverImage: coverImage,
        galleryImages: galleryImages,
      );
      final response = await _dioClient.dio.put(
        "${ApiEndpoints.trips}/$tripId",
        data: formData,
      );
      return TripModel.fromJson(_parseTripData(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    try {
      await _dioClient.dio.delete('${ApiEndpoints.trips}/$tripId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TripModel> republishTrip(String tripId) async {
    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.trips}/$tripId/republish',
      );
      return TripModel.fromJson(_parseTripData(response.data));
    } catch (e) {
      rethrow;
    }
  }

  Future<FormData> _buildFormData(
    CreateTripRequest tripRequest, {
    XFile? coverImage,
    List<XFile>? galleryImages,
  }) async {
    final Map<String, dynamic> map = {
      'title': tripRequest.title,
      'description': tripRequest.description,
      'origin': tripRequest.origin,
      'destination': tripRequest.destination,
      'price': tripRequest.price.toString(),
      'capacity': tripRequest.capacity.toString(),
      if (tripRequest.startDate != null)
        'startDate': tripRequest.startDate!.toIso8601String(),
      if (tripRequest.endDate != null)
        'endDate': tripRequest.endDate!.toIso8601String(),
      if (tripRequest.category.isNotEmpty)
        'category': tripRequest.category,
      'status': tripRequest.status,
      if (tripRequest.cancelPolicy.isNotEmpty)
        'cancelPolicy': tripRequest.cancelPolicy,
      'included': jsonEncode(tripRequest.included),
      'excluded': jsonEncode(tripRequest.excluded),
      'days': jsonEncode(tripRequest.days.map((e) => e.toJson()).toList()),
    };

    final formData = FormData.fromMap(map);

    if (coverImage != null) {
      formData.files.add(
        MapEntry(
          'coverImage',
          await MultipartFile.fromFile(
            coverImage.path,
            filename: coverImage.name,
          ),
        ),
      );
    }

    if (galleryImages != null && galleryImages.isNotEmpty) {
      for (var img in galleryImages) {
        formData.files.add(
          MapEntry(
            'gallery',
            await MultipartFile.fromFile(img.path, filename: img.name),
          ),
        );
      }
    }

    return formData;
  }

  Map<String, dynamic> _parseTripData(dynamic data) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) return Map<String, dynamic>.from(inner);
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}

