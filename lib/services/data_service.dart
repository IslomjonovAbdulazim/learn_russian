import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/module_model.dart';
import '../models/theme_model.dart';
import '../models/article_model.dart';
import '../utils/mock_data.dart';
import '../utils/constants.dart';
import 'dart:convert';

class DataService extends GetxService {
  late SharedPreferences _prefs;

  // Observable data
  final _modules = <ModuleModel>[].obs;
  final _themes = <ThemeModel>[].obs;
  final _userProgress = <String, double>{}.obs;
  final _completedThemes = <String>[].obs;

  // Getters
  List<ModuleModel> get modules => _modules;
  List<ThemeModel> get themes => _themes;
  Map<String, double> get userProgress => _userProgress;
  List<String> get completedThemes => _completedThemes;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initSharedPreferences();
    await _loadData();
    _loadUserProgress();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadData() async {
    // Load modules and themes from mock data
    // In real app, this would be from API or local database
    _modules.assignAll(MockData.modules);
    _themes.assignAll(MockData.themes);

    // Update modules with user progress
    _updateModulesWithProgress();
  }

  void _loadUserProgress() {
    // Load completed themes
    final completed = _prefs.getStringList('completed_themes') ?? [];
    _completedThemes.assignAll(completed);

    // Load module progress
    final progressJson = _prefs.getString(AppConstants.keyProgress);
    if (progressJson != null) {
      final Map<String, dynamic> progressMap = json.decode(progressJson);
      _userProgress.assignAll(
        progressMap.map((key, value) => MapEntry(key, value.toDouble())),
      );
    }

    _updateModulesWithProgress();
    _updateThemesWithProgress();
  }

  void _updateModulesWithProgress() {
    for (int i = 0; i < _modules.length; i++) {
      final module = _modules[i];
      final progress = _userProgress[module.id] ?? 0.0;
      final isCompleted = progress >= 1.0;

      // Check if module should be locked
      bool isLocked = false;
      if (module.hasPrerequisites) {
        isLocked = !module.prerequisites.every((prereqId) {
          final prereqProgress = _userProgress[prereqId] ?? 0.0;
          return prereqProgress >= 1.0;
        });
      }

      _modules[i] = module.copyWith(
        progress: progress,
        isCompleted: isCompleted,
        isLocked: isLocked,
      );
    }
  }

  void _updateThemesWithProgress() {
    for (int i = 0; i < _themes.length; i++) {
      final theme = _themes[i];
      final isCompleted = _completedThemes.contains(theme.id);

      // Check if theme should be locked based on previous themes
      bool isLocked = false;
      final moduleThemes = getThemesByModuleId(theme.moduleId);
      final currentIndex = moduleThemes.indexWhere((t) => t.id == theme.id);

      if (currentIndex > 0) {
        final previousTheme = moduleThemes[currentIndex - 1];
        isLocked = !_completedThemes.contains(previousTheme.id);
      }

      _themes[i] = theme.copyWith(
        isCompleted: isCompleted,
        isLocked: isLocked,
      );
    }
  }

  // Get methods
  List<ThemeModel> getThemesByModuleId(String moduleId) {
    return _themes
        .where((theme) => theme.moduleId == moduleId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  ModuleModel? getModuleById(String id) {
    try {
      return _modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  ThemeModel? getThemeById(String id) {
    try {
      return _themes.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return null;
    }
  }

  ArticleModel? getArticleById(String id) {
    // For now, return mock data
    // In real app, this would fetch from API/database
    return MockData.getArticleById(id);
  }

  // Progress tracking methods
  Future<void> completeTheme(String themeId) async {
    if (!_completedThemes.contains(themeId)) {
      _completedThemes.add(themeId);
      await _saveCompletedThemes();

      // Update module progress
      final theme = getThemeById(themeId);
      if (theme != null) {
        await _updateModuleProgress(theme.moduleId);
      }

      _updateModulesWithProgress();
      _updateThemesWithProgress();
    }
  }

  Future<void> _updateModuleProgress(String moduleId) async {
    final moduleThemes = getThemesByModuleId(moduleId);
    final completedCount = moduleThemes
        .where((theme) => _completedThemes.contains(theme.id))
        .length;

    final progress = moduleThemes.isNotEmpty
        ? completedCount / moduleThemes.length
        : 0.0;

    _userProgress[moduleId] = progress;
    await _saveUserProgress();
  }

  Future<void> _saveCompletedThemes() async {
    await _prefs.setStringList('completed_themes', _completedThemes);
  }

  Future<void> _saveUserProgress() async {
    final progressJson = json.encode(_userProgress);
    await _prefs.setString(AppConstants.keyProgress, progressJson);
  }

  // Reset progress (for testing)
  Future<void> resetProgress() async {
    _completedThemes.clear();
    _userProgress.clear();
    await _prefs.remove('completed_themes');
    await _prefs.remove(AppConstants.keyProgress);

    _updateModulesWithProgress();
    _updateThemesWithProgress();
  }

  // Statistics
  int get totalModules => _modules.length;
  int get completedModules => _modules.where((m) => m.isCompleted).length;
  int get totalThemes => _themes.length;
  int get completedThemesCount => _completedThemes.length;

  double get overallProgress => totalThemes > 0
      ? completedThemesCount / totalThemes
      : 0.0;

  String get progressText =>
      '$completedThemesCount/$totalThemes mavzu tugallangan';

  List<ModuleModel> get availableModules =>
      _modules.where((module) => !module.isLocked).toList();

  List<ModuleModel> get inProgressModules =>
      _modules.where((module) => module.isStarted && !module.isCompleted).toList();

  List<ThemeModel> getAvailableThemes(String moduleId) {
    return getThemesByModuleId(moduleId)
        .where((theme) => !theme.isLocked)
        .toList();
  }
}