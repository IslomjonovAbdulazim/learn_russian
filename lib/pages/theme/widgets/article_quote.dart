import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/colors.dart';
import '../../../utils/helpers.dart';

class ArticleQuote extends StatelessWidget {
  final ArticleComponentModel component;
  final double fontSize;

  const ArticleQuote({
    super.key,
    required this.component,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final text = component.textContent;
    final author = component.author;
    final source = component.content['source'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: AppColors.primaryBlue,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote,
            color: AppColors.primaryBlue.withOpacity(0.7),
            size: 32,
          ),

          const SizedBox(height: 8),

          // Quote text
          SelectableText(
            text,
            style: _getQuoteTextStyle().copyWith(
              fontSize: fontSize * 1.1,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Author and source
          if (author != null || source != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 1,
                  color: AppColors.primaryBlue.withOpacity(0.5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (author != null)
                        Text(
                          author,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontSize: fontSize * 0.9,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (source != null)
                        Text(
                          source,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: fontSize * 0.8,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  TextStyle _getQuoteTextStyle() {
    final text = component.textContent;

    // Use Russian text style if the text contains Cyrillic characters
    if (AppHelpers.isRussianText(text)) {
      return AppTextStyles.russianMedium.copyWith(
        color: AppColors.primaryBlueDark,
      );
    } else {
      return AppTextStyles.quote.copyWith(
        color: AppColors.primaryBlueDark,
      );
    }
  }
}