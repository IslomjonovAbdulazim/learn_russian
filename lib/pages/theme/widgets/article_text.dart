import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/helpers.dart';

class ArticleText extends StatelessWidget {
  final ArticleComponentModel component;
  final double fontSize;

  const ArticleText({
    super.key,
    required this.component,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final text = component.textContent;
    final isBold = component.content['isBold'] ?? false;
    final isItalic = component.content['isItalic'] ?? false;
    final alignment = component.content['alignment'];

    return Container(
      width: double.infinity,
      child: SelectableText(
        text,
        style: _getTextStyle().copyWith(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
        textAlign: _getTextAlignment(alignment),
      ),
    );
  }

  TextStyle _getTextStyle() {
    final text = component.textContent;

    // Use Russian text style if the text contains Cyrillic characters
    if (AppHelpers.isRussianText(text)) {
      return AppTextStyles.russianMedium;
    } else {
      return AppTextStyles.bodyMedium;
    }
  }

  TextAlign _getTextAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}