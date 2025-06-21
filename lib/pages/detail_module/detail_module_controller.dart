import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/module_model.dart';
import '../../models/theme_model.dart';
import '../../services/data_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class DetailModuleController extends GetxController {
  final DataService _dataService = Get.find<DataService>();

  // Observable states
  final _isLoading = false.obs;
  final _currentModule = Rxn<ModuleModel>();
  final _themes = <ThemeModel>[].obs;
  final _searchQuery = ''.obs;
  final _selectedDifficulty = 0.obs; // 0 = all

  // Getters
  bool get isLoading => _isLoading.value;
  ModuleModel? get currentModule => _currentModule.value;
  List<ThemeModel> get themes => _themes;
  List<ThemeModel> get filteredThemes => _getFilteredThemes();
  String get searchQuery => _searchQuery.value;
  int get selectedDifficulty => _selectedDifficulty.value;

  // Module statistics
  int get totalThemes => themes.length;
  int get completedThemes => themes.where((t) => t.isCompleted).length;
  int get availableThemes => themes.where((t) => !t.isLocked).length;
  double get moduleProgress => totalThemes > 0 ? completedThemes / totalThemes : 0.0;

  String get progressText => '$completedThemes/$totalThemes mavzu tugallangan';

  @override
  void onInit() {
    super.onInit();
    _loadModuleData();
  }

  void _loadModuleData() {
    final moduleId = Get.parameters['moduleId'];
    if (moduleId == null) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Modul ID topilmadi',
        type: SnackbarType.error,
      );
      Get.back();
      return;
    }

    _loadModule(moduleId);
  }

  Future<void> _loadModule(String moduleId) async {
    _isLoading.value = true;

    try {
      // Get module
      final module = _dataService.getModuleById(moduleId);
      if (module == null) {
        throw Exception('Modul topilmadi');
      }

      _currentModule.value = module;

      // Get themes for this module
      final moduleThemes = _dataService.getThemesByModuleId(moduleId);
      _themes.assignAll(moduleThemes);

    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Modulni yuklashda xatolik: $e',
        type: SnackbarType.error,
      );
      Get.back();
    } finally {
      _isLoading.value = false;
    }
  }

  // Search and filter methods
  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
  }

  void selectDifficulty(int difficulty) {
    _selectedDifficulty.value = difficulty;
  }

  List<ThemeModel> _getFilteredThemes() {
    List<ThemeModel> filtered = themes;

    // Filter by difficulty
    if (_selectedDifficulty.value > 0) {
      filtered = filtered
          .where((theme) => theme.difficulty == _selectedDifficulty.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((theme) {
        return theme.title.toLowerCase().contains(_searchQuery.value) ||
            theme.subtitle.toLowerCase().contains(_searchQuery.value) ||
            (theme.uzbekSummary ?? '').toLowerCase().contains(_searchQuery.value);
      }).toList();
    }

    return filtered;
  }

  // Navigation methods
  void goToTheme(ThemeModel theme) {
    if (theme.isLocked) {
      _showLockedThemeDialog(theme);
      return;
    }

    AppHelpers.safeNavigate(
      AppRoutes.themeRoute(theme.id, theme.articleId),
    );
  }

  void goToAIChat() {
    if (_currentModule.value != null) {
      AppHelpers.safeNavigate(
        AppRoutes.aiVoiceRoute(
          context: 'module:${_currentModule.value!.title}',
        ),
      );
    } else {
      AppHelpers.safeNavigate(AppRoutes.aiVoice);
    }
  }

  void _showLockedThemeDialog(ThemeModel theme) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mavzu qulflangan'),
        content: const Text(
          'Bu mavzuni ochish uchun avvalgi mavzularni tugatish kerak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tushundim'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Find the previous unlocked theme
              final availableTheme = themes
                  .where((t) => !t.isLocked && t.order < theme.order)
                  .lastOrNull;
              if (availableTheme != null) {
                goToTheme(availableTheme);
              }
            },
            child: const Text('Avvalgi mavzuga o\'tish'),
          ),
        ],
      ),
    );
  }

  // Theme details modal
  void showThemeDetails(ThemeModel theme) {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppHelpers.getDifficultyColor(theme.difficulty),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      theme.difficulty.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        theme.difficultyInUzbek,
                        style: TextStyle(
                          color: AppHelpers.getDifficultyColor(theme.difficulty),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (theme.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green),
                if (theme.isLocked)
                  const Icon(Icons.lock, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            Text(theme.subtitle),
            if (theme.hasUzbekSummary) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'O\'zbek tilida tushuntirish:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.uzbekSummary!,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(theme.formattedDuration),
                const SizedBox(width: 16),
                if (theme.hasKeywords) ...[
                  Icon(Icons.translate, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      theme.keywordsText,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (theme.hasMultimedia) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (theme.hasAudio)
                    Chip(
                      label: const Text('Audio'),
                      avatar: const Icon(Icons.volume_up, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (theme.hasVideo) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: const Text('Video'),
                      avatar: const Icon(Icons.play_circle, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: theme.isLocked ? null : () {
                  Get.back();
                  goToTheme(theme);
                },
                child: Text(
                    theme.isLocked ? 'Qulflangan' :
                    theme.isCompleted ? 'Qayta ko\'rish' : 'Boshlash'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progress methods
  Future<void> refreshData() async {
    if (_currentModule.value != null) {
      await _loadModule(_currentModule.value!.id);
    }
  }

  // Utility methods
  String getDifficultyDisplayName(int difficulty) {
    switch (difficulty) {
      case 1: return 'Juda oson';
      case 2: return 'Oson';
      case 3: return 'O\'rtacha';
      case 4: return 'Qiyin';
      case 5: return 'Juda qiyin';
      default: return 'Barchasi';
    }
  }

  List<int> get difficultyOptions => [0, 1, 2, 3, 4, 5];

  void showDifficultyFilter() {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Qiyinlik darajasi bo\'yicha saralash',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...difficultyOptions.map((difficulty) {
              final isSelected = _selectedDifficulty.value == difficulty;
              return ListTile(
                title: Text(getDifficultyDisplayName(difficulty)),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  selectDifficulty(difficulty);
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // Get next available theme
  ThemeModel? get nextAvailableTheme {
    return themes
        .where((theme) => !theme.isLocked && !theme.isCompleted)
        .firstOrNull;
  }

  void goToNextTheme() {
    final nextTheme = nextAvailableTheme;
    if (nextTheme != null) {
      goToTheme(nextTheme);
    } else {
      AppHelpers.showSnackbar(
        title: 'Tabriklaymiz!',
        message: 'Siz barcha mavjud mavzularni tugatdingiz',
        type: SnackbarType.success,
      );
    }
  }
}