import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import '../models/company_customer_model.dart';

abstract class AdminCustomersRemoteDataSource {
  Future<List<CompanyCustomerModel>> getCompanyCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  });
}

class AdminCustomersRemoteDataSourceImpl
    implements AdminCustomersRemoteDataSource {
  final DioClient _dioClient;

  AdminCustomersRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CompanyCustomerModel>> getCompanyCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dioClient.dio.get(
      ApiEndpoints.adminCompanyCustomers,
      queryParameters: queryParams,
    );

    return _extractCustomersList(response.data);
  }

  List<CompanyCustomerModel> _extractCustomersList(dynamic res) {
    final data = res?['data'];
    final list = (data is Map ? data['customers'] : data) as List? ?? (res is List ? res : []);
    return list
        .map((e) => CompanyCustomerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
