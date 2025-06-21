import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';
import 'constants.dart';

class AppHelpers {
  // Show snackbar with different types
  static void showSnackbar({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = AppColors.warning;
        icon = Icons.warning;
        textColor = Colors.black87;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.info;
        icon = Icons.info;
        break;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor),
      snackPosition: SnackPosition.TOP,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  // Show loading dialog
  static void showLoading({String? message}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Get.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Ha',
    String cancelText = 'Yo\'q',
    bool isDangerous = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? AppColors.error : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  // Show bottom sheet
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
  }) {
    return Get.bottomSheet<T>(
      child,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  // Vibration helper
  static void vibrate() {
    // TODO: Add haptic feedback
    // HapticFeedback.lightImpact();
  }

  // Format duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}s ${minutes}d';
    } else {
      return '${minutes}d';
    }
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  // Get difficulty color
  static Color getDifficultyColor(int difficulty) {
    return AppColors.difficultyColors[difficulty] ?? AppColors.info;
  }

  // Get module color by index
  static Color getModuleColor(int index) {
    final isDark = Get.theme.brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.moduleColorsDark
        : AppColors.moduleColorsLight;
    return colors[index % colors.length];
  }

  // Validate Russian text (contains Cyrillic characters)
  static bool isRussianText(String text) {
    final cyrillicRegex = RegExp(r'[а-яё]', caseSensitive: false);
    return cyrillicRegex.hasMatch(text);
  }

  // Format progress percentage
  static String formatProgress(double progress) {
    return '${(progress * 100).round()}%';
  }

  // Get reading time estimate
  static String getReadingTime(String text) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil(); // 200 words per minute
    return '${minutes}d';
  }

  // Launch URL (for future use)
  static Future<void> launchURL(String url) async {
    // TODO: Implement URL launcher
    print('Opening URL: $url');
  }

  // Share content (for future use)
  static Future<void> shareContent(String content) async {
    // TODO: Implement share functionality
    print('Sharing: $content');
  }

  // Copy to clipboard
  static Future<void> copyToClipboard(String text) async {
    // TODO: Implement clipboard functionality
    print('Copied to clipboard: $text');
    showSnackbar(
      title: 'Nusxalandi',
      message: 'Matn buferga nusxalandi',
      type: SnackbarType.success,
    );
  }

  // Debounce function
  static void debounce(VoidCallback callback, Duration delay) {
    Timer? timer;
    timer?.cancel();
    timer = Timer(delay, callback);
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Check if string is empty or null
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Get initials from name
  static String getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0].substring(0, 1).toUpperCase();
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  // Safe navigation - prevents crashes when navigating
  static void safeNavigate(String route, {dynamic arguments}) {
    try {
      Get.toNamed(route, arguments: arguments);
    } catch (e) {
      print('Navigation error: $e');
      showSnackbar(
        title: 'Xatolik',
        message: 'Sahifaga o\'tishda xatolik yuz berdi',
        type: SnackbarType.error,
      );
    }
  }

  // Format timestamp
  static String formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}k oldin';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}s oldin';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}d oldin';
    } else {
      return 'Hozir';
    }
  }
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

// Timer class for debouncing
class Timer {
  static Future<void>? _timer;

  Timer(Duration duration, VoidCallback callback) {
    _timer?.ignore();
    _timer = Future.delayed(duration, callback);
  }

  void cancel() {
    _timer = null;
  }
}