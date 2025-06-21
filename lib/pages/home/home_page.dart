import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/module_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/helpers.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading
            ? const _LoadingWidget()
            : const _HomeContent()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAIChat,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ).animate().scale(delay: 600.ms),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Ma\'lumotlar yuklanmoqda...'),
        ],
      ),
    );
  }
}

class _HomeContent extends GetView<HomeController> {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildProgressSection(),
          _buildCategoryFilter(),
          _buildFeaturedSection(),
          _buildModulesSection(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Rus tili o\'rganish',
          style: AppTextStyles.heading4.copyWith(color: Colors.white),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 16,
                child: IconButton(
                  onPressed: controller.showThemeSelector,
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          onChanged: controller.updateSearchQuery,
          decoration: InputDecoration(
            hintText: 'Modullarni qidirish...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                ? IconButton(
              onPressed: () => controller.updateSearchQuery(''),
              icon: const Icon(Icons.clear),
            )
                : IconButton(
              onPressed: controller.toggleViewMode,
              icon: Icon(controller.isGridView
                  ? Icons.view_list
                  : Icons.grid_view),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.inProgressModules.isEmpty &&
            controller.completedModules == 0) {
          return const SizedBox.shrink();
        }

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
                value: controller.overallProgress,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                controller.progressText,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Obx(() => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory == category;
            final displayName = controller.getCategoryDisplayName(category);

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(displayName),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(category),
                backgroundColor: AppColors.lightSurface,
                selectedColor: AppColors.primaryBlue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                ),
              ),
            );
          },
        )),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final featured = controller.featuredModules;
        if (featured.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tavsiya etilgan',
                style: AppTextStyles.heading4,
              ),
            ),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final module = featured[index];
                  return _FeaturedModuleCard(
                    module: module,
                    onTap: () => controller.goToModule(module),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildModulesSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Barcha modullar',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 16),
            Obx(() => controller.isGridView
                ? _buildModulesGrid()
                : _buildModulesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesGrid() {
    return Obx(() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.filteredModules.length,
      itemBuilder: (context, index) {
        final module = controller.filteredModules[index];
        return _ModuleGridCard(
          module: module,
          onTap: () => controller.goToModule(module),
          onDetails: () => controller.showModuleDetails(module),
        );
      },
    ));
  }

  Widget _buildModulesList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filteredModules.length,
      itemBuilder: (context, index) {
        final module = controller.filteredModules[index];
        return _ModuleListCard(
          module: module,
          onTap: () => controller.goToModule(module),
          onDetails: () => controller.showModuleDetails(module),
        );
      },
    ));
  }
}

class _FeaturedModuleCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onTap;

  const _FeaturedModuleCard({
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: module.isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: module.isLocked ? null : AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      module.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    if (module.isLocked)
                      const Icon(Icons.lock, color: Colors.grey, size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  module.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: module.isLocked ? null : Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  '${module.themeCount} mavzu',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: module.isLocked ? Colors.grey : Colors.white70,
                  ),
                ),
                if (module.isStarted) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: module.progress,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleGridCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  const _ModuleGridCard({
    required this.module,
    required this.onTap,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: module.isLocked ? onDetails : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(module.icon, style: const TextStyle(fontSize: 28)),
                  const Spacer(),
                  if (module.isLocked)
                    const Icon(Icons.lock, color: Colors.grey, size: 16)
                  else if (module.isCompleted)
                    const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  IconButton(
                    onPressed: onDetails,
                    icon: const Icon(Icons.info_outline, size: 16),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                module.title,
                style: AppTextStyles.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                module.levelInUzbek,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppHelpers.getDifficultyColor(
                      module.level == 'beginner' ? 1 :
                      module.level == 'intermediate' ? 3 : 5
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${module.themeCount} mavzu',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
              if (module.isStarted) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(value: module.progress),
                const SizedBox(height: 4),
                Text(
                  AppHelpers.formatProgress(module.progress),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleListCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  const _ModuleListCard({
    required this.module,
    required this.onTap,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: module.isLocked ? onDetails : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppHelpers.getModuleColor(module.hashCode % 6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    module.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            module.title,
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                        if (module.isLocked)
                          const Icon(Icons.lock, color: Colors.grey, size: 16)
                        else if (module.isCompleted)
                          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppHelpers.getDifficultyColor(
                                module.level == 'beginner' ? 1 :
                                module.level == 'intermediate' ? 3 : 5
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            module.levelInUzbek,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppHelpers.getDifficultyColor(
                                  module.level == 'beginner' ? 1 :
                                  module.level == 'intermediate' ? 3 : 5
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${module.themeCount} mavzu',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          module.durationEstimate,
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    if (module.isStarted) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: module.progress),
                      const SizedBox(height: 4),
                      Text(
                        module.progressText,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}