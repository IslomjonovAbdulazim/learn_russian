import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/theme_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/helpers.dart';
import 'detail_module_controller.dart';

class DetailModulePage extends GetView<DetailModuleController> {
  const DetailModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading
          ? const _LoadingWidget()
          : const _DetailModuleContent()),
      floatingActionButton: Obx(() => controller.currentModule != null
          ? FloatingActionButton.extended(
        onPressed: controller.goToAIChat,
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.smart_toy, color: Colors.white),
        label: const Text(
          'AI Yordam',
          style: TextStyle(color: Colors.white),
        ),
      ).animate().scale(delay: 600.ms)
          : const SizedBox.shrink()),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Modul yuklanmoqda...'),
          ],
        ),
      ),
    );
  }
}

class _DetailModuleContent extends GetView<DetailModuleController> {
  const _DetailModuleContent();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildModuleInfo(),
          _buildProgressCard(),
          _buildSearchAndFilter(),
          _buildThemesList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Obx(() {
      final module = controller.currentModule;
      if (module == null) return const SliverToBoxAdapter();

      return SliverAppBar(
        expandedHeight: 200,
        floating: false,
        pinned: true,
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            module.title,
            style: AppTextStyles.heading5.copyWith(color: Colors.white),
          ),
          background: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  left: 16,
                  child: Text(
                    module.icon,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          module.levelInUzbek,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${module.themeCount} mavzu',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().slideY(duration: 300.ms);
    });
  }

  Widget _buildModuleInfo() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final module = controller.currentModule;
        if (module == null) return const SizedBox.shrink();

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
              Text(
                'Modul haqida',
                style: AppTextStyles.heading5,
              ),
              const SizedBox(height: 8),
              Text(
                module.description,
                style: AppTextStyles.bodyMedium,
              ),
              if (module.hasUzbekDescription) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'O\'zbek tilida:',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.uzbekDescription!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.category,
                    label: module.categoryInUzbek,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.schedule,
                    label: module.durationEstimate,
                  ),
                ],
              ),
            ],
          ),
        );
      }).animate().fadeIn(delay: 200.ms).slideY(),
    );
  }

  Widget _buildProgressCard() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.completedThemes == 0) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.warmGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Sizning jarayoningiz',
                    style: AppTextStyles.heading5.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: controller.moduleProgress,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                controller.progressText,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${controller.availableThemes} ta mavzu mavjud',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  const Spacer(),
                  if (controller.nextAvailableTheme != null)
                    TextButton(
                      onPressed: controller.goToNextTheme,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: const Text(
                        'Davom etish',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }).animate().fadeIn(delay: 300.ms).slideX(),
    );
  }

  Widget _buildSearchAndFilter() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Mavzularni qidirish...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () => controller.updateSearchQuery(''),
                  icon: const Icon(Icons.clear),
                )
                    : IconButton(
                  onPressed: controller.showDifficultyFilter,
                  icon: const Icon(Icons.filter_list),
                )),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => controller.selectedDifficulty > 0
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Qiyinlik: ${controller.getDifficultyDisplayName(controller.selectedDifficulty)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.selectDifficulty(0),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms),
    );
  }

  Widget _buildThemesList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mavzular',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 16),
            Obx(() => controller.filteredThemes.isEmpty
                ? _buildEmptyState()
                : _buildThemesListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Hech qanday mavzu topilmadi',
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Qidiruv shartlarini o\'zgartirib ko\'ring',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildThemesListView() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filteredThemes.length,
      itemBuilder: (context, index) {
        final theme = controller.filteredThemes[index];
        return _ThemeCard(
          theme: theme,
          onTap: () => controller.goToTheme(theme),
          onDetails: () => controller.showThemeDetails(theme),
        ).animate(delay: (index * 50).ms).slideX().fadeIn();
      },
    ));
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final ThemeModel theme;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  const _ThemeCard({
    required this.theme,
    required this.onTap,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: theme.isLocked ? onDetails : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Order number and difficulty
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.isLocked
                      ? Colors.grey.withOpacity(0.3)
                      : AppHelpers.getDifficultyColor(theme.difficulty).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.isLocked
                        ? Colors.grey.withOpacity(0.5)
                        : AppHelpers.getDifficultyColor(theme.difficulty),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        theme.order.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.isLocked
                              ? Colors.grey
                              : AppHelpers.getDifficultyColor(theme.difficulty),
                        ),
                      ),
                    ),
                    if (theme.isLocked)
                      const Positioned(
                        top: 2,
                        right: 2,
                        child: Icon(Icons.lock, size: 12, color: Colors.grey),
                      ),
                    if (theme.isCompleted)
                      const Positioned(
                        top: 2,
                        right: 2,
                        child: Icon(Icons.check_circle, size: 12, color: Colors.green),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            theme.title,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: theme.isLocked ? Colors.grey : null,
                            ),
                          ),
                        ),
                        if (theme.hasMultimedia) ...[
                          if (theme.hasAudio)
                            Icon(Icons.volume_up, size: 16, color: Colors.grey[600]),
                          if (theme.hasVideo)
                            Icon(Icons.play_circle, size: 16, color: Colors.grey[600]),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.isLocked ? Colors.grey : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (theme.hasUzbekSummary) ...[
                      const SizedBox(height: 6),
                      Text(
                        theme.uzbekSummary!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.isLocked ? Colors.grey : Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppHelpers.getDifficultyColor(theme.difficulty).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            theme.difficultyInUzbek,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppHelpers.getDifficultyColor(theme.difficulty),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.schedule, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          theme.formattedDuration,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        if (theme.hasKeywords) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.translate, size: 12, color: Colors.grey),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              '${theme.keywords.length} so\'z',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Action button
              IconButton(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline),
                tooltip: 'Batafsil ma\'lumot',
              ),
            ],
          ),
        ),
      ),
    );
  }
}