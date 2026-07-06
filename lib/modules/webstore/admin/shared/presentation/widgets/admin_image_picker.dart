import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/providers/core_providers.dart';

class AdminImagePicker extends ConsumerStatefulWidget {
  final String? initialImage;
  final List<String>? initialGallery;
  final bool isMultiple;
  final String label;
  
  /// For local selection flow (original)
  final Function(XFile?)? onImageSelected;
  final Function(List<XFile>)? onGallerySelected;
  
  /// For Instant Upload flow (new)
  final String? uploadFolder;
  final Function(String?)? onPathSelected;
  final Function(List<String>)? onPathsSelected;
  
  final VoidCallback? onRemoveInitial;
  final double? uploadProgress; // External progress if provided

  const AdminImagePicker({
    super.key,
    this.initialImage,
    this.initialGallery,
    this.isMultiple = false,
    this.label = 'Image',
    this.onImageSelected,
    this.onGallerySelected,
    this.uploadFolder,
    this.onPathSelected,
    this.onPathsSelected,
    this.onRemoveInitial,
    this.uploadProgress,
  });

  @override
  ConsumerState<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends ConsumerState<AdminImagePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  List<XFile> _selectedFiles = [];
  bool _hasInitialRemoved = false;
  bool _initialImageFailed = false;
  
  bool _isProcessing = false;
  double _internalProgress = 0;

  /// Allowed image extensions for web compatibility
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'];

  /// Validates that the picked file is a decodable image.
  /// Returns null if valid, or an error reason string if invalid.
  Future<String?> _validateImage(XFile file) async {
    // 1. Check file extension
    final ext = file.name.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      return 'صيغة الملف ".$ext" غير مدعومة.\nالصيغ المسموح بها: JPG, PNG, WebP, GIF, BMP';
    }

