import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';

class PortfolioPickerWidget extends StatelessWidget {
  final List<XFile> photos;
  final ValueChanged<List<XFile>> onPhotosAdded;
  final ValueChanged<int> onPhotoRemoved;
  final int maxPhotos;

  const PortfolioPickerWidget({
    super.key,
    required this.photos,
    required this.onPhotosAdded,
    required this.onPhotoRemoved,
    this.maxPhotos = 10,
  });

  Future<void> _addPhotos(BuildContext context) async {
    final remaining = maxPhotos - photos.length;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    final results = await picker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (results.isNotEmpty) {
      onPhotosAdded(results.take(remaining).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = photos.length < maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: photos.length + (canAddMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == photos.length) {
              return GestureDetector(
                onTap: () => _addPhotos(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.add,
                          color: AppColors.textTertiary, size: 22),
                      SizedBox(height: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.file(
                    File(photos[index].path),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onPhotoRemoved(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: CupertinoColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '${photos.length} / $maxPhotos photos added',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
