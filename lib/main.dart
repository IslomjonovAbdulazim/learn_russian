import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/app_theme.dart';
import 'services/theme_service.dart';
import 'services/data_service.dart';
import 'services/api_service.dart';
import 'services/voice_service.dart';
import 'services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await initServices();

  runApp(const RussianUzbekApp());
}

Future<void> initServices() async {
  // Initialize theme service
  await Get.putAsync(() => ThemeService().onInit().then((_) => ThemeService()));

  // Initialize data service
  await Get.putAsync(() => DataService().onInit().then((_) => DataService()));

  // Initialize API service
  Get.put(ApiService());

  // Initialize voice service
  Get.put(VoiceService());

  // Initialize AI service
  Get.put(AIService());

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class RussianUzbekApp extends StatelessWidget {
  const RussianUzbekApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() => GetMaterialApp(
      title: 'Rus Tili',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,

      // Localization
      locale: const Locale('uz', 'UZ'),
      fallbackLocale: const Locale('en', 'US'),

      // Routing
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,

      // Default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Error handling
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const NotFoundPage(),
      ),

      // App lifecycle
      onInit: () {
        // Additional initialization if needed
      },
    ));
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahifa topilmadi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sahifa topilmadi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Siz qidirayotgan sahifa mavjud emas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(AppRoutes.home),
              child: const Text('Bosh sahifaga qaytish'),
            ),
          ],
        ),
      ),
    );
  }
}