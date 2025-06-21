class ThemeModel {
  final String id;
  final String moduleId;
  final String title;
  final String subtitle;
  final String duration;
  final int difficulty; // 1-5
  final String articleId;
  final int order; // Order within the module
  final bool isCompleted;
  final bool isLocked;
  final String? uzbekSummary; // Brief Uzbek explanation
  final List<String> keywords; // Key Russian words in this theme
  final String? audioUrl; // Optional audio pronunciation
  final String? videoUrl; // Optional video content

  ThemeModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.difficulty,
    required this.articleId,
    required this.order,
    this.isCompleted = false,
    this.isLocked = false,
    this.uzbekSummary,
    this.keywords = const [],
    this.audioUrl,
    this.videoUrl,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'],
      moduleId: json['moduleId'],
      title: json['title'],
      subtitle: json['subtitle'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      articleId: json['articleId'],
      order: json['order'],
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
      uzbekSummary: json['uzbekSummary'],
      keywords: List<String>.from(json['keywords'] ?? []),
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'subtitle': subtitle,
      'duration': duration,
      'difficulty': difficulty,
      'articleId': articleId,
      'order': order,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
      'uzbekSummary': uzbekSummary,
      'keywords': keywords,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
    };
  }

  // Copy with method for updating completion status
  ThemeModel copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? subtitle,
    String? duration,
    int? difficulty,
    String? articleId,
    int? order,
    bool? isCompleted,
    bool? isLocked,
    String? uzbekSummary,
    List<String>? keywords,
    String? audioUrl,
    String? videoUrl,
  }) {
    return ThemeModel(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      articleId: articleId ?? this.articleId,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      uzbekSummary: uzbekSummary ?? this.uzbekSummary,
      keywords: keywords ?? this.keywords,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  // Helper getters
  String get difficultyInUzbek {
    switch (difficulty) {
      case 1:
        return 'Juda oson';
      case 2:
        return 'Oson';
      case 3:
        return 'O\'rtacha';
      case 4:
        return 'Qiyin';
      case 5:
        return 'Juda qiyin';
      default:
        return 'Noma\'lum';
    }
  }

  bool get hasUzbekSummary =>
      uzbekSummary != null && uzbekSummary!.isNotEmpty;

  bool get hasKeywords => keywords.isNotEmpty;

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  bool get hasMultimedia => hasAudio || hasVideo;

  String get statusText {
    if (isCompleted) return 'Tugallangan';
    if (isLocked) return 'Qulflangan';
    return 'Mavjud';
  }

  String get keywordsText {
    if (keywords.isEmpty) return '';
    return keywords.join(', ');
  }

  // Get estimated reading time in minutes
  int get estimatedMinutes {
    // Extract number from duration string (e.g., "15 min" -> 15)
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(duration);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 15;
    }
    return 15; // default
  }

  // Format duration for display
  String get formattedDuration {
    final minutes = estimatedMinutes;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
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

// Theme difficulty enum for type safety
enum ThemeDifficulty {
  veryEasy(1, 'Juda oson'),
  easy(2, 'Oson'),
  medium(3, 'O\'rtacha'),
  hard(4, 'Qiyin'),
  veryHard(5, 'Juda qiyin');

  const ThemeDifficulty(this.level, this.uzbekName);

  final int level;
  final String uzbekName;

  static ThemeDifficulty fromLevel(int level) {
    switch (level) {
      case 1:
        return ThemeDifficulty.veryEasy;
      case 2:
        return ThemeDifficulty.easy;
      case 3:
        return ThemeDifficulty.medium;
      case 4:
        return ThemeDifficulty.hard;
      case 5:
        return ThemeDifficulty.veryHard;
      default:
        return ThemeDifficulty.medium;
    }
  }
}