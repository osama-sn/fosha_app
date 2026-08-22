import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/user/home/data/datasources/home_remote_data_source.dart';
import 'package:fosha_app/features/user/home/data/models/home_data_model.dart';

class HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepository({required this.dataSource});

  Future<Either<Failure, HomeDataModel>> getHomeData(
      {String? governorate}) async {
    try {
      final homeData = await dataSource.getHomeData(governorate: governorate);
      return Right(homeData);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
