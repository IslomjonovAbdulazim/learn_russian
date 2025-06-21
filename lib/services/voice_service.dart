import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

class VoiceService extends GetxService {
  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  // Observable states
  final _isListening = false.obs;
  final _isSpeaking = false.obs;
  final _isAvailable = false.obs;
  final _currentWords = ''.obs;
  final _confidence = 0.0.obs;
  final _voiceLevel = 0.0.obs;

  // Getters
  bool get isListening => _isListening.value;
  bool get isSpeaking => _isSpeaking.value;
  bool get isAvailable => _isAvailable.value;
  String get currentWords => _currentWords.value;
  double get confidence => _confidence.value;
  double get voiceLevel => _voiceLevel.value;

  // Status getters
  bool get isActive => isListening || isSpeaking;
  String get statusText {
    if (isSpeaking) return 'Gapirmoqda...';
    if (isListening) return 'Tinglamoqda...';
    return 'Tayyor';
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initSpeechToText();
    await _initTextToSpeech();
  }

  Future<void> _initSpeechToText() async {
    _speechToText = SpeechToText();

    try {
      bool available = await _speechToText.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
        debugLogging: kDebugMode,
      );

      _isAvailable.value = available;

      if (available) {
        print('Speech-to-text initialized successfully');
      } else {
        print('Speech-to-text not available');
      }
    } catch (e) {
      print('Error initializing speech-to-text: $e');
      _isAvailable.value = false;
    }
  }

  Future<void> _initTextToSpeech() async {
    _flutterTts = FlutterTts();

    try {
      // Configure TTS
      await _flutterTts.setLanguage(AppConstants.voiceLanguage);
      await _flutterTts.setPitch(AppConstants.voicePitch);
      await _flutterTts.setSpeechRate(AppConstants.voiceRate);

      // Set volume to maximum
      await _flutterTts.setVolume(1.0);

      // Configure callbacks
      _flutterTts.setStartHandler(() {
        _isSpeaking.value = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking.value = false;
      });

      _flutterTts.setErrorHandler((message) {
        print('TTS Error: $message');
        _isSpeaking.value = false;
      });

      _flutterTts.setCancelHandler(() {
        _isSpeaking.value = false;
      });

      print('Text-to-speech initialized successfully');
    } catch (e) {
      print('Error initializing text-to-speech: $e');
    }
  }

  // Speech-to-Text methods
  Future<void> startListening({String? localeId}) async {
    if (!_isAvailable.value) {
      print('Speech recognition not available');
      return;
    }

    if (_isListening.value) {
      await stopListening();
    }

    try {
      _currentWords.value = '';
      _confidence.value = 0.0;

      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: localeId ?? 'ru-RU',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        onSoundLevelChange: _onSoundLevelChange,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );

      _isListening.value = true;
    } catch (e) {
      print('Error starting speech recognition: $e');
      _isListening.value = false;
    }
  }

  Future<void> stopListening() async {
    if (_isListening.value) {
      await _speechToText.stop();
      _isListening.value = false;
      _voiceLevel.value = 0.0;
    }
  }

  void _onSpeechResult(result) {
    _currentWords.value = result.recognizedWords;
    _confidence.value = result.hasConfidenceRating ? result.confidence : 1.0;

    if (result.finalResult) {
      _isListening.value = false;
      _voiceLevel.value = 0.0;
    }
  }

  void _onSpeechError(error) {
    print('Speech error: ${error.errorMsg}');
    _isListening.value = false;
    _voiceLevel.value = 0.0;
  }

  void _onSpeechStatus(String status) {
    print('Speech status: $status');
    if (status == 'notListening' || status == 'done') {
      _isListening.value = false;
      _voiceLevel.value = 0.0;
    }
  }

  void _onSoundLevelChange(double level) {
    // Normalize sound level for visual feedback (0.0 to 1.0)
    _voiceLevel.value = (level + 50) / 50; // Assuming level is between -50 and 0
    _voiceLevel.value = _voiceLevel.value.clamp(0.0, 1.0);
  }

  // Text-to-Speech methods
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      // Stop any current speech
      await stopSpeaking();

      // Start speaking
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
      _isSpeaking.value = false;
    }
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking.value) {
      await _flutterTts.stop();
      _isSpeaking.value = false;
    }
  }

  Future<void> pauseSpeaking() async {
    if (_isSpeaking.value) {
      await _flutterTts.pause();
    }
  }

  // Configuration methods
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate.clamp(0.1, 2.0));
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch.clamp(0.1, 2.0));
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  // Utility methods
  Future<List<String>> getAvailableLanguages() async {
    final languages = await _flutterTts.getLanguages;
    return languages.cast<String>();
  }

  Future<List<String>> getAvailableVoices() async {
    final voices = await _flutterTts.getVoices;
    return voices.map((voice) => voice['name'].toString()).toList();
  }

  // Russian language specific methods
  Future<void> speakRussianText(String text) async {
    await setLanguage('ru-RU');
    await setSpeechRate(0.7); // Slower for learning
    await speak(text);
  }

  Future<String?> listenForRussian() async {
    _currentWords.value = '';
    await startListening(localeId: 'ru-RU');

    // Wait for listening to complete
    while (_isListening.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return _currentWords.value.isNotEmpty ? _currentWords.value : null;
  }

  // Cleanup
  @override
  void onClose() {
    stopListening();
    stopSpeaking();
    super.onClose();
  }

  // Permission check
  Future<bool> hasPermission() async {
    return await _speechToText.hasPermission;
  }

  Future<bool> requestPermission() async {
    if (!await hasPermission()) {
      return await _speechToText.initialize();
    }
    return true;
  }
}