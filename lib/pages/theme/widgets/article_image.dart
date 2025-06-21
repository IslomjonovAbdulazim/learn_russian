import 'package:flutter/material.dart';
import '../../../models/article_component_model.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/colors.dart';

class ArticleImage extends StatelessWidget {
  final ArticleComponentModel component;

  const ArticleImage({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    final url = component.imageUrl;
    final caption = component.caption;
    final alt = component.content['alt'];
    final width = component.content['width']?.toDouble();
    final height = component.content['height']?.toDouble();

    if (url.isEmpty) {
      return _buildPlaceholderImage(alt ?? 'Rasm');
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image container
          Container(
            constraints: BoxConstraints(
              maxWidth: width ?? double.infinity,
              maxHeight: height ?? 400,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImageWidget(url, alt),
            ),
          ),

          // Caption
          if (caption != null && caption.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                caption,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageWidget(String url, String? alt) {
    if (url.startsWith('http')) {
      // Network image
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: 200,
            color: Colors.grey[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rasm yuklanmoqda...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage(alt ?? 'Rasm yuklashda xatolik');
        },
      );
    } else {
      // Asset image
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage(alt ?? 'Rasm topilmadi');
        },
      );
    }
  }

  Widget _buildPlaceholderImage(String text) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage(String errorText) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            errorText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}