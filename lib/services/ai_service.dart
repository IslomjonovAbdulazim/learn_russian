import 'package:get/get.dart';
import 'dart:math';
import '../models/ai_conversation_model.dart';
import '../utils/mock_data.dart';
import 'api_service.dart';
import 'voice_service.dart';

class AIService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  late final VoiceService _voiceService;

  // Observable conversation state
  final _conversations = <AIConversationModel>[].obs;
  final _isProcessing = false.obs;
  final _isConnected = true.obs;
  final _currentContext = ''.obs;

  // Getters
  List<AIConversationModel> get conversations => _conversations;
  bool get isProcessing => _isProcessing.value;
  bool get isConnected => _isConnected.value;
  String get currentContext => _currentContext.value;

  @override
  void onInit() {
    super.onInit();
    _voiceService = Get.find<VoiceService>();
    _loadMockConversations();
    _checkConnection();
  }

  void _loadMockConversations() {
    // Load some sample conversation for demo
    final sampleMessages = MockData.sampleConversation;
    _conversations.assignAll(sampleMessages);
  }

  Future<void> _checkConnection() async {
    try {
      final isConnected = await _apiService.checkConnection();
      _isConnected.value = isConnected;
    } catch (e) {
      _isConnected.value = false;
    }
  }

  // Send message to AI
  Future<void> sendMessage(String message, {bool useVoice = false}) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = AIConversationModel.userMessage(message: message);
    _conversations.add(userMessage);

    // Start processing
    _isProcessing.value = true;

    // Add typing indicator
    final typingMessage = AIConversationModel.typing();
    _conversations.add(typingMessage);

    try {
      String aiResponse;

      if (_isConnected.value) {
        // Try to get response from real API
        final response = await _apiService.sendMessageToAI(
          message,
          context: _currentContext.value,
        );

        if (response.isSuccess && response.data != null) {
          aiResponse = response.data!;
        } else {
          aiResponse = _generateMockResponse(message);
        }
      } else {
        // Generate mock response when offline
        aiResponse = _generateMockResponse(message);
      }

      // Remove typing indicator
      _conversations.removeWhere((msg) => msg.status == ConversationStatus.typing);

      // Add AI response
      final aiMessage = AIConversationModel.aiMessage(message: aiResponse);
      _conversations.add(aiMessage);

      // Speak the response if voice is enabled
      if (useVoice) {
        await _voiceService.speakRussianText(aiResponse);
      }

      // Update context for next message
      _updateContext(message, aiResponse);

    } catch (e) {
      // Remove typing indicator and show error
      _conversations.removeWhere((msg) => msg.status == ConversationStatus.typing);

      final errorMessage = AIConversationModel.error(
        'Xatolik yuz berdi: $e',
      );
      _conversations.add(errorMessage);
    } finally {
      _isProcessing.value = false;
    }
  }

  // Voice message handling
  Future<void> sendVoiceMessage() async {
    if (!_voiceService.isAvailable) {
      final errorMessage = AIConversationModel.error(
        'Mikrofon ruxsati yo\'q yoki qurilma ovozli xabarlarni qo\'llab-quvvatlamaydi',
      );
      _conversations.add(errorMessage);
      return;
    }

    try {
      // Listen for user speech
      final spokenText = await _voiceService.listenForRussian();

      if (spokenText != null && spokenText.isNotEmpty) {
        await sendMessage(spokenText, useVoice: true);
      }
    } catch (e) {
      final errorMessage = AIConversationModel.error(
        'Ovozli xabar olishda xatolik: $e',
      );
      _conversations.add(errorMessage);
    }
  }

  // Generate mock responses for offline mode or fallback
  String _generateMockResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // Russian greeting responses
    if (message.contains('привет') || message.contains('здравствуй')) {
      return 'Привет! Рад тебя видеть! Как дела с изучением русского языка?';
    }

    // Help with grammar
    if (message.contains('как') && message.contains('сказать')) {
      return 'Отличный вопрос! В русском языке это можно сказать несколькими способами. Давайте разберем каждый вариант.';
    }

    // Questions about difference
    if (message.contains('разниц') || message.contains('отличие')) {
      return 'Хороший вопрос! Разница действительно есть. Давайте я объясню простыми словами с примерами.';
    }

    // Pronunciation help
    if (message.contains('произнош') || message.contains('говорить')) {
      return 'Произношение - это важная часть изучения языка. Повторяйте за мной медленно и четко.';
    }

    // Questions about cases
    if (message.contains('падеж') || message.contains('окончан')) {
      return 'Падежи в русском языке - это основа грамматики. Не волнуйтесь, мы изучим их постепенно с простыми примерами.';
    }

    // General learning questions
    if (message.contains('как учить') || message.contains('изучать')) {
      return 'Лучший способ изучения языка - это регулярная практика. Читайте, слушайте, говорите каждый день понемногу.';
    }

    // Compliments
    if (message.contains('хорошо') || message.contains('спасибо')) {
      return 'Пожалуйста! Вы отлично справляетесь. Продолжайте в том же духе!';
    }

    // Default responses
    final defaultResponses = [
      'Интересный вопрос! Могу объяснить это подробнее. В русском языке...',
      'Да, это важная тема. Давайте разберем это вместе.',
      'Хорошо, что вы спросили! Это поможет вам лучше понять русский язык.',
      'Отлично! Вижу, что вы внимательно изучаете материал. Продолжайте!',
      'Это частый вопрос у изучающих русский язык. Объясню простыми словами.',
    ];

    final random = Random();
    return defaultResponses[random.nextInt(defaultResponses.length)];
  }

  void _updateContext(String userMessage, String aiResponse) {
    // Keep context short for better performance
    final newContext = '$userMessage\n$aiResponse';
    if (_currentContext.value.length > 500) {
      // Trim old context
      final lines = _currentContext.value.split('\n');
      _currentContext.value = lines.skip(2).join('\n');
    }
    _currentContext.value += '\n$newContext';
  }

  // Conversation management
  void clearConversation() {
    _conversations.clear();
    _currentContext.value = '';
  }

  void removeMessage(String messageId) {
    _conversations.removeWhere((msg) => msg.id == messageId);
  }

  // Play message audio
  Future<void> playMessageAudio(String messageId) async {
    final message = _conversations.firstWhereOrNull((msg) => msg.id == messageId);
    if (message != null && !message.isUser) {
      await _voiceService.speakRussianText(message.message);
    }
  }

  // Quick responses for common learning scenarios
  Future<void> sendQuickResponse(QuickResponseType type) async {
    String message;

    switch (type) {
      case QuickResponseType.explain:
        message = 'Можешь объяснить это подробнее?';
        break;
      case QuickResponseType.repeat:
        message = 'Повтори, пожалуйста';
        break;
      case QuickResponseType.slower:
        message = 'Говори помедленнее, пожалуйста';
        break;
      case QuickResponseType.example:
        message = 'Дай пример, пожалуйста';
        break;
      case QuickResponseType.translate:
        message = 'Как это переводится?';
        break;
    }

    await sendMessage(message, useVoice: true);
  }

  // Learning context methods
  void setLearningContext(String moduleTitle, String themeTitle) {
    _currentContext.value = 'Пользователь изучает модуль "$moduleTitle", тема "$themeTitle". Помоги с изучением этой темы.';
  }

  void clearLearningContext() {
    _currentContext.value = '';
  }

  // Statistics
  int get messageCount => _conversations.length;
  int get userMessageCount => _conversations.where((msg) => msg.isUser).length;
  int get aiMessageCount => _conversations.where((msg) => !msg.isUser).length;

  AIConversationModel? get lastMessage =>
      _conversations.isNotEmpty ? _conversations.last : null;
}

enum QuickResponseType {
  explain,
  repeat,
  slower,
  example,
  translate,
}