import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/user/search/data/repositories/search_repository.dart';
import 'package:fosha_app/features/user/search/presentation/cubit/search_state.dart';
export 'package:fosha_app/features/user/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  SearchCubit({required this.repository}) : super(const SearchInitial());

  String? selectedGovernorate;
  String? selectedDestination;
  String? selectedCategory;
  String? selectedCompanyId;
  String? searchQuery;

  List<CompanyProfileModel> availableCompanies = [];

  void setGovernorate(String? gov) {
    selectedGovernorate = gov;
    performSearch();
  }

  void setDestination(String? dest) {
    selectedDestination = dest;
    performSearch();
  }

  void setCategory(String? cat) {
    selectedCategory = cat;
    performSearch();
  }

  void setCompany(String? companyId) {
    selectedCompanyId = companyId;
    performSearch();
  }

  void setSearchQuery(String? query) {
    searchQuery = query;
  }

  void clearFilters() {
    selectedGovernorate = null;
    selectedDestination = null;
    selectedCategory = null;
    selectedCompanyId = null;
    searchQuery = null;
    performSearch();
  }

  Future<void> fetchCompanies() async {
    try {
      final dioClient = getIt<DioClient>();
      final response = await dioClient.dio.get(ApiEndpoints.companies);
      final resData = response.data as Map<String, dynamic>;
      final dataMap = resData['data'];

      List companiesList;
      if (dataMap is Map<String, dynamic> && dataMap.containsKey('companies')) {
        companiesList = dataMap['companies'] as List? ?? [];
      } else if (dataMap is List) {
        companiesList = dataMap;
      } else {
        companiesList = [];
      }

      availableCompanies = companiesList
          .map((item) => CompanyProfileModel.fromJson(
              item is Map<String, dynamic>
                  ? item
                  : Map<String, dynamic>.from(item as Map)))
          .toList();
    } on DioException catch (_) {
      availableCompanies = [];
    } catch (_) {
      availableCompanies = [];
    }
  }

  Future<void> performSearch({int page = 1}) async {
    emit(const SearchLoading());
    final result = await repository.searchTrips(
      page: page,
      limit: 10,
      search: searchQuery,
      origin: selectedGovernorate,
      destination: selectedDestination,
      category: selectedCategory,
      governorate: selectedGovernorate,
      companyId: selectedCompanyId,
      myGovernorateOnly: false,
    );

    result.fold(
      (failure) => emit(SearchFailure(error: failure.message)),
      (res) => emit(
        SearchSuccess(
          trips: res.trips,
          totalItems: res.totalItems,
          totalPages: res.totalPages,
          currentPage: res.currentPage,
        ),
      ),
    );
  }
}
