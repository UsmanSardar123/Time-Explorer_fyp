import 'dart:io' as dart_io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Result of an image pick & validate operation.
class ProfileImageResult {
  /// Populated on web (bytes from XFile.readAsBytes).
  final Uint8List? bytes;

  /// Populated on mobile (dart:io.File). Null on web.
  final Object? file;

  /// Original file name, used to derive extension.
  final String fileName;

  const ProfileImageResult({
    required this.fileName,
    this.bytes,
    this.file,
  });
}

/// Failure details returned instead of throwing.
class ProfileImageError {
  final String message;
  const ProfileImageError(this.message);
}

/// Central service for picking and validating profile images.
/// Web: returns raw bytes. Mobile: returns dart:io.File.
/// image_picker's imageQuality parameter handles compression on both platforms.
class ProfileImageService {
  static const _maxFileSizeBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  final ImagePicker _picker;

  ProfileImageService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  // ignore: prefer_constructors_over_static_methods
  static ProfileImageService create() =>
      ProfileImageService(picker: ImagePicker());

  Future<Object> pickFromGallery() => _pick(ImageSource.gallery);

  Future<Object> pickFromCamera() => _pick(ImageSource.camera);

  // ── Core logic ───────────────────────────────────────────────────────────

  Future<Object> _pick(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (picked == null) return const ProfileImageError('cancelled');

      final ext = picked.name.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        return ProfileImageError(
          'Please choose a JPG, PNG, or WebP image.',
        );
      }

      if (kIsWeb) {
        return await _handleWeb(picked);
      } else {
        return await _handleMobile(picked);
      }
    } catch (e, st) {
      debugPrint('[ProfileImageService] ❌ pick error: $e\n$st');
      return ProfileImageError(_friendlyPickError(e));
    }
  }

  // ── Web ───────────────────────────────────────────────────────────────────

  Future<Object> _handleWeb(XFile picked) async {
    final bytes = await picked.readAsBytes();
    if (bytes.lengthInBytes > _maxFileSizeBytes) {
      final mb = (bytes.lengthInBytes / 1024 / 1024).toStringAsFixed(1);
      return ProfileImageError(
        'File is too large (${mb}MB). Please choose an image under 5MB.',
      );
    }
    debugPrint(
      '[ProfileImageService] 🌐 Web pick OK — ${bytes.lengthInBytes} bytes',
    );
    return ProfileImageResult(fileName: picked.name, bytes: bytes);
  }

  // ── Mobile ────────────────────────────────────────────────────────────────

  Future<Object> _handleMobile(XFile picked) async {
    final file = dart_io.File(picked.path);
    final size = await file.length();
    if (size > _maxFileSizeBytes) {
      final mb = (size / 1024 / 1024).toStringAsFixed(1);
      return ProfileImageError(
        'File is too large (${mb}MB). Please choose an image under 5MB.',
      );
    }
    debugPrint(
      '[ProfileImageService] 📱 Mobile pick OK — '
      '${(size / 1024).toStringAsFixed(0)}KB',
    );
    return ProfileImageResult(fileName: picked.name, file: file);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyPickError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('permission')) return 'Camera or storage permission was denied.';
    if (msg.contains('socket') || msg.contains('failed host') || msg.contains('network')) {
      return 'No internet connection. Please try again.';
    }
    if (msg.contains('not found')) return 'Image file not found.';
    return 'Could not access the image. Please try again.';
  }
}
