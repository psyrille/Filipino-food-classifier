import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  // Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      print('✅ Camera permission granted');
      return true;
    } else if (status.isDenied) {
      print('❌ Camera permission denied');
      return false;
    } else if (status.isPermanentlyDenied) {
      print('⚠️ Camera permission permanently denied');
      // Open app settings
      await openAppSettings();
      return false;
    }

    return false;
  }

  // Request gallery/photos permission
  Future<bool> requestGalleryPermission() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      print('✅ Gallery permission granted');
      return true;
    } else if (status.isDenied) {
      print('❌ Gallery permission denied');
      return false;
    } else if (status.isPermanentlyDenied) {
      print('⚠️ Gallery permission permanently denied');
      await openAppSettings();
      return false;
    }

    return false;
  }

  // Take photo with camera
  Future<File?> takePhoto() async {
    try {
      // Request permission first
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        print('❌ Camera permission not granted');
        return null;
      }

      print('📸 Opening camera...');

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        print('✅ Photo captured: ${photo.path}');
        return File(photo.path);
      } else {
        print('ℹ️ User cancelled camera');
        return null;
      }
    } catch (e) {
      print('❌ Error taking photo: $e');
      return null;
    }
  }

  // Pick image from gallery
  Future<File?> pickFromGallery() async {
    try {
      // Request permission first
      final hasPermission = await requestGalleryPermission();
      if (!hasPermission) {
        print('❌ Gallery permission not granted');
        return null;
      }

      print('🖼️ Opening gallery...');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        print('✅ Image selected: ${image.path}');
        return File(image.path);
      } else {
        print('ℹ️ User cancelled gallery selection');
        return null;
      }
    } catch (e) {
      print('❌ Error picking from gallery: $e');
      return null;
    }
  }

  // Pick multiple images from gallery
  Future<List<File>?> pickMultipleFromGallery() async {
    try {
      final hasPermission = await requestGalleryPermission();
      if (!hasPermission) {
        print('❌ Gallery permission not granted');
        return null;
      }

      print('🖼️ Opening gallery for multiple selection...');

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        print('✅ ${images.length} images selected');
        return images.map((xFile) => File(xFile.path)).toList();
      } else {
        print('ℹ️ No images selected');
        return null;
      }
    } catch (e) {
      print('❌ Error picking multiple images: $e');
      return null;
    }
  }

  // Show image source selection dialog
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1B00),
              ),
            ),
            const SizedBox(height: 20),

            // Camera option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.orange),
              ),
              title: const Text('Camera'),
              subtitle: const Text('Take a new photo'),
              onTap: () async {
                Navigator.pop(context);
                final file = await takePhoto();
                if (context.mounted && file != null) {
                  Navigator.pop(context, file);
                }
              },
            ),

            const SizedBox(height: 10),

            // Gallery option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: Colors.orange),
              ),
              title: const Text('Gallery'),
              subtitle: const Text('Choose from your photos'),
              onTap: () async {
                Navigator.pop(context);
                final file = await pickFromGallery();
                if (context.mounted && file != null) {
                  Navigator.pop(context, file);
                }
              },
            ),

            const SizedBox(height: 10),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Check if camera permission is granted
  Future<bool> isCameraAvailable() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      print('❌ Error checking camera availability: $e');
      return false;
    }
  }

  // Get image info
  Future<Map<String, dynamic>?> getImageInfo(File imageFile) async {
    try {
      final fileSize = await imageFile.length();
      final fileName = imageFile.path.split('/').last;

      return {
        'path': imageFile.path,
        'name': fileName,
        'size': fileSize,
        'sizeInMB': (fileSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      print('❌ Error getting image info: $e');
      return null;
    }
  }
}
