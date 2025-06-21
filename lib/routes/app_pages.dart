import 'package:get/get.dart';
import '../pages/home/home_page.dart';
import '../pages/home/home_controller.dart';
import '../pages/detail_module/detail_module_page.dart';
import '../pages/detail_module/detail_module_controller.dart';
import '../pages/theme/theme_page.dart';
import '../pages/theme/theme_controller.dart';
import '../pages/ai_voice/ai_voice_page.dart';
import '../pages/ai_voice/ai_voice_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    // Home Page
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.detailModule,
      page: () => const DetailModulePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DetailModuleController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Theme Page (Article)
    GetPage(
      name: AppRoutes.theme,
      page: () => const ThemePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ThemeController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // // AI Voice Page
    // GetPage(
    //   name: AppRoutes.aiVoice,
    //   page: () => const AIVoicePage(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => AIVoiceController());
    //   }),
    //   transition: Transition.downToUp,
    //   transitionDuration: const Duration(milliseconds: 400),
    // ),
  ];
}