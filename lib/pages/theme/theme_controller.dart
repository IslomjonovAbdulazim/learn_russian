import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../models/article_component_model.dart';
import '../../models/theme_model.dart';
import '../../models/article_model.dart';
import '../../models/module_model.dart';
import '../../services/data_service.dart';
import '../../services/voice_service.dart';
import '../../services/ai_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers.dart';

class ThemeController extends GetxController with GetTickerProviderStateMixin {
  final DataService _dataService = Get.find<DataService>();
  final VoiceService _voiceService = Get.find<VoiceService>();
  final AIService _aiService = Get.find<AIService>();

  // Observable states
  final _isLoading = false.obs;
  final _currentTheme = Rxn<ThemeModel>();
  final _currentModule = Rxn<ModuleModel>();
  final _currentArticle = Rxn<ArticleModel>();
  final _isCompleted = false.obs;
  final _readingProgress = 0.0.obs;
  final _fontSize = 16.0.obs;
  final _isAutoScrolling = false.obs;
  final _showUzbekExplanation = false.obs;

  // Animation controllers
  late AnimationController progressAnimationController;
  late AnimationController completionAnimationController;

  // Scroll controller for article
  final ScrollController scrollController = ScrollController();

  // Getters
  bool get isLoading => _isLoading.value;
  ThemeModel? get currentTheme => _currentTheme.value;
  ModuleModel? get currentModule => _currentModule.value;
  ArticleModel? get currentArticle => _currentArticle.value;
  bool get isCompleted => _isCompleted.value;
  double get readingProgress => _readingProgress.value;
  double get fontSize => _fontSize.value;
  bool get isAutoScrolling => _isAutoScrolling.value;
  bool get showUzbekExplanation => _showUzbekExplanation.value;

  @override
  void onInit() {
    super.onInit();
    _initAnimationControllers();
    _loadThemeData();
    _setupScrollListener();
  }

  @override
  void onClose() {
    progressAnimationController.dispose();
    completionAnimationController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _initAnimationControllers() {
    progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    completionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _loadThemeData() {
    final themeId = Get.parameters['themeId'];
    final articleId = Get.parameters['articleId'];

    if (themeId == null || articleId == null) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Mavzu yoki maqola ID topilmadi',
        type: SnackbarType.error,
      );
      Get.back();
      return;
    }

    _loadTheme(themeId, articleId);
  }

