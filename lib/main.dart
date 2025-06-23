import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/data_service.dart';
import 'services/voice_service.dart';
import 'pages/home/home_page.dart';
import 'utils/colors.dart';
import 'utils/text_styles.dart';

void main() {
  runApp(RusTiliApp());
}

class RusTiliApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize services
    Get.put(DataService());
    Get.put(VoiceService());

    return GetMaterialApp(
      title: 'Rus Tili',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          titleTextStyle: AppTextStyles.h3,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}