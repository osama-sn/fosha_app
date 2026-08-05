import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/categories/data/models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final DioClient _dioClient;

  CategoriesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.categories);
      final resData = response.data as Map<String, dynamic>;
      final listData = (resData['data'] is List) ? resData['data'] as List : [];
      return listData
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
