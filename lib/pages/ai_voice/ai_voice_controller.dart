import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../services/voice_service.dart';
import '../../models/ai_conversation_model.dart';
import '../../utils/helpers.dart';

class AIVoiceController extends GetxController with GetTickerProviderStateMixin {
  final AIService _aiService = Get.find<AIService>();
  final VoiceService _voiceService = Get.find<VoiceService>();

  // Animation controllers
  late AnimationController voiceCircleController;
  late AnimationController waveController;
  late AnimationController pulseController;

  // UI Controllers
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observable states
  final _isVoiceMode = true.obs;
  final _isRecording = false.obs;
  final _showTextInput = false.obs;
  final _isTyping = false.obs;

  // Getters
  bool get isVoiceMode => _isVoiceMode.value;
  bool get isRecording => _isRecording.value;
  bool get showTextInput => _showTextInput.value;
  bool get isTyping => _isTyping.value;

  // Voice service getters
  bool get isListening => _voiceService.isListening;
  bool get isSpeaking => _voiceService.isSpeaking;
  bool get isProcessing => _aiService.isProcessing;
  double get voiceLevel => _voiceService.voiceLevel;

  // AI service getters
  List<AIConversationModel> get conversations => _aiService.conversations;
  bool get isConnected => _aiService.isConnected;

  // Status getters
  bool get isActive => isListening || isSpeaking || isProcessing;
  String get statusText {
    if (!isConnected) return 'Internet aloqasi yo\'q';
    if (isProcessing) return 'Javob tayyorlanmoqda...';
    if (isSpeaking) return 'AI gapirmoqda...';
    if (isListening) return 'Tinglamoqda...';
    return 'Gapirish uchun tugmani bosing';
  }

  @override
  void onInit() {
    super.onInit();
    _initAnimationControllers();
    _checkVoicePermissions();
    _setupTextListener();
  }

  @override
  void onReady() {
    super.onReady();
    _scrollToBottom();
  }

  @override
  void onClose() {
    voiceCircleController.dispose();
    waveController.dispose();
    pulseController.dispose();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _initAnimationControllers() {
    voiceCircleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Start continuous wave animation
    waveController.repeat();
  }

  Future<void> _checkVoicePermissions() async {
    final hasPermission = await _voiceService.requestPermission();
    if (!hasPermission) {
      AppHelpers.showSnackbar(
        title: 'Ruxsat kerak',
        message: 'Ovozli suhbat uchun mikrofon ruxsati kerak',
        type: SnackbarType.warning,
      );
    }
  }

  void _setupTextListener() {
    textController.addListener(() {
      _isTyping.value = textController.text.isNotEmpty;
    });
  }

  // Voice interaction methods
  Future<void> startVoiceInteraction() async {
    if (!_voiceService.isAvailable) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Ovozli xizmat mavjud emas',
        type: SnackbarType.error,
      );
      return;
    }

    if (isActive) {
      await stopVoiceInteraction();
      return;
    }

    try {
      _isRecording.value = true;
      voiceCircleController.forward();
      pulseController.repeat();

      await _aiService.sendVoiceMessage();

    } catch (e) {
      AppHelpers.showSnackbar(
        title: 'Xatolik',
        message: 'Ovozli xabar yuborishda xatolik',
        type: SnackbarType.error,
      );
    } finally {
      _isRecording.value = false;
      voiceCircleController.reverse();
      pulseController.stop();
    }
  }

  Future<void> stopVoiceInteraction() async {
    _isRecording.value = false;
    voiceCircleController.reverse();
    pulseController.stop();

    await _voiceService.stopListening();
    await _voiceService.stopSpeaking();
  }

  // Text interaction methods
  void toggleInputMode() {
    _isVoiceMode.value = !_isVoiceMode.value;
    _showTextInput.value = !_isVoiceMode.value;

    if (_isVoiceMode.value) {
      textController.clear();
    }
  }

  Future<void> sendTextMessage() async {
    final message = textController.text.trim();
    if (message.isEmpty) return;

    textController.clear();
    _isTyping.value = false;

    await _aiService.sendMessage(message, useVoice: false);
    _scrollToBottom();
  }

  // Quick response methods
  Future<void> sendQuickResponse(QuickResponseType type) async {
    await _aiService.sendQuickResponse(type);
    _scrollToBottom();
  }

  // Message management
  void clearConversation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Suhbatni tozalash'),
        content: const Text('Barcha xabarlar o\'chiriladi. Davom etasizmi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              _aiService.clearConversation();
              Get.back();
              AppHelpers.showSnackbar(
                title: 'Tozalandi',
                message: 'Suhbat tozalandi',
                type: SnackbarType.success,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('O\'chirish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> playMessageAudio(String messageId) async {
    await _aiService.playMessageAudio(messageId);
  }

  void removeMessage(String messageId) {
    _aiService.removeMessage(messageId);
  }

  // UI helper methods
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline),
            SizedBox(width: 8),
            Text('AI Yordam'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Qanday savol berishim mumkin?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildHelpItem('🗣️', 'Talaffuz yordam', 'Qanday talaffuz qilaman?'),
            _buildHelpItem('📚', 'Grammatika', 'Bu qoida qanday ishlaydi?'),
            _buildHelpItem('📝', 'Tarjima', 'Bu so\'z nima degani?'),
            _buildHelpItem('💡', 'Tushuntirish', 'Buni tushuntirib bering'),
            _buildHelpItem('🎯', 'Misol', 'Misol keltiring'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Yopish'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String emoji, String title, String example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  example,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showVoiceSettings() {
    AppHelpers.showBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ovoz sozlamalari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Voice mode toggle
            SwitchListTile(
              title: const Text('Ovozli rejim'),
              subtitle: const Text('Ovoz bilan muloqot qiling'),
              value: isVoiceMode,
              onChanged: (_) => toggleInputMode(),
            ),

            const SizedBox(height: 16),

            // Quick responses
            const Text('Tez javoblar:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickResponseChip('Tushuntiring', QuickResponseType.explain),
                _buildQuickResponseChip('Takrorlang', QuickResponseType.repeat),
                _buildQuickResponseChip('Sekinroq', QuickResponseType.slower),
                _buildQuickResponseChip('Misol', QuickResponseType.example),
                _buildQuickResponseChip('Tarjima', QuickResponseType.translate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickResponseChip(String label, QuickResponseType type) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        Get.back();
        sendQuickResponse(type);
      },
    );
  }

  // Connection management
  void retryConnection() {
    // Implement connection retry logic
    AppHelpers.showSnackbar(
      title: 'Qayta urinish',
      message: 'Aloqa qayta tiklanmoqda...',
      type: SnackbarType.info,
    );
  }
}