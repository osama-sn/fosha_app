import 'package:get_it/get_it.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/bookings/data/datasources/admin_bookings_data_source.dart';
import 'package:fosha_app/features/admin/bookings/data/repositories/admin_bookings_repository.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_cubit.dart';
import 'package:fosha_app/features/admin/dashboard/data/datasourece/admin_dashboard_remote_data_source.dart';
import 'package:fosha_app/features/admin/dashboard/data/repositories/admin_dashboard_stats_repository.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/cubit/admin_cubit.dart';
import 'package:fosha_app/features/admin/manage_trips/data/datasource/admin_manage_trips_data_source.dart';
import 'package:fosha_app/features/admin/manage_trips/data/repositories/admin_manage_trips_repository.dart';
import 'package:fosha_app/features/admin/manage_trips/presentation/cubit/admin_manage_trips_cubit.dart';
import 'package:fosha_app/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:fosha_app/features/categories/data/repositories/categories_repository.dart';
import 'package:fosha_app/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:fosha_app/features/user/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fosha_app/features/user/auth/data/repositories/auth_repository.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/admin/trips/data/repositories/admin_trips_repository.dart';
import 'package:fosha_app/features/admin/trips/presentation/cubit/admin_trips_cubit.dart';
import 'package:fosha_app/features/admin/trips/data/datasource/admin_trips_remote_data_source.dart';

import 'package:fosha_app/features/admin/company_profile/data/datasources/company_profile_remote_data_source.dart';
import 'package:fosha_app/features/admin/company_profile/data/repositories/company_profile_repository.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_cubit.dart';

import 'package:fosha_app/features/admin/offers/data/datasources/offers_remote_data_source.dart';
import 'package:fosha_app/features/admin/offers/data/repositories/offers_repository.dart';
import 'package:fosha_app/features/admin/offers/presentation/cubit/offers_cubit.dart';

import 'package:fosha_app/features/admin/coupons/data/datasources/coupons_remote_data_source.dart';
import 'package:fosha_app/features/admin/coupons/data/repositories/coupons_repository.dart';
import 'package:fosha_app/features/admin/coupons/presentation/cubit/coupons_cubit.dart';

import 'package:fosha_app/features/user/home/data/datasources/home_remote_data_source.dart';
import 'package:fosha_app/features/user/home/data/repositories/home_repository.dart';
import 'package:fosha_app/features/user/home/presentation/cubit/home_cubit.dart';

import 'package:fosha_app/features/user/search/data/datasources/search_remote_data_source.dart';
import 'package:fosha_app/features/user/search/data/repositories/search_repository.dart';
import 'package:fosha_app/features/user/search/presentation/cubit/search_cubit.dart';

import 'package:fosha_app/features/user/bookings/data/datasources/user_bookings_remote_data_source.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_cubit.dart';

import 'package:fosha_app/features/user/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:fosha_app/features/user/favorites/data/repositories/favorites_repository.dart';
import 'package:fosha_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';

import 'package:fosha_app/features/user/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fosha_app/features/user/profile/data/repositories/profile_repository.dart';
import 'package:fosha_app/features/user/profile/presentation/cubit/profile_cubit.dart';

import 'package:fosha_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:fosha_app/features/chat/data/repositories/chat_repository.dart';
import 'package:fosha_app/features/chat/presentation/cubit/chat_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<AdminTripsRemoteDataSource>(
    () => AdminTripsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminManageTripsDataSource>(
    () => AdminManageTripsDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminBookingsDataSource>(
    () => AdminBookingsDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CompanyProfileRemoteDataSource>(
    () => CompanyProfileRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<OffersRemoteDataSource>(
    () => OffersRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<CouponsRemoteDataSource>(
    () => CouponsRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<UserBookingsRemoteDataSource>(
    () => UserBookingsRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: getIt()),
  );

  // repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authRemoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<AdminDashboardStatsRepository>(
    () => AdminDashboardStatsRepository(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<AdminTripsRepository>(
    () => AdminTripsRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminManageTripsRepository>(
    () => AdminManageTripsRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminBookingsRepository>(
    () => AdminBookingsRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<CompanyProfileRepository>(
    () => CompanyProfileRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<OffersRepository>(
    () => OffersRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<CouponsRepository>(
    () => CouponsRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<UserBookingsRepository>(
    () => UserBookingsRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepository(dataSource: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(dataSource: getIt()),
  );

  // cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));
  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(adminDashboardStatsRepository: getIt()),
  );
  getIt.registerFactory<AdminTripsCubit>(() => AdminTripsCubit(getIt()));
  getIt.registerFactory<CategoriesCubit>(() => CategoriesCubit(getIt()));
  getIt.registerFactory<AdminManageTripsCubit>(
    () => AdminManageTripsCubit(getIt()),
  );
  getIt.registerFactory<AdminBookingsCubit>(
    () => AdminBookingsCubit(repository: getIt()),
  );
  getIt.registerFactory<CompanyProfileCubit>(
    () => CompanyProfileCubit(repository: getIt()),
  );
  getIt.registerFactory<OffersCubit>(
    () => OffersCubit(repository: getIt()),
  );
  getIt.registerFactory<CouponsCubit>(
    () => CouponsCubit(repository: getIt()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(repository: getIt()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(repository: getIt()),
  );
  getIt.registerFactory<CreateBookingCubit>(
    () => CreateBookingCubit(repository: getIt()),
  );
  getIt.registerFactory<UserBookingsCubit>(
    () => UserBookingsCubit(repository: getIt()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(repository: getIt()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(repository: getIt()),
  );
  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(repository: getIt()),
  );
}
