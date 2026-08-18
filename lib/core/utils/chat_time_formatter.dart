class ChatTimeFormatter {
  ChatTimeFormatter._();

  /// Format time as WhatsApp style: e.g. "10:45 م" or "02:15 ص"
  static String formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final period = localTime.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  /// Format date header for chat list dividers (Today, Yesterday, or full date)
  static String formatDateHeader(DateTime dateTime) {
    final localDate = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(localDate.year, localDate.month, localDate.day);

    if (msgDate == today) {
      return 'اليوم';
    } else if (msgDate == yesterday) {
      return 'الأمس';
    } else {
      const months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${localDate.day} ${months[localDate.month - 1]} ${localDate.year}';
    }
  }

  /// Check if two dates are on the same calendar day
  static bool isSameDay(DateTime date1, DateTime date2) {
    final d1 = date1.toLocal();
    final d2 = date2.toLocal();
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
