import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

// Mobile-only imports — guarded by kIsWeb
import 'dart:io' if (dart.library.html) 'dart:html' as dart_io;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Result of an image pick & validate operation.
class ProfileImageResult {
  /// Null when on mobile; populated on web.
  final Uint8List? bytes;

  /// Null when on web; populated on mobile.
  final Object? file; // File on mobile (dart:io.File)

  /// The original file name (used to derive extension).
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

/// Central service for picking, validating, and compressing profile images.
/// Fully web + mobile compatible — never crashes silently.
class ProfileImageService {
  static const _maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const _allowedExtensions = ['jpg', 'jpeg'];
  static const _compressQuality = 75; // 0–100
  static const _compressMaxDimension = 1024; // pixels

  final ImagePicker _picker;

  const ProfileImageService({ImagePicker? picker})
      : _picker = picker ?? const ImagePicker();

  // ignore: prefer_constructors_over_static_methods
  static ProfileImageService create() =>
      ProfileImageService(picker: ImagePicker());

  /// Opens the gallery picker, validates and compresses the image.
  /// Returns [ProfileImageResult] on success or [ProfileImageError] on failure.
  Future<Object> pickFromGallery() => _pick(ImageSource.gallery);

  /// Opens the camera, validates and compresses the image.
  /// Returns [ProfileImageResult] on success or [ProfileImageError] on failure.
  Future<Object> pickFromCamera() => _pick(ImageSource.camera);

  // ── Core logic ───────────────────────────────────────────────────────────

  Future<Object> _pick(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90, // initial quality; we compress further below
      );

      if (picked == null) {
        // User cancelled — not an error.
        return const ProfileImageError('cancelled');
      }

      // ── Validate extension ───────────────────────────────────────────────
      final ext = picked.name.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        return ProfileImageError(
          'Only JPG / JPEG files are allowed.\n'
          'You selected a .$ext file.',
        );
      }

      if (kIsWeb) {
        return await _handleWeb(picked);
      } else {
        return await _handleMobile(picked);
      }
    } catch (e, st) {
      debugPrint('[ProfileImageService] ❌ pick error: $e\n$st');
      return ProfileImageError('Could not access image: ${_friendlyError(e)}');
    }
  }

  // ── Web handler ───────────────────────────────────────────────────────────

  Future<Object> _handleWeb(XFile picked) async {
    final bytes = await picked.readAsBytes();

    // File size check
    if (bytes.lengthInBytes > _maxFileSizeBytes) {
      final mb = (bytes.lengthInBytes / 1024 / 1024).toStringAsFixed(1);
      return ProfileImageError(
        'File is too large (${mb}MB). Please choose an image under 5MB.',
      );
    }

    // Web: flutter_image_compress does not support web, so return raw bytes.
    debugPrint(
      '[ProfileImageService] 🌐 Web pick OK — ${bytes.lengthInBytes} bytes',
    );
    return ProfileImageResult(fileName: picked.name, bytes: bytes);
  }

  // ── Mobile handler ────────────────────────────────────────────────────────

  Future<Object> _handleMobile(XFile picked) async {
    // ignore: avoid_dynamic_calls
    final originalFile = dart_io.File(picked.path);
    final originalSize = await originalFile.length();

    if (originalSize > _maxFileSizeBytes) {
      final mb = (originalSize / 1024 / 1024).toStringAsFixed(1);
      return ProfileImageError(
        'File is too large (${mb}MB). Please choose an image under 5MB.',
      );
    }

    // Compress
    final compressedPath = '${picked.path}_compressed.jpg';
    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      compressedPath,
      quality: _compressQuality,
      minWidth: _compressMaxDimension,
      minHeight: _compressMaxDimension,
      format: CompressFormat.jpeg,
    );

    final finalFile = compressed != null
        ? dart_io.File(compressed.path)
        : originalFile;

    final finalSize = await finalFile.length();
    debugPrint(
      '[ProfileImageService] 📱 Mobile pick OK — '
      'original: ${(originalSize / 1024).toStringAsFixed(0)}KB, '
      'compressed: ${(finalSize / 1024).toStringAsFixed(0)}KB',
    );

    return ProfileImageResult(
      fileName: picked.name,
      file: finalFile,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('permission')) return 'Camera / storage permission denied.';
    if (msg.contains('not found')) return 'Image file not found.';
    return 'Unexpected error.';
  }
}
