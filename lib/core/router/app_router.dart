import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/pages/admin_booking_details_page.dart';
import 'package:fosha_app/features/admin/bookings/presentation/pages/admin_bookings_page.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:fosha_app/features/admin/manage_trips/presentation/pages/manage_trips_page.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/admin/trips/presentation/pages/admin_trips_page.dart';
import 'package:fosha_app/features/user/auth/presentation/pages/login_page.dart';
import 'package:fosha_app/features/user/auth/presentation/pages/register_page.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/booking_confirmation_page.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/booking_details_page.dart';
import 'package:fosha_app/features/user/home/presentation/pages/home_page.dart';
import 'package:fosha_app/features/user/home/presentation/pages/trip_details_page.dart';
import 'package:fosha_app/features/user/not_found/presentation/pages/not_found_page.dart';
import 'package:fosha_app/features/user/profile/presentation/pages/profile_tab.dart';
import 'package:fosha_app/features/user/settings/presentation/pages/settings_page.dart';
import 'package:fosha_app/features/user/splash/presentation/pages/splash_page.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/pages/company_profile_page.dart';
import 'package:fosha_app/features/admin/offers/presentation/pages/company_offers_page.dart';
import 'package:fosha_app/features/admin/coupons/presentation/pages/company_coupons_page.dart';
import 'package:fosha_app/features/user/search/presentation/pages/search_page.dart';
import 'package:fosha_app/features/user/company/presentation/pages/company_details_page.dart';
import 'package:fosha_app/features/user/home/presentation/pages/category_trips_page.dart';
import 'package:fosha_app/features/categories/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/features/admin/passengers/presentation/pages/admin_passengers_page.dart';
import 'package:fosha_app/features/admin/passengers/presentation/cubit/admin_passengers_cubit.dart';
import 'package:fosha_app/features/admin/expenses/presentation/pages/admin_expenses_page.dart';
import 'package:fosha_app/features/admin/expenses/presentation/cubit/admin_expenses_cubit.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/pages/admin_financial_report_page.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/cubit/admin_financial_report_cubit.dart';
import 'package:fosha_app/features/admin/chat/presentation/pages/admin_chats_page.dart';
import 'package:fosha_app/features/admin/reviews/presentation/pages/admin_reviews_page.dart';
import 'package:fosha_app/features/admin/reviews/presentation/cubit/admin_reviews_cubit.dart';
import 'package:fosha_app/features/admin/customers/presentation/pages/admin_customers_page.dart';
import 'package:fosha_app/features/admin/customers/presentation/cubit/admin_customers_cubit.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.tripDetails,
        name: RouteNames.tripDetails,
        builder: (context, state) => const TripDetailsPage(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        name: RouteNames.bookingConfirmation,
        builder: (context, state) {
          final trip = state.extra as TripModel?;
          return BookingConfirmationPage(trip: trip);
        },
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        name: RouteNames.bookingDetails,
        builder: (context, state) => const BookingDetailsPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileTab(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.adminTrips,
        builder: (context, state) => const AdminTripsView(),
      ),
      GoRoute(
        path: RouteNames.adminBookings,
        builder: (context, state) {
          final tripTitle = state.extra as String?;
          return AdminBookingsPage(initialTripFilter: tripTitle);
        },
      ),
      GoRoute(
        path: RouteNames.addTrip,
        builder: (context, state) {
          final trip = state.extra as TripModel?;
          return AddTripPage(tripToEdit: trip);
        },
      ),
      GoRoute(
        path: RouteNames.adminBookingDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is BookingModel) {
            return AdminBookingDetailsPage(booking: extra);
          } else if (extra is Map<String, dynamic>) {
            return AdminBookingDetailsPage(bookingData: extra);
          }
          return const AdminBookingDetailsPage();
        },
      ),
      GoRoute(
        path: RouteNames.companyProfile,
        builder: (context, state) {
          final companyId = state.extra as String?;
          return CompanyProfilePage(companyId: companyId);
        },
      ),
      GoRoute(
        path: RouteNames.companyOffers,
        builder: (context, state) => const CompanyOffersPage(),
      ),
      GoRoute(
        path: RouteNames.companyCoupons,
        builder: (context, state) => const CompanyCouponsPage(),
      ),
      GoRoute(
        path: RouteNames.adminPassengers,
        builder: (context, state) {
          final tripId = state.extra as String?;
          return BlocProvider<AdminPassengersCubit>(
            create: (context) => getIt<AdminPassengersCubit>(),
            child: AdminPassengersPage(initialTripId: tripId),
          );
        },
      ),
      GoRoute(
        path: RouteNames.adminExpenses,
        builder: (context, state) => BlocProvider<AdminExpensesCubit>(
          create: (context) => getIt<AdminExpensesCubit>(),
          child: const AdminExpensesPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.adminFinancialReport,
        builder: (context, state) => BlocProvider<AdminFinancialReportCubit>(
          create: (context) => getIt<AdminFinancialReportCubit>(),
          child: const AdminFinancialReportPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.adminChats,
        builder: (context, state) => const AdminChatsPage(),
      ),
      GoRoute(
        path: RouteNames.adminReviews,
        builder: (context, state) {
          final companyId = state.extra as String?;
          return BlocProvider<AdminReviewsCubit>(
            create: (context) => getIt<AdminReviewsCubit>(),
            child: AdminReviewsPage(companyId: companyId),
          );
        },
      ),
      GoRoute(
        path: RouteNames.adminCustomers,
        builder: (context, state) => BlocProvider<AdminCustomersCubit>(
          create: (context) => getIt<AdminCustomersCubit>(),
          child: const AdminCustomersPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) {
          final query = state.extra as String?;
          return SearchPage(initialQuery: query);
        },
      ),
      GoRoute(
        path: RouteNames.companyDetails,
        builder: (context, state) {
          final companyId = state.extra as String?;
          return CompanyDetailsPage(companyId: companyId);
        },
      ),
      GoRoute(
        path: RouteNames.categoryTrips,
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return CategoryTripsPage(category: category);
        },
      ),
    ],
  );
}
