class AppConstants {
  // App Info
  static const String appName = 'Rus Tili';
  static const String appVersion = '1.0.0';

  // API URLs (for future use)
  static const String baseUrl = 'https://api.rustili.uz';
  static const String aiChatUrl = '$baseUrl/ai/chat';
  static const String voiceUrl = '$baseUrl/voice';

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyProgress = 'user_progress';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Voice Settings
  static const double voicePitch = 1.0;
  static const double voiceRate = 0.5;
  static const String voiceLanguage = 'ru-RU';

  // Difficulty Levels
  static const Map<int, String> difficultyMap = {
    1: 'Oson', // Easy in Uzbek
    2: 'O\'rtacha', // Medium
    3: 'Qiyin', // Hard
    4: 'Juda qiyin', // Very Hard
    5: 'Murakkab', // Complex
  };

  // Module Categories (in Uzbek)
  static const List<String> moduleCategories = [
    'Asoslar',        // Basics
    'So\'zlar',       // Words
    'Grammatika',     // Grammar
    'Suhbat',         // Conversation
    'O\'qish',        // Reading
    'Yozish',         // Writing
  ];

  // UI Labels (Uzbek interface)
  static const String homeTitle = 'Rus tili o\'rganish';
  static const String modulesTitle = 'Modullar';
  static const String themesTitle = 'Mavzular';
  static const String aiChatTitle = 'AI Yordamchi';
  static const String backButton = 'Orqaga';
  static const String nextButton = 'Keyingi';
  static const String startButton = 'Boshlash';
  static const String continueButton = 'Davom etish';
  static const String retryButton = 'Qayta urinish';
  static const String doneButton = 'Tugallangan';

  // Article Component Labels
  static const String readingTime = 'O\'qish vaqti';
  static const String difficulty = 'Qiyinlik darajasi';
  static const String author = 'Muallif';
  static const String tags = 'Teglar';

  // AI Voice Labels
  static const String listening = 'Tinglamoqda...';
  static const String speaking = 'Gapirmoqda...';
  static const String processing = 'Ishlanmoqda...';
  static const String tapToSpeak = 'Gapirish uchun bosing';
  static const String tapToStop = 'To\'xtatish uchun bosing';

  // Error Messages
  static const String networkError = 'Internet aloqasi yo\'q';
  static const String voiceError = 'Ovozni tanib bo\'lmadi';
  static const String aiError = 'AI xizmati ishlamayapti';
  static const String generalError = 'Xatolik yuz berdi';
}