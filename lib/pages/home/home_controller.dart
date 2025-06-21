import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/module_model.dart';
import '../../services/data_service.dart';
import '../../services/theme_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class HomeController extends GetxController {
  final DataService _dataService = Get.find<DataService>();
  final ThemeService _themeService = Get.find<ThemeService>();

  // Observable states
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = 'all'.obs;
  final _isGridView = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  bool get isGridView => _isGridView.value;

  // Data getters
  List<ModuleModel> get allModules => _dataService.modules;
  List<ModuleModel> get filteredModules => _getFilteredModules();
  List<ModuleModel> get featuredModules => _getFeaturedModules();
  List<ModuleModel> get inProgressModules => _dataService.inProgressModules;
  List<ModuleModel> get availableModules => _dataService.availableModules;

  // Statistics
  double get overallProgress => _dataService.overallProgress;
  String get progressText => _dataService.progressText;
  int get completedModules => _dataService.completedModules;
  int get totalModules => _dataService.totalModules;

  // Categories
  List<String> get categories => [
    'all',
    'basics',
    'vocabulary',
    'grammar',
    'conversation',
    'reading',
    'writing',
  ];

  List<String> get categoriesInUzbek => [
    'Barchasi',
    'Asoslar',
    'So\'z boyligi',
    'Grammatika',
    'Suhbat',
    'O\'qish',
    'Yozish',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  void onReady() {
    super.onReady();
    _showWelcomeMessageIfFirstTime();
  }

  Future<void> _loadData() async {
    _isLoading.value = true;

    try {
      // Data is already loaded in DataService
      // This is just to show loading state
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Ma\'lumotlarni yuklashda xatolik yuz berdi',
        type: SnackbarType.error,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _showWelcomeMessageIfFirstTime() {
    // TODO: Check if first time and show welcome dialog
  }

  // Search and filter methods
  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
    update(); // Trigger GetBuilder updates
  }

  void selectCategory(String category) {
    _selectedCategory.value = category;
    update(); // Trigger GetBuilder updates
  }

  void toggleViewMode() {
    _isGridView.value = !_isGridView.value;
    update(); // Trigger GetBuilder updates
  }

  List<ModuleModel> _getFilteredModules() {
    List<ModuleModel> modules = allModules;

    // Filter by category
    if (_selectedCategory.value != 'all') {
      modules = modules
          .where((module) => module.category == _selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      modules = modules.where((module) {
        return module.title.toLowerCase().contains(_searchQuery.value) ||
            module.description.toLowerCase().contains(_searchQuery.value) ||
            (module.uzbekDescription ?? '').toLowerCase().contains(_searchQuery.value);
      }).toList();
    }

    return modules;
  }

  List<ModuleModel> _getFeaturedModules() {
    // Return first 3 available modules for featured section
    return availableModules.take(3).toList();
  }

  // Navigation methods
  void goToModule(ModuleModel module) {
    if (module.isLocked) {
      _showLockedModuleDialog(module);
      return;
    }

    AppHelpers.safeNavigate(
      AppRoutes.detailModuleRoute(module.id),
    );
  }

  void goToAIChat() {
    AppHelpers.safeNavigate(AppRoutes.aiVoice);
  }

  void _showLockedModuleDialog(ModuleModel module) {
    Get.dialog(
      AlertDialog(
        title: const Text('Modul qulflangan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bu modulni ochish uchun avval quyidagi modullarni tugatish kerak:'),
            const SizedBox(height: 8),
            ...module.prerequisites.map((prereqId) {
              final prereqModule = _dataService.getModuleById(prereqId);
              return Text('• ${prereqModule?.title ?? 'Noma\'lum modul'}');
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tushundim'),
          ),
          if (module.prerequisites.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Get.back();
                final firstPrereq = _dataService.getModuleById(module.prerequisites.first);
                if (firstPrereq != null && !firstPrereq.isLocked) {
                  goToModule(firstPrereq);
                }
              },
              child: const Text('Boshlaymiz'),
            ),
        ],
      ),
    );
  }

  // Progress methods
  Future<void> refreshData() async {
    await _loadData();
    update(); // Refresh UI
  }

  // Theme methods
  void toggleTheme() {
    _themeService.toggleTheme();
  }

  void showThemeSelector() {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mavzu tanlash',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Yorug\''),
              trailing: _themeService.isLight ? const Icon(Icons.check) : null,
              onTap: () {
                _themeService.setLightTheme();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Qorong\'u'),
              trailing: _themeService.isDark ? const Icon(Icons.check) : null,
              onTap: () {
                _themeService.setDarkTheme();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Tizim'),
              trailing: _themeService.isSystem ? const Icon(Icons.check) : null,
              onTap: () {
                _themeService.setSystemTheme();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String getCategoryDisplayName(String category) {
    final index = categories.indexOf(category);
    return index != -1 ? categoriesInUzbek[index] : category;
  }

  void showModuleDetails(ModuleModel module) {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  module.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        module.levelInUzbek,
                        style: TextStyle(
                          color: AppHelpers.getDifficultyColor(
                              module.level == 'beginner' ? 1 :
                              module.level == 'intermediate' ? 3 : 5
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(module.description),
            if (module.hasUzbekDescription) ...[
              const SizedBox(height: 8),
              Text(
                module.uzbekDescription!,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.book_outlined, size: 16),
                const SizedBox(width: 4),
                Text('${module.themeCount} ta mavzu'),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16),
                const SizedBox(width: 4),
                Text(module.durationEstimate),
              ],
            ),
            if (module.isStarted) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(value: module.progress),
              const SizedBox(height: 4),
              Text(module.progressText),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: module.isLocked ? null : () {
                  Get.back();
                  goToModule(module);
                },
                child: Text(
                    module.isLocked ? 'Qulflangan' :
                    module.isCompleted ? 'Qayta ko\'rish' :
                    module.isStarted ? 'Davom etish' : 'Boshlash'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}