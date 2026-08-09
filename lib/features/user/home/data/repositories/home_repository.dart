import 'package:fosha_app/features/user/home/data/datasources/home_remote_data_source.dart';
import 'package:fosha_app/features/user/home/data/models/home_data_model.dart';

class HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepository({required this.dataSource});

  Future<HomeDataModel> getHomeData({String? governorate}) async {
    return await dataSource.getHomeData(governorate: governorate);
  }
}