    // 2. Try to actually decode the bytes (catches corrupted files & mismatched extensions)
    try {
      final Uint8List bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        return 'الملف فارغ ولا يحتوي على بيانات صورة.';
      }
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      frame.image.dispose();
      codec.dispose();
    } catch (_) {
      return 'الملف تالف أو بصيغة غير مدعومة من المتصفح.\nجرب تحويل الصورة لصيغة JPG أو PNG.';
    }

    return null; // ✅ valid
  }

  /// Shows a professional dialog when an image fails validation.
  void _showImageErrorDialog(String fileName, String reason) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image_not_supported_outlined, color: Colors.red[400], size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('تعذر إرفاق الصورة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Reason
            Text('السبب:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700])),
            const SizedBox(height: 6),
            Text(reason, style: TextStyle(fontSize: 13, color: Colors.red[700], height: 1.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // ✅ Validate image before proceeding
      final validationError = await _validateImage(image);
      if (validationError != null) {
        _showImageErrorDialog(image.name, validationError);
        return;
      }

      if (widget.uploadFolder != null) {
        // Instant Upload Flow
        if (mounted) {
          setState(() {
            _isProcessing = true;
            _internalProgress = 0;
          });
        }

        try {
          final path = await ref.read(uploadServiceProvider).uploadSingle(
            file: image,
            uploadFolder: widget.uploadFolder!,
            onProgress: (p) {
              if (mounted) setState(() => _internalProgress = p);
            },
          );

          if (mounted) {
            setState(() {
              _selectedFile = image;
              _hasInitialRemoved = true;
              _isProcessing = false;
            });
          }
          
          widget.onPathSelected?.call(path);
          widget.onImageSelected?.call(image);
        } catch (e) {
          if (mounted) setState(() => _isProcessing = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
            );
          }
        }
      } else {
        // Local Selection Flow
        if (mounted) {
          setState(() {
            _selectedFile = image;
            _hasInitialRemoved = true;
          });
        }
        widget.onImageSelected?.call(_selectedFile);
      }
    } catch (e) {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickMultiple() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isEmpty) return;

      // ✅ Validate each image and filter out invalid ones
      final List<XFile> validImages = [];
      for (final image in images) {
        final error = await _validateImage(image);
        if (error != null) {
          _showImageErrorDialog(image.name, error);
        } else {
          validImages.add(image);
        }
      }
      if (validImages.isEmpty) return;

      if (widget.uploadFolder != null) {
        // Instant Upload Flow
        if (mounted) {
          setState(() {
            _isProcessing = true;
            _internalProgress = 0;
          });
        }

        try {
          final paths = await ref.read(uploadServiceProvider).uploadMultiple(
            xFiles: validImages,
            uploadFolder: widget.uploadFolder!,
            onProgress: (p) {
              if (mounted) setState(() => _internalProgress = p);
            },
          );

          if (mounted) {
            setState(() {
              _selectedFiles = [..._selectedFiles, ...validImages];
              _isProcessing = false;
            });
          }

          widget.onPathsSelected?.call(paths);
          widget.onGallerySelected?.call(_selectedFiles);
        } catch (e) {
          if (mounted) setState(() => _isProcessing = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
            );
          }
        }
      } else {
        // Local Selection Flow
        if (mounted) {
          setState(() {
            _selectedFiles = [..._selectedFiles, ...validImages];
          });
        }
        widget.onGallerySelected?.call(_selectedFiles);
      }
    } catch (e) {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = widget.uploadProgress ?? ( _isProcessing ? _internalProgress : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                widget.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              if (progress > 0)
                _buildProgressBadge(theme, progress),
            ],
          ),
          const SizedBox(height: 14),
        ],
        widget.isMultiple
            ? _buildGalleryLayout(isDark, theme)
            : _buildSingleLayout(isDark, theme),
      ],
    );
  }

  Widget _buildProgressBadge(ThemeData theme, double val) {
    final percent = (val * 100).toInt().clamp(0, 99);
    final isDone = val >= 1.0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              value: isDone ? null : val,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isDone ? 'Processing...' : '$percent%',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialImage() {
    if (kIsWeb) {
      return AppImage(
        imagePath: widget.initialImage!,
        fit: BoxFit.cover,
      );
    }
    return AppImage(imagePath: widget.initialImage!);
  }

  Widget _buildSingleLayout(bool isDark, ThemeData theme) {
    final hasImage = (_selectedFile != null) || (widget.initialImage != null && !_hasInitialRemoved);
    final showOverlay = hasImage && !_initialImageFailed;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          if (hasImage)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: _selectedFile != null
                    ? kIsWeb
                        ? AppImage(
                            imagePath: _selectedFile!.path,
                            fit: BoxFit.cover,
                          )
                        : AppImage(imagePath: 'file://${_selectedFile!.path}', fit: BoxFit.cover)
                    : _buildInitialImage(),
              ),
            ),
          
          if (showOverlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),

          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isProcessing ? null : _pickImage,
                borderRadius: BorderRadius.circular(23),
                child: _isProcessing
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              value: _internalProgress > 0 && _internalProgress < 1.0 ? _internalProgress : null,
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _internalProgress >= 1.0 
                                ? 'Processing...' 
                                : 'Uploading... ${(_internalProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _initialImageFailed && hasImage && _selectedFile == null
                        ? const SizedBox.shrink() // Fallback message already shown by _buildInitialImage
                        : _buildSinglePlaceholder(hasImage && !_initialImageFailed, isDark, theme),
              ),
            ),
          ),

          if (hasImage && !_isProcessing)
            Positioned(
              top: 14,
              right: 14,
              child: _buildRemoveButton(() {
                if (mounted) {
                  setState(() {
                    _selectedFile = null;
                    _hasInitialRemoved = true;
                  });
                }
                widget.onImageSelected?.call(null);
                widget.onPathSelected?.call(null);
                widget.onRemoveInitial?.call();
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildSinglePlaceholder(bool hasImage, bool isDark, ThemeData theme) {
    if (hasImage) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync_rounded, color: Colors.white.withValues(alpha: 0.9), size: 32),
            const SizedBox(height: 8),
            Text(
              'Click to change image',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return CustomPaint(
      painter: _DashPainter(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
        radius: 24,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_photo_alternate_outlined, size: 36, color: theme.primaryColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Main Image',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Recommended: 1200x800px',
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryLayout(bool isDark, ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Initial Network Images
        if (widget.initialGallery != null)
          ...widget.initialGallery!.map((path) => _buildGalleryItem(path, isNetwork: true, isDark: isDark)),
        
        // Newly Selected
        ..._selectedFiles.map((file) => _buildGalleryItem(file.path, isNetwork: false, isDark: isDark)),

        // Add Button
        _buildAddMoreCard(isDark, theme),
      ],
    );
  }

  Widget _buildGalleryItem(String path, {required bool isNetwork, required bool isDark}) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isNetwork
                  ? AppImage(imagePath: path)
                  : kIsWeb
                      ? AppImage(imagePath: path)
                      : AppImage(imagePath: 'file://$path'),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: _buildRemoveButton(() {
              if (mounted) {
                setState(() {
                  if (isNetwork) {
                    widget.initialGallery?.remove(path);
                  } else {
                    _selectedFiles.removeWhere((f) => f.path == path);
                    widget.onGallerySelected?.call(_selectedFiles);
                  }
                });
              }
            }, isSmall: true),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreCard(bool isDark, ThemeData theme) {
    return GestureDetector(
      onTap: _isProcessing ? null : _pickMultiple,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomPaint(
          painter: _DashPainter(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
            radius: 20,
          ),
          child: Center(
            child: _isProcessing
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          value: _internalProgress > 0 && _internalProgress < 1.0 ? _internalProgress : null,
                          strokeWidth: 2, 
                          valueColor: AlwaysStoppedAnimation(theme.primaryColor)
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${(_internalProgress * 100).toInt()}%', style: TextStyle(fontSize: 10, color: theme.primaryColor)),
                    ],
                  )
                : Icon(Icons.add_rounded, size: 32, color: theme.primaryColor.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }

  /// Fallback widget shown when an already-attached image fails to render.
  Widget _buildBrokenImagePlaceholder({bool isSmall = false}) {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, size: isSmall ? 24 : 36, color: Colors.grey[400]),
            const SizedBox(height: 4),
            Text(
              'صيغة غير مدعومة',
              style: TextStyle(fontSize: isSmall ? 9 : 11, color: Colors.grey[500], fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveButton(VoidCallback onTap, {bool isSmall = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmall ? 4 : 8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4),
          ],
        ),
        child: Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: isSmall ? 14 : 18,
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashPainter({required this.color, this.radius = 20});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    const double dashWidth = 8.0;
    const double dashSpace = 6.0;
    double distance = 0.0;

    for (ui.PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        canvas.drawPath(
          measurePath.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
