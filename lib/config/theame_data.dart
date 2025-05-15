import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  
  // Color Scheme
  colorScheme: ColorScheme.light(
    primary: ColorsData.primaryColor,
    secondary: ColorsData.secondaryColor,
    surface: ColorsData.whiteColor,
    background: ColorsData.whiteColor,
    error: Colors.red,
  ),

  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorsData.whiteColor,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: ColorsData.textColor),
    titleTextStyle: TextStyle(
      color: ColorsData.textColor,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.textColor,
    ),
    displayMedium: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.textColor,
    ),
    displaySmall: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.textColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      color: ColorsData.textColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      color: ColorsData.textColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: ColorsData.darkGrayColor,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ColorsData.whiteColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorsData.darkGrayColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorsData.darkGrayColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorsData.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    hintStyle: TextStyle(
      color: ColorsData.darkGrayColor,
      fontSize: 14.sp,
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsData.primaryColor,
      foregroundColor: ColorsData.whiteColor,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 2,
    ),
  ),

  // Card Theme
  cardTheme: CardTheme(
    color: ColorsData.whiteColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
    shadowColor: ColorsData.shadowColor,
  ),

  // Container Theme
  extensions: <ThemeExtension<dynamic>>[
    ContainerTheme(
      defaultPadding: EdgeInsets.all(16.r),
      defaultMargin: EdgeInsets.all(16.r),
      defaultBorderRadius: BorderRadius.circular(10.r),
      defaultBoxShadow: [
        BoxShadow(
          color: ColorsData.shadowColor,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  ],
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  
  // Color Scheme
  colorScheme: ColorScheme.dark(
    primary: ColorsData.primaryColor,
    secondary: ColorsData.secondaryColor,
    surface: ColorsData.darkGrayColor,
    background: ColorsData.darkGrayColor,
    error: Colors.red,
  ),

  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorsData.darkGrayColor,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: ColorsData.whiteColor),
    titleTextStyle: TextStyle(
      color: ColorsData.whiteColor,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.whiteColor,
    ),
    displayMedium: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.whiteColor,
    ),
    displaySmall: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: ColorsData.whiteColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      color: ColorsData.whiteColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      color: ColorsData.whiteColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: ColorsData.whiteColor.withOpacity(0.7),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ColorsData.darkGrayColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: ColorsData.whiteColor.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: ColorsData.whiteColor.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorsData.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    hintStyle: TextStyle(
      color: ColorsData.whiteColor.withOpacity(0.5),
      fontSize: 14.sp,
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsData.primaryColor,
      foregroundColor: ColorsData.whiteColor,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 2,
    ),
  ),

  // Card Theme
  cardTheme: CardTheme(
    color: ColorsData.darkGrayColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
    shadowColor: ColorsData.shadowColor,
  ),

  // Container Theme
  extensions: <ThemeExtension<dynamic>>[
    ContainerTheme(
      defaultPadding: EdgeInsets.all(16.r),
      defaultMargin: EdgeInsets.all(16.r),
      defaultBorderRadius: BorderRadius.circular(10.r),
      defaultBoxShadow: [
        BoxShadow(
          color: ColorsData.shadowColor,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  ],
);

class ColorsData {
  // Primary Colors
  static const Color primaryColor = Color(0xFF3fbbc0);
  static const Color secondaryColor = Color(0xFF65c9cd);
  
  // Text Colors
  static const Color textColor = Color(0xFF444444);
  static const Color darkGrayColor = Color(0xFF333333);
  
  // Background Colors
  static const Color whiteColor = Colors.white;
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.1);
  
  // Status Colors
  static const Color successColor = Color(0xFF18D26E);
  static const Color errorColor = Color(0xFFED3C0D);
  static const Color warningColor = Color(0xFFFFA000);
}

class ContainerTheme extends ThemeExtension<ContainerTheme> {
  final EdgeInsets defaultPadding;
  final EdgeInsets defaultMargin;
  final BorderRadius defaultBorderRadius;
  final List<BoxShadow> defaultBoxShadow;

  const ContainerTheme({
    required this.defaultPadding,
    required this.defaultMargin,
    required this.defaultBorderRadius,
    required this.defaultBoxShadow,
  });

  @override
  ThemeExtension<ContainerTheme> copyWith({
    EdgeInsets? defaultPadding,
    EdgeInsets? defaultMargin,
    BorderRadius? defaultBorderRadius,
    List<BoxShadow>? defaultBoxShadow,
  }) {
    return ContainerTheme(
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultMargin: defaultMargin ?? this.defaultMargin,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      defaultBoxShadow: defaultBoxShadow ?? this.defaultBoxShadow,
    );
  }

  @override
  ThemeExtension<ContainerTheme> lerp(ThemeExtension<ContainerTheme>? other, double t) {
    if (other is! ContainerTheme) return this;
    return ContainerTheme(
      defaultPadding: EdgeInsets.lerp(defaultPadding, other.defaultPadding, t)!,
      defaultMargin: EdgeInsets.lerp(defaultMargin, other.defaultMargin, t)!,
      defaultBorderRadius: BorderRadius.lerp(defaultBorderRadius, other.defaultBorderRadius, t)!,
      defaultBoxShadow: defaultBoxShadow,
    );
  }
}

class AppSizes {
  // Padding and Margin Sizes
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  static const double smallMargin = 8.0;
  static const double mediumMargin = 16.0;
  static const double largeMargin = 24.0;

  // Button Sizes
  static const double buttonHeight = 48.0;
  static const double buttonWidth = 150.0;

  // Icon Sizes
  static const double smallIconSize = 24.0;
  static const double mediumIconSize = 32.0;
  static const double largeIconSize = 48.0;

  // Text Sizes
  static const double smallTextSize = 12.0;
  static const double mediumTextSize = 16.0;
  static const double largeTextSize = 24.0;

  // Container Sizes
  static const double containerWidth = 200.0;
  static const double containerHeight = 150.0;

  // Other Sizes
  static const double borderRadius = 8.0;
}