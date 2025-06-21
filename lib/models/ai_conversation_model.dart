class AIConversationModel {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isPlaying;
  final String? audioUrl;
  final ConversationStatus status;
  final String? errorMessage;

  AIConversationModel({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isPlaying = false,
    this.audioUrl,
    this.status = ConversationStatus.completed,
    this.errorMessage,
  });

  factory AIConversationModel.fromJson(Map<String, dynamic> json) {
    return AIConversationModel(
      id: json['id'],
      message: json['message'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      isPlaying: json['isPlaying'] ?? false,
      audioUrl: json['audioUrl'],
      status: ConversationStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
        orElse: () => ConversationStatus.completed,
      ),
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isPlaying': isPlaying,
      'audioUrl': audioUrl,
      'status': status.toString().split('.').last,
      'errorMessage': errorMessage,
    };
  }

  AIConversationModel copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    bool? isPlaying,
    String? audioUrl,
    ConversationStatus? status,
    String? errorMessage,
  }) {
    return AIConversationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isPlaying: isPlaying ?? this.isPlaying,
      audioUrl: audioUrl ?? this.audioUrl,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Helper getters
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get isCompleted => status == ConversationStatus.completed;
  bool get isProcessing => status == ConversationStatus.processing;
  bool get hasError => status == ConversationStatus.error;
  bool get isTyping => status == ConversationStatus.typing;

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Hozir';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}d oldin';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}s oldin';
    } else {
      return '${difference.inDays}k oldin';
    }
  }

  // Factory constructors for different message types
  factory AIConversationModel.userMessage({
    required String message,
    String? audioUrl,
  }) {
    return AIConversationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
      audioUrl: audioUrl,
      status: ConversationStatus.completed,
    );
  }

  factory AIConversationModel.aiMessage({
    required String message,
    String? audioUrl,
  }) {
    return AIConversationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: false,
      timestamp: DateTime.now(),
      audioUrl: audioUrl,
      status: ConversationStatus.completed,
    );
  }

  factory AIConversationModel.processing() {
    return AIConversationModel(
      id: 'processing_${DateTime.now().millisecondsSinceEpoch}',
      message: '',
      isUser: false,
      timestamp: DateTime.now(),
      status: ConversationStatus.processing,
    );
  }

  factory AIConversationModel.typing() {
    return AIConversationModel(
      id: 'typing_${DateTime.now().millisecondsSinceEpoch}',
      message: '',
      isUser: false,
      timestamp: DateTime.now(),
      status: ConversationStatus.typing,
    );
  }

  factory AIConversationModel.error(String errorMessage) {
    return AIConversationModel(
      id: 'error_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Xatolik yuz berdi',
      isUser: false,
      timestamp: DateTime.now(),
      status: ConversationStatus.error,
      errorMessage: errorMessage,
    );
  }
}

enum ConversationStatus {
  typing,
  processing,
  completed,
  error,
  speaking,
  listening,
}

class AIVoiceState {
  final bool isListening;
  final bool isSpeaking;
  final bool isProcessing;
  final bool isConnected;
  final List<AIConversationModel> messages;
  final String? currentSpeechText;
  final double voiceLevel; // 0.0 to 1.0 for voice visualization
  final String? lastError;

  AIVoiceState({
    this.isListening = false,
    this.isSpeaking = false,
    this.isProcessing = false,
    this.isConnected = true,
    this.messages = const [],
    this.currentSpeechText,
    this.voiceLevel = 0.0,
    this.lastError,
  });

  AIVoiceState copyWith({
    bool? isListening,
    bool? isSpeaking,
    bool? isProcessing,
    bool? isConnected,
    List<AIConversationModel>? messages,
    String? currentSpeechText,
    double? voiceLevel,
    String? lastError,
  }) {
    return AIVoiceState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isProcessing: isProcessing ?? this.isProcessing,
      isConnected: isConnected ?? this.isConnected,
      messages: messages ?? this.messages,
      currentSpeechText: currentSpeechText ?? this.currentSpeechText,
      voiceLevel: voiceLevel ?? this.voiceLevel,
      lastError: lastError ?? this.lastError,
    );
  }

  // Helper getters
  bool get isActive => isListening || isSpeaking || isProcessing;
  bool get hasMessages => messages.isNotEmpty;
  bool get hasError => lastError != null;

  AIConversationModel? get lastMessage =>
      messages.isNotEmpty ? messages.last : null;

  AIConversationModel? get lastUserMessage =>
      messages.where((m) => m.isUser).isNotEmpty
          ? messages.where((m) => m.isUser).last
          : null;

  AIConversationModel? get lastAIMessage =>
      messages.where((m) => !m.isUser).isNotEmpty
          ? messages.where((m) => !m.isUser).last
          : null;

  String get statusText {
    if (!isConnected) return 'Aloqa yo\'q';
    if (isListening) return 'Tinglamoqda...';
    if (isSpeaking) return 'Gapirmoqda...';
    if (isProcessing) return 'Ishlanmoqda...';
    return 'Tayyor';
  }

  String get instructionText {
    if (!isConnected) return 'Internet aloqasini tekshiring';
    if (isListening) return 'Gapiring...';
    if (isSpeaking) return 'AI javob bermoqda...';
    if (isProcessing) return 'Javob tayyorlanmoqda...';
    return 'Gapirish uchun tugmani bosing';
  }
}