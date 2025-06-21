import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/helpers.dart';
import 'theme_controller.dart';
import 'widgets/article_renderer.dart';

class ThemePage extends GetView<ThemeController> {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading
          ? const _LoadingWidget()
          : const _ThemeContent()),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Obx(() {
      if (controller.isLoading) return const SizedBox.shrink();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI Chat FAB
          FloatingActionButton(
            heroTag: "ai_chat",
            onPressed: controller.goToAIChat,
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.smart_toy, color: Colors.white),
          ).animate().scale(delay: 600.ms),

          const SizedBox(height: 12),

          // Reading Settings FAB
          FloatingActionButton(
            heroTag: "settings",
            onPressed: controller.showReadingSettings,
            backgroundColor: AppColors.secondaryAmber,
            mini: true,
            child: const Icon(Icons.settings, color: Colors.white),
          ).animate().scale(delay: 700.ms),
        ],
      );
    });
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Maqola yuklanmoqda...'),
          ],
        ),
      ),
    );
  }
}

class _ThemeContent extends GetView<ThemeController> {
  const _ThemeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        _buildAppBar(),
        _buildProgressIndicator(),
        _buildArticleMetadata(),
        _buildArticleContent(),
        _buildCompletionSection(),
      ],
    );
  }

  Widget _buildAppBar() {
    return Obx(() {
      final theme = controller.currentTheme;
      final module = controller.currentModule;

      if (theme == null) return const SliverToBoxAdapter();

      return SliverAppBar(
        expandedHeight: 180,
        floating: false,
        pinned: true,
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: controller.shareTheme,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: controller.showReadingSettings,
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            theme.title,
            style: AppTextStyles.heading5.copyWith(color: Colors.white),
          ),
          background: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 60,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (module != null)
                        Text(
                          module.title,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        theme.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          theme.formattedDuration,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().slideY(duration: 300.ms);
    });
  }

  Widget _buildProgressIndicator() {
    return SliverToBoxAdapter(
      child: Obx(() => Container(
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(3),
              ),
              width: Get.width * controller.readingProgress,
            ),
          ],
        ),
      )).animate().slideX(delay: 200.ms),
    );
  }

  Widget _buildArticleMetadata() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final article = controller.currentArticle;
        final theme = controller.currentTheme;

        if (article == null || theme == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article title
              if (article.hasSubtitle) ...[
                Text(
                  article.title,
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 8),
                Text(
                  article.subtitle!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ] else ...[
                Text(
                  article.title,
                  style: AppTextStyles.heading4,
                ),
              ],

              const SizedBox(height: 16),

              // Metadata chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetadataChip(
                    icon: Icons.person,
                    label: article.metadata.author,
                  ),
                  _MetadataChip(
                    icon: Icons.schedule,
                    label: article.metadata.readTime,
                  ),
                  _MetadataChip(
                    icon: Icons.signal_cellular_alt,
                    label: article.metadata.levelInUzbek,
                    color: article.metadata.levelColor,
                  ),
                  if (theme.hasKeywords)
                    _MetadataChip(
                      icon: Icons.translate,
                      label: '${theme.keywords.length} so\'z',
                    ),
                ],
              ),

              // Tags
              if (article.metadata.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: article.metadata.tags.map((tag) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                  ).toList(),
                ),
              ],

              // Uzbek explanation
              if (theme.hasUzbekSummary && controller.showUzbekExplanation) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryAmber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.secondaryAmber.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.secondaryAmber,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'O\'zbek tilida tushuntirish:',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.secondaryAmber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theme.uzbekSummary!,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],

              // Reading progress
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.menu_book, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    controller.progressText,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    controller.estimatedTimeLeft,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      }).animate().fadeIn(delay: 300.ms).slideY(),
    );
  }

  Widget _buildArticleContent() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final article = controller.currentArticle;
        if (article == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ArticleRenderer(
            article: article,
            fontSize: controller.fontSize,
          ),
        );
      }).animate().fadeIn(delay: 400.ms),
    );
  }

  Widget _buildCompletionSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.isCompleted) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Tabriklaymiz!',
                  style: AppTextStyles.heading4.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Siz ushbu mavzuni muvaffaqiyatli tugalladingiz',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().scale().fadeIn();
        } else {
          return Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: controller.manuallyCompleteTheme,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Mavzuni tugatish',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).animate().slideY(delay: 500.ms);
        }
      }),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetadataChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primaryBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: chipColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}