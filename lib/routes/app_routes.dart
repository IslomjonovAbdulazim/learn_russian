class AppRoutes {
  // Route names
  static const String home = '/';
  static const String detailModule = '/detail-module';
  static const String theme = '/theme';
  static const String aiVoice = '/ai-voice';

  // Route parameters
  static const String paramModuleId = 'moduleId';
  static const String paramThemeId = 'themeId';
  static const String paramArticleId = 'articleId';

  // Route builders with parameters
  static String detailModuleRoute(String moduleId) =>
      '$detailModule?$paramModuleId=$moduleId';

  static String themeRoute(String themeId, String articleId) =>
      '$theme?$paramThemeId=$themeId&$paramArticleId=$articleId';

  static String aiVoiceRoute({String? context}) =>
      context != null ? '$aiVoice?context=$context' : aiVoice;
}