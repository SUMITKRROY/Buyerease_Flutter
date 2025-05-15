import 'package:intl/intl.dart';
import 'package:buyerease/utils/fsl_log.dart';

class DateUtils {
    static const String _hourFormat = 'HH:mm';
    static const String _tag = 'DateUtils';

    // Private constructor to prevent instantiation
    DateUtils._();

    // Get current hour in HH:mm format
    static String getCurrentHour() {
        final now = DateTime.now();
        final formatter = DateFormat(_hourFormat, 'en_US');
        final hour = formatter.format(now);
        return hour;
    }

    // Check if target hour is within start and end interval
    static bool isHourInInterval(String target, String start, String end) {
        return target.compareTo(start) >= 0 && target.compareTo(end) <= 0;
    }

    // Check if current time is within start and end interval
    static bool isNowInInterval(String start, String end) {
        return isHourInInterval(getCurrentHour(), start, end);
    }

    // Format date from yyyy-MM-dd'T'HH:mm:ss to dd MMM yyyy
    static String? getDate(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return '';
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('dd MMM yyyy', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'Error parsing date: $e');
            return null;
        }
    }

    // Format time from yyyy-MM-dd'T'HH:mm:ss to h:mm:ss a
    static String? getTime(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('h:mm:ss a', 'en_US');
            final formattedTime = outputFormatter.format(date);
            FslLog.d(_tag, 'dt time format $formattedTime');
            return formattedTime;
        } catch (e) {
            FslLog.e(_tag, 'Error parsing time: $e');
            return null;
        }
    }

    // Format date from dd MMM yyyy to E dd MMM yyyy
    static String? getDateWeekDay(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd MMM yyyy', 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('E dd MMM yyyy', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return null;
        }
    }

    // Format date from dd-MMM-yyyy to dd
    static String? getOnlyDate(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd-MMM-yyyy', 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('dd', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'Error parsing date: $e');
            return null;
        }
    }

    // Format date from dd-MMM-yyyy to MMM yyyy
    static String? getOnlyMonthAndYear(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd-MMM-yyyy', 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('MMM yyyy', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'Error parsing date: $e');
            return null;
        }
    }

    // Format date from yyyy-MM-dd HH:mm:ss to E dd MMM yyyy
    static String? getDateWeekDayWithYear(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('E dd MMM yyyy', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return null;
        }
    }

    // Format date from dd MMM yyyy to EEEE, dd MMMM
    static String? getFullWeekDayDateWithOutYear(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd MMM yyyy', 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('EEEE, dd MMMM', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return null;
        }
    }

    // Parse date from dd MMM yyyy to DateTime
    static DateTime? getDateFromString(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd MMM yyyy', 'en_US');
            final date = formatter.parse(strCurrentDate);
            FslLog.d(_tag, 'dt date format $date');
            return date;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return null;
        }
    }

    // Format date from yyyy-MM-dd'T'HH:mm:ss to dd-MMM-yyyy
    static String? getStringDateToTodayAlert(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');
            final date = formatter.parse(strCurrentDate);
            final outputFormatter = DateFormat('dd-MMM-yyyy', 'en_US');
            final formattedDate = outputFormatter.format(date);
            FslLog.d(_tag, 'dt date format $formattedDate');
            return formattedDate;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return strCurrentDate;
        }
    }

    // Parse date with time from dd MMM yyyy h:mm a to DateTime
    static DateTime? getDateWithTimeFromString(String? strCurrentDate) {
        if (strCurrentDate == null || strCurrentDate.isEmpty) {
            return null;
        }
        FslLog.d(_tag, 'dt date current $strCurrentDate');
        try {
            final formatter = DateFormat('dd MMM yyyy h:mm a', 'en_US');
            final date = formatter.parse(strCurrentDate);
            FslLog.d(_tag, 'dt date format $date');
            return date;
        } catch (e) {
            FslLog.e(_tag, 'ParseException to changing format: $e');
            return null;
        }
    }

    // Check if two DateTimes are on the same day
    static bool isSameDay(DateTime? date1, DateTime? date2) {
        if (date1 == null || date2 == null) {
            throw ArgumentError('The dates must not be null');
        }
        return date1.year == date2.year &&
            date1.month == date2.month &&
            date1.day == date2.day;
    }
}