import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/user/home/data/models/home_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData({String? governorate});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<HomeDataModel> getHomeData({String? governorate}) async {
    final queryParams = <String, dynamic>{};
    if (governorate != null && governorate.isNotEmpty) {
      queryParams['governorate'] = governorate;
    }

    final response = await dioClient.dio.get(
      ApiEndpoints.home,
      queryParameters: queryParams,
    );

    final resData = response.data as Map<String, dynamic>;
    final dataMap = (resData['data'] is Map<String, dynamic>)
        ? resData['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return HomeDataModel.fromJson(dataMap);
  }
}
