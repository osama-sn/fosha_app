import 'package:dio/dio.dart';
import 'package:fosha_app/features/admin/company_profile/data/datasources/company_profile_remote_data_source.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

class CompanyProfileRepository {
  final CompanyProfileRemoteDataSource dataSource;

  CompanyProfileRepository({required this.dataSource});

  Future<CompanyProfileModel> getCompanyProfile(String companyId) async {
    try {
      return await dataSource.getCompanyProfile(companyId);
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في جلب بيانات الشركة';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<CompanyProfileModel> updateCompanyProfile(
    String companyId,
    CompanyProfileModel profile,
  ) async {
    try {
      return await dataSource.updateCompanyProfile(
        companyId,
        profile.toUpdateJson(),
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في تحديث بيانات الشركة';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
