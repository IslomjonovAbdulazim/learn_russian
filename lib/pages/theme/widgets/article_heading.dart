import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/colors.dart';

class ArticleHeading extends StatelessWidget {
  final ArticleComponentModel component;
  final double fontSize;

  const ArticleHeading({
    super.key,
    required this.component,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final level = component.headingLevel;
    final text = component.textContent;
    final anchor = component.content['anchor'];

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add spacing before heading (except for h1)
          if (level > 1) SizedBox(height: _getTopSpacing(level)),

          SelectableText(
            text,
            style: _getHeadingStyle(level).copyWith(
              fontSize: _getFontSize(level),
            ),
          ),

          // Add underline for h1 and h2
          if (level <= 2) ...[
            const SizedBox(height: 8),
            Container(
              height: level == 1 ? 3 : 2,
              width: level == 1 ? double.infinity : 60,
              decoration: BoxDecoration(
                gradient: level == 1
                    ? AppColors.primaryGradient
                    : LinearGradient(
                  colors: [AppColors.primaryBlue, Colors.transparent],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],

          // Add spacing after heading
          SizedBox(height: _getBottomSpacing(level)),
        ],
      ),
    );
  }

  TextStyle _getHeadingStyle(int level) {
    switch (level) {
      case 1:
        return AppTextStyles.heading1.copyWith(
          color: AppColors.primaryBlueDark,
          height: 1.2,
        );
      case 2:
        return AppTextStyles.heading2.copyWith(
          color: AppColors.primaryBlueDark,
          height: 1.3,
        );
      case 3:
        return AppTextStyles.heading3.copyWith(
          color: AppColors.primaryBlue,
          height: 1.3,
        );
      case 4:
        return AppTextStyles.heading4.copyWith(
          color: AppColors.primaryBlue,
          height: 1.4,
        );
      case 5:
        return AppTextStyles.heading5.copyWith(
          color: AppColors.primaryBlue,
          height: 1.4,
        );
      default:
        return AppTextStyles.heading5.copyWith(
          color: AppColors.primaryBlue,
          height: 1.4,
        );
    }
  }

  double _getFontSize(int level) {
    final baseSize = fontSize;

    switch (level) {
      case 1:
        return baseSize * 2.0;
      case 2:
        return baseSize * 1.75;
      case 3:
        return baseSize * 1.5;
      case 4:
        return baseSize * 1.25;
      case 5:
        return baseSize * 1.125;
      default:
        return baseSize * 1.125;
    }
  }

  double _getTopSpacing(int level) {
    switch (level) {
      case 2:
        return 24.0;
      case 3:
        return 20.0;
      case 4:
        return 16.0;
      case 5:
        return 12.0;
      default:
        return 12.0;
    }
  }

  double _getBottomSpacing(int level) {
    switch (level) {
      case 1:
        return 16.0;
      case 2:
        return 12.0;
      case 3:
        return 10.0;
      case 4:
        return 8.0;
      case 5:
        return 6.0;
      default:
        return 6.0;
    }
  }
}