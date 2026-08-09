import 'package:fosha_app/features/admin/trips/data/models/paginated_trips_model.dart';
import 'package:fosha_app/features/user/search/data/datasources/search_remote_data_source.dart';

class SearchRepository {
  final SearchRemoteDataSource dataSource;

  SearchRepository({required this.dataSource});

  Future<PaginatedTripsModel> searchTrips({
    int page = 1,
    int limit = 10,
    String? search,
    String? origin,
    String? destination,
    String? category,
    String? governorate,
    String? companyId,
    bool myGovernorateOnly = false,
  }) async {
    return await dataSource.searchTrips(
      page: page,
      limit: limit,
      search: search,
      origin: origin,
      destination: destination,
      category: category,
      governorate: governorate,
      companyId: companyId,
      myGovernorateOnly: myGovernorateOnly,
    );
  }
}
