import 'package:flutter/material.dart';

class AdminExpensesConstants {
  AdminExpensesConstants._();

  static const String categoryAll = 'all';
  static const String categoryHotel = 'hotel';
  static const String categoryTransportation = 'transportation';
  static const String categoryFood = 'food';
  static const String categoryActivities = 'activities';
  static const String categoryStaff = 'staff';
  static const String categoryOther = 'other';

  static const Map<String, String> categoriesMap = {
    categoryAll: 'الكل',
    categoryHotel: 'فنادق وإقامة',
    categoryTransportation: 'انتقالات وأتوبيسات',
    categoryFood: 'وجبات ومشروبات',
    categoryActivities: 'أنشطة وتذاكر',
    categoryStaff: 'أجور ورواتب',
    categoryOther: 'مصروفات أخرى',
  };

  static const List<String> addableCategories = [
    categoryHotel,
    categoryTransportation,
    categoryFood,
    categoryActivities,
    categoryStaff,
    categoryOther,
  ];

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case categoryHotel:
        return Icons.hotel;
      case categoryTransportation:
        return Icons.directions_bus;
      case categoryFood:
        return Icons.restaurant;
      case categoryActivities:
        return Icons.local_activity;
      case categoryStaff:
        return Icons.people;
      default:
        return Icons.receipt_long;
    }
  }
}
