class ModuleModel {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji or icon name
  final String level; // beginner, intermediate, advanced
  final int themeCount;
  final String category;
  final String? uzbekDescription; // Uzbek explanation of the module
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final bool isLocked;
  final List<String> prerequisites; // Required module IDs

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.level,
    required this.themeCount,
    required this.category,
    this.uzbekDescription,
    this.progress = 0.0,
    this.isCompleted = false,
    this.isLocked = false,
    this.prerequisites = const [],
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      level: json['level'],
      themeCount: json['themeCount'],
      category: json['category'],
      uzbekDescription: json['uzbekDescription'],
      progress: (json['progress'] ?? 0.0).toDouble(),
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'level': level,
      'themeCount': themeCount,
      'category': category,
      'uzbekDescription': uzbekDescription,
      'progress': progress,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
      'prerequisites': prerequisites,
    };
  }

  // Copy with method for updating progress
  ModuleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? level,
    int? themeCount,
    String? category,
    String? uzbekDescription,
    double? progress,
    bool? isCompleted,
    bool? isLocked,
    List<String>? prerequisites,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      level: level ?? this.level,
      themeCount: themeCount ?? this.themeCount,
      category: category ?? this.category,
      uzbekDescription: uzbekDescription ?? this.uzbekDescription,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }

  // Helper getters
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

  String get categoryInUzbek {
    switch (category.toLowerCase()) {
      case 'basics':
        return 'Asoslar';
      case 'vocabulary':
        return 'So\'z boyligi';
      case 'grammar':
        return 'Grammatika';
      case 'conversation':
        return 'Suhbat';
      case 'reading':
        return 'O\'qish';
      case 'writing':
        return 'Yozish';
      case 'pronunciation':
        return 'Talaffuz';
      case 'culture':
        return 'Madaniyat';
      default:
        return category;
    }
  }

  bool get hasUzbekDescription =>
      uzbekDescription != null && uzbekDescription!.isNotEmpty;

  bool get isStarted => progress > 0.0;

  bool get hasPrerequisites => prerequisites.isNotEmpty;

  String get progressText {
    if (isCompleted) return 'Tugallangan';
    if (!isStarted) return 'Boshlanmagan';
    return '${(progress * 100).round()}% tugallangan';
  }

  int get completedThemes => (themeCount * progress).round();

  String get durationEstimate {
    // Estimate based on theme count (assuming 15 minutes per theme)
    final minutes = themeCount * 15;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      if (remainingMinutes > 0) {
        return '${hours}s ${remainingMinutes}d';
      } else {
        return '${hours}s';
      }
    } else {
      return '${minutes}d';
    }
  }
}

// Module categories enum for type safety
enum ModuleCategory {
  basics,
  vocabulary,
  grammar,
  conversation,
  reading,
  writing,
  pronunciation,
  culture,
}

extension ModuleCategoryExtension on ModuleCategory {
  String get name {
    switch (this) {
      case ModuleCategory.basics:
        return 'basics';
      case ModuleCategory.vocabulary:
        return 'vocabulary';
      case ModuleCategory.grammar:
        return 'grammar';
      case ModuleCategory.conversation:
        return 'conversation';
      case ModuleCategory.reading:
        return 'reading';
      case ModuleCategory.writing:
        return 'writing';
      case ModuleCategory.pronunciation:
        return 'pronunciation';
      case ModuleCategory.culture:
        return 'culture';
    }
  }

  String get uzbekName {
    switch (this) {
      case ModuleCategory.basics:
        return 'Asoslar';
      case ModuleCategory.vocabulary:
        return 'So\'z boyligi';
      case ModuleCategory.grammar:
        return 'Grammatika';
      case ModuleCategory.conversation:
        return 'Suhbat';
      case ModuleCategory.reading:
        return 'O\'qish';
      case ModuleCategory.writing:
        return 'Yozish';
      case ModuleCategory.pronunciation:
        return 'Talaffuz';
      case ModuleCategory.culture:
        return 'Madaniyat';
    }
  }

  String get icon {
    switch (this) {
      case ModuleCategory.basics:
        return '🔤';
      case ModuleCategory.vocabulary:
        return '📚';
      case ModuleCategory.grammar:
        return '📝';
      case ModuleCategory.conversation:
        return '💬';
      case ModuleCategory.reading:
        return '📖';
      case ModuleCategory.writing:
        return '✍️';
      case ModuleCategory.pronunciation:
        return '🗣️';
      case ModuleCategory.culture:
        return '🏛️';
    }
  }
}