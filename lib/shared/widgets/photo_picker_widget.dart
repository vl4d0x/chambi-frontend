import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';

class PhotoPickerWidget extends StatelessWidget {
  final XFile? photo;
  final ValueChanged<XFile> onPhotoPicked;
  final Color accentColor;

  const PhotoPickerWidget({
    super.key,
    this.photo,
    required this.onPhotoPicked,
    this.accentColor = AppColors.taskerAccent,
  });

  Future<void> _pickPhoto(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (result != null) {
      onPhotoPicked(result);
    }
  }

  void _showPickerOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickPhoto(context, ImageSource.camera);
            },
            child: const Text('Take a photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickPhoto(context, ImageSource.gallery);
            },
            child: const Text('Choose from library'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photo != null;

    return Center(
      child: GestureDetector(
        onTap: () => _showPickerOptions(context),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasPhoto ? accentColor : AppColors.divider,
                  width: 2,
                ),
              ),
              child: hasPhoto
                  ? ClipOval(
                      child: Image.file(
                        File(photo!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      CupertinoIcons.person_fill,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2.5),
              ),
              child: const Icon(
                CupertinoIcons.camera_fill,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
