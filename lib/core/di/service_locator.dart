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
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_payment_accounts_cubit.dart';

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

import 'package:fosha_app/features/admin/passengers/data/datasources/admin_passengers_remote_data_source.dart';
import 'package:fosha_app/features/admin/passengers/data/repositories/admin_passengers_repository.dart';
import 'package:fosha_app/features/admin/passengers/presentation/cubit/admin_passengers_cubit.dart';

import 'package:fosha_app/features/admin/expenses/data/datasources/admin_expenses_remote_data_source.dart';
import 'package:fosha_app/features/admin/expenses/data/repositories/admin_expenses_repository.dart';
import 'package:fosha_app/features/admin/expenses/presentation/cubit/admin_expenses_cubit.dart';

import 'package:fosha_app/features/admin/financial_report/data/datasources/admin_financial_report_remote_data_source.dart';
import 'package:fosha_app/features/admin/financial_report/data/repositories/admin_financial_report_repository.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/cubit/admin_financial_report_cubit.dart';

import 'package:fosha_app/features/admin/reviews/data/datasources/admin_reviews_remote_data_source.dart';
import 'package:fosha_app/features/admin/reviews/data/repositories/admin_reviews_repository.dart';
import 'package:fosha_app/features/admin/reviews/presentation/cubit/admin_reviews_cubit.dart';

import 'package:fosha_app/features/admin/customers/data/datasources/admin_customers_remote_data_source.dart';
import 'package:fosha_app/features/admin/customers/data/repositories/admin_customers_repository.dart';
import 'package:fosha_app/features/admin/customers/presentation/cubit/admin_customers_cubit.dart';

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
  getIt.registerLazySingleton<AdminPassengersRemoteDataSource>(
    () => AdminPassengersRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminExpensesRemoteDataSource>(
    () => AdminExpensesRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminFinancialReportRemoteDataSource>(
    () => AdminFinancialReportRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminReviewsRemoteDataSource>(
    () => AdminReviewsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdminCustomersRemoteDataSource>(
    () => AdminCustomersRemoteDataSourceImpl(getIt()),
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
  getIt.registerLazySingleton<AdminPassengersRepository>(
    () => AdminPassengersRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminExpensesRepository>(
    () => AdminExpensesRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminFinancialReportRepository>(
    () => AdminFinancialReportRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminReviewsRepository>(
    () => AdminReviewsRepository(getIt()),
  );
  getIt.registerLazySingleton<AdminCustomersRepository>(
    () => AdminCustomersRepository(getIt()),
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
    () => AdminBookingsCubit(
      repository: getIt(),
      chatRepository: getIt(),
      statsRepository: getIt(),
    ),
  );
  getIt.registerFactory<CompanyProfileCubit>(
    () => CompanyProfileCubit(repository: getIt()),
  );
  getIt.registerFactory<CompanyPaymentAccountsCubit>(
    () => CompanyPaymentAccountsCubit(repository: getIt()),
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
  getIt.registerFactory<AdminPassengersCubit>(
    () => AdminPassengersCubit(getIt()),
  );
  getIt.registerFactory<AdminExpensesCubit>(
    () => AdminExpensesCubit(getIt()),
  );
  getIt.registerFactory<AdminFinancialReportCubit>(
    () => AdminFinancialReportCubit(getIt()),
  );
  getIt.registerFactory<AdminReviewsCubit>(
    () => AdminReviewsCubit(getIt()),
  );
  getIt.registerFactory<AdminCustomersCubit>(
    () => AdminCustomersCubit(getIt()),
  );
}
