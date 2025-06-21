import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/colors.dart';
import '../../../utils/helpers.dart';

class ArticleList extends StatelessWidget {
  final ArticleComponentModel component;
  final double fontSize;

  const ArticleList({
    super.key,
    required this.component,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final items = component.listItems;
    final isOrdered = component.isOrderedList;
    final title = component.content['title'];

    if (items.isEmpty) {
      return _buildEmptyList();
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List title
          if (title != null) ...[
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: fontSize * 1.1,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // List items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bullet or number
                  Container(
                    width: 24,
                    child: isOrdered
                        ? Text(
                      '${index + 1}.',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontSize: fontSize * 0.9,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Item content
                  Expanded(
                    child: SelectableText(
                      item,
                      style: _getListItemTextStyle(item).copyWith(
                        fontSize: fontSize,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.list, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            'Bo\'sh ro\'yxat',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getListItemTextStyle(String item) {
    // Use Russian text style if the text contains Cyrillic characters
    if (AppHelpers.isRussianText(item)) {
      return AppTextStyles.russianMedium;
    } else {
      return AppTextStyles.bodyMedium;
    }
  }
}