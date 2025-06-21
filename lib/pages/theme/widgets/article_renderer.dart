import 'package:flutter/material.dart';
import '../../../models/article_model.dart';
import '../../../models/article_component_model.dart';
import 'article_heading.dart';
import 'article_text.dart';
import 'article_quote.dart';
import 'article_table.dart';
import 'article_list.dart';
import 'article_image.dart';

class ArticleRenderer extends StatelessWidget {
  final ArticleModel article;
  final double fontSize;
  final EdgeInsets? padding;

  const ArticleRenderer({
    super.key,
    required this.article,
    this.fontSize = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Render each component
          ...article.components.asMap().entries.map((entry) {
            final index = entry.key;
            final component = entry.value;

            return Container(
              margin: EdgeInsets.only(
                bottom: _getComponentSpacing(component.type),
              ),
              child: _buildComponent(context, component, index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildComponent(BuildContext context, ArticleComponentModel component, int index) {
    switch (component.type) {
      case ArticleComponentType.heading:
        return ArticleHeading(
          component: component,
          fontSize: fontSize,
        );

      case ArticleComponentType.text:
        return ArticleText(
          component: component,
          fontSize: fontSize,
        );

      case ArticleComponentType.quote:
        return ArticleQuote(
          component: component,
          fontSize: fontSize,
        );

      case ArticleComponentType.table:
        return ArticleTable(
          component: component,
          fontSize: fontSize,
        );

      case ArticleComponentType.list:
        return ArticleList(
          component: component,
          fontSize: fontSize,
        );

      case ArticleComponentType.image:
        return ArticleImage(
          component: component,
        );

      case ArticleComponentType.divider:
        return _buildDivider(component);

      case ArticleComponentType.code:
        return _buildCodeBlock(component);

      default:
        return _buildUnsupportedComponent(component);
    }
  }

  Widget _buildDivider(ArticleComponentModel component) {
    final thickness = component.content['thickness']?.toDouble() ?? 1.0;
    final style = component.content['style'] ?? 'solid';

    return Container(
      height: thickness,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(thickness / 2),
      ),
    );
  }

  Widget _buildCodeBlock(ArticleComponentModel component) {
    final code = component.codeContent;
    final language = component.codeLanguage;
    final title = component.content['title'];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.code, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (language != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        language.toUpperCase(),
                        style: TextStyle(
                          fontSize: fontSize * 0.7,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: fontSize * 0.9,
                height: 1.4,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedComponent(ArticleComponentModel component) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qo\'llab-quvvatlanmaydigan komponent',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
                Text(
                  'Turi: ${component.type.toString().split('.').last}',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getComponentSpacing(ArticleComponentType type) {
    switch (type) {
      case ArticleComponentType.heading:
        return 24.0;
      case ArticleComponentType.text:
        return 16.0;
      case ArticleComponentType.quote:
        return 20.0;
      case ArticleComponentType.table:
        return 20.0;
      case ArticleComponentType.list:
        return 16.0;
      case ArticleComponentType.image:
        return 20.0;
      case ArticleComponentType.divider:
        return 24.0;
      case ArticleComponentType.code:
        return 20.0;
      default:
        return 16.0;
    }
  }
}