  Future<void> _loadTheme(String themeId, String articleId) async {
    _isLoading.value = true;

    try {
      // Get theme
      final theme = _dataService.getThemeById(themeId);
      if (theme == null) {
        throw Exception('Mavzu topilmadi');
      }

      _currentTheme.value = theme;
      _isCompleted.value = theme.isCompleted;

      // Get module
      final module = _dataService.getModuleById(theme.moduleId);
      _currentModule.value = module;

      // Get article
      final article = _dataService.getArticleById(articleId);
      if (article == null) {
        throw Exception('Maqola topilmadi');
      }

      _currentArticle.value = article;

      // Set AI context for this theme
      if (module != null) {
        _aiService.setLearningContext(module.title, theme.title);
      }

    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Mavzuni yuklashda xatolik: $e',
        type: SnackbarType.error,
      );
      Get.back();
    } finally {
      _isLoading.value = false;
    }
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      _updateReadingProgress();
    });
  }

  void _updateReadingProgress() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;

      if (maxScroll > 0) {
        final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
        _readingProgress.value = progress;
        progressAnimationController.animateTo(progress);

        // Auto-complete when user scrolls to 90% of the article
        if (progress >= 0.9 && !_isCompleted.value) {
          _completeTheme();
        }
      }
    }
  }

  // Font size controls
  void increaseFontSize() {
    if (_fontSize.value < 24) {
      _fontSize.value += 2;
    }
  }

  void decreaseFontSize() {
    if (_fontSize.value > 12) {
      _fontSize.value -= 2;
    }
  }

  void resetFontSize() {
    _fontSize.value = 16;
  }

  // Auto scroll functionality
  void toggleAutoScroll() {
    _isAutoScrolling.value = !_isAutoScrolling.value;

    if (_isAutoScrolling.value) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (!_isAutoScrolling.value || !scrollController.hasClients) return;

    const scrollSpeed = 50.0; // pixels per second
    const interval = Duration(milliseconds: 100);

    Future.delayed(interval, () {
      if (_isAutoScrolling.value && scrollController.hasClients) {
        final currentPosition = scrollController.position.pixels;
        final maxScroll = scrollController.position.maxScrollExtent;

        if (currentPosition < maxScroll) {
          scrollController.animateTo(
            currentPosition + (scrollSpeed * interval.inMilliseconds / 1000),
            duration: interval,
            curve: Curves.linear,
          );
          _startAutoScroll(); // Continue scrolling
        } else {
          _isAutoScrolling.value = false;
          _completeTheme(); // Auto-complete when reached end
        }
      }
    });
  }

  // Uzbek explanation toggle
  void toggleUzbekExplanation() {
    _showUzbekExplanation.value = !_showUzbekExplanation.value;
  }

  // Text-to-speech functionality
  Future<void> readArticleAloud() async {
    if (_currentArticle.value == null) return;

    try {
      final article = _currentArticle.value!;
      String textToRead = '';

      // Collect all text content from article components
      for (final component in article.components) {
        switch (component.type) {
          case ArticleComponentType.heading:
          case ArticleComponentType.text:
          case ArticleComponentType.quote:
            textToRead += '${component.textContent}. ';
            break;
          case ArticleComponentType.list:
            for (final item in component.listItems) {
              textToRead += '$item. ';
            }
            break;
          default:
            break;
        }
      }

      if (textToRead.isNotEmpty) {
        await _voiceService.speakRussianText(textToRead);

        AppHelpers.showSnackbar(
          title: 'Ovoz',
          message: 'Maqola o\'qilmoqda...',
          type: SnackbarType.info,
        );
      }
    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Ovozli o\'qishda xatolik yuz berdi',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> stopReading() async {
    await _voiceService.stopSpeaking();
  }

  // Theme completion
  Future<void> _completeTheme() async {
    if (_isCompleted.value || _currentTheme.value == null) return;

    try {
      await _dataService.completeTheme(_currentTheme.value!.id);
      _isCompleted.value = true;

      // Play completion animation
      completionAnimationController.forward();

      AppHelpers.showSnackbar(
        title: 'Tabriklaymiz!',
        message: 'Mavzu muvaffaqiyatli tugallandi',
        type: SnackbarType.success,
      );

      // Show completion dialog after a delay
      Future.delayed(const Duration(seconds: 1), _showCompletionDialog);

    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Jarayonni saqlashda xatolik yuz berdi',
        type: SnackbarType.error,
      );
    }
  }

  void _showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Tabriklaymiz!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Siz ushbu mavzuni muvaffaqiyatli tugalladingiz!'),
            if (_currentTheme.value?.hasKeywords == true) ...[
              const SizedBox(height: 16),
              const Text('Yangi so\'zlar:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: _currentTheme.value!.keywords.map((keyword) =>
                    Chip(
                      label: Text(keyword),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ).toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to module page
            },
            child: const Text('Modulga qaytish'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              _goToNextTheme();
            },
            child: const Text('Keyingi mavzu'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _goToNextTheme() {
    if (_currentTheme.value == null) return;

    final moduleThemes = _dataService.getThemesByModuleId(_currentTheme.value!.moduleId);
    final currentIndex = moduleThemes.indexWhere((t) => t.id == _currentTheme.value!.id);

    if (currentIndex >= 0 && currentIndex < moduleThemes.length - 1) {
      final nextTheme = moduleThemes[currentIndex + 1];

      Get.offNamed(
        AppRoutes.themeRoute(nextTheme.id, nextTheme.articleId),
      );
    } else {
      // No more themes in this module
      AppHelpers.showSnackbar(
        title: 'Modul tugallandi',
        message: 'Siz ushbu moduldagi barcha mavzularni tugalladingiz!',
        type: SnackbarType.success,
      );
      Get.back(); // Go back to module page
    }
  }

  // Navigation methods
  void goToAIChat() {
    if (_currentModule.value != null && _currentTheme.value != null) {
      AppHelpers.safeNavigate(
        AppRoutes.aiVoiceRoute(
          context: 'theme:${_currentTheme.value!.title}',
        ),
      );
    } else {
      AppHelpers.safeNavigate(AppRoutes.aiVoice);
    }
  }

  void goBack() {
    Get.back();
  }

  // Reading settings
  void showReadingSettings() {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'O\'qish sozlamalari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Font size controls
            Row(
              children: [
                const Text('Shrift o\'lchami:'),
                const Spacer(),
                IconButton(
                  onPressed: decreaseFontSize,
                  icon: const Icon(Icons.remove),
                ),
                Obx(() => Text('${fontSize.round()}')),
                IconButton(
                  onPressed: increaseFontSize,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            // Auto-scroll toggle
            Obx(() => SwitchListTile(
              title: const Text('Avtomatik aylantirish'),
              subtitle: const Text('Maqolani avtomatik aylantiradi'),
              value: isAutoScrolling,
              onChanged: (_) => toggleAutoScroll(),
            )),

            // Uzbek explanation toggle
            Obx(() => SwitchListTile(
              title: const Text('O\'zbek tilidagi tushuntirish'),
              subtitle: const Text('Qo\'shimcha tushuntirishlarni ko\'rsatish'),
              value: showUzbekExplanation,
              onChanged: (_) => toggleUzbekExplanation(),
            )),

            const SizedBox(height: 16),

            // Voice controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _voiceService.isSpeaking ? stopReading : readArticleAloud,
                    icon: Icon(_voiceService.isSpeaking ? Icons.stop : Icons.volume_up),
                    label: Text(_voiceService.isSpeaking ? 'To\'xtatish' : 'Ovozli o\'qish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Utility methods
  String get progressText {
    return '${(readingProgress * 100).round()}% o\'qildi';
  }

  String get estimatedTimeLeft {
    if (_currentArticle.value == null) return '';

    final totalTime = _currentArticle.value!.estimatedReadingTime;
    final timeLeft = (totalTime * (1 - readingProgress)).round();

    return timeLeft > 0 ? '${timeLeft}d qoldi' : 'Tugallandi';
  }

  void manuallyCompleteTheme() {
    if (!_isCompleted.value) {
      _completeTheme();
    }
  }

  // Share functionality (for future implementation)
  void shareTheme() {
    if (_currentTheme.value != null) {
      final shareText = 'Men "${_currentTheme.value!.title}" mavzusini o\'qiyapman. Rus tilini o\'rganish juda qiziq!';
      AppHelpers.shareContent(shareText);
    }
  }
}