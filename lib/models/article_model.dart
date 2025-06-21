import 'dart:ui';

import 'article_component_model.dart';

class ArticleModel {
  final String id;
  final String title;
  final String? subtitle;
  final List<ArticleComponentModel> components;
  final ArticleMetadata metadata;

  ArticleModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.components,
    required this.metadata,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      components: (json['components'] as List)
          .map((e) => ArticleComponentModel.fromJson(e))
          .toList(),
      metadata: ArticleMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'components': components.map((e) => e.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }

  // Getters for convenience
  int get componentCount => components.length;
  bool get hasSubtitle => subtitle != null && subtitle!.isNotEmpty;

  // Get components by type
  List<ArticleComponentModel> getComponentsByType(ArticleComponentType type) {
    return components.where((c) => c.type == type).toList();
  }

  // Get component by ID
  ArticleComponentModel? getComponentById(String id) {
    try {
      return components.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get reading time estimate (words per minute)
  int get estimatedReadingTime {
    int wordCount = 0;

    for (final component in components) {
      switch (component.type) {
        case ArticleComponentType.heading:
        case ArticleComponentType.text:
        case ArticleComponentType.quote:
          wordCount += component.textContent.split(' ').length;
          break;
        case ArticleComponentType.list:
          for (final item in component.listItems) {
            wordCount += item.split(' ').length;
          }
          break;
        case ArticleComponentType.table:
          for (final row in component.tableData) {
            for (final cell in row) {
              wordCount += cell.split(' ').length;
            }
          }
          break;
        case ArticleComponentType.code:
        // Code takes longer to read
          wordCount += (component.codeContent.split(' ').length * 1.5).round();
          break;
        default:
        // Other components don't contribute to reading time
          break;
      }
    }

    // Assuming 200 words per minute reading speed
    return (wordCount / 200).ceil();
  }
}

class ArticleMetadata {
  final String author;
  final String readTime;
  final String level;
  final List<String> tags;
  final DateTime? publishDate;
  final DateTime? lastUpdated;
  final String? uzbekExplanation; // Uzbek explanation for this article

  ArticleMetadata({
    required this.author,
    required this.readTime,
    required this.level,
    required this.tags,
    this.publishDate,
    this.lastUpdated,
    this.uzbekExplanation,
  });

  factory ArticleMetadata.fromJson(Map<String, dynamic> json) {
    return ArticleMetadata(
      author: json['author'],
      readTime: json['readTime'],
      level: json['level'],
      tags: List<String>.from(json['tags']),
      publishDate: json['publishDate'] != null
          ? DateTime.parse(json['publishDate'])
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      uzbekExplanation: json['uzbekExplanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'readTime': readTime,
      'level': level,
      'tags': tags,
      'publishDate': publishDate?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'uzbekExplanation': uzbekExplanation,
    };
  }

  // Helper getters
  bool get hasUzbekExplanation =>
      uzbekExplanation != null && uzbekExplanation!.isNotEmpty;

  String get levelInUzbek {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Boshlang\'ich';
      case 'intermediate':
        return 'O\'rta';
      case 'advanced':
        return 'Yuqori';
      default:
        return level;
    }
  }

  Color get levelColor {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50); // Green
      case 'intermediate':
        return const Color(0xFFFFC107); // Amber
      case 'advanced':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }
}