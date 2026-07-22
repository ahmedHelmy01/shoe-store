import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/ai_scan_result_model.dart';

class HealthScannerView extends ConsumerStatefulWidget {
  const HealthScannerView({super.key});

  @override
  ConsumerState<HealthScannerView> createState() => _HealthScannerViewState();
}

class _HealthScannerViewState extends ConsumerState<HealthScannerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _pickedImage = image);
      _startScan();
    }
  }

  void _startScan() {
    if (_pickedImage == null) return;
    _scanController.repeat();
    ref.read(aiScanProvider.notifier).performScan(_pickedImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scanState = ref.watch(aiScanProvider);

    ref.listen<AiScanState>(aiScanProvider, (prev, next) {
      if (!next.isScanning && (next.result != null || next.error != null)) {
        _scanController.stop();
      }
    });

    return WebStoreBaseScaffold(
      title: Text(
        'المسح الصحي الذكي',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            24.verticalSpace,

            // Scan Type Selector
            _buildScanTypeSelector(isDark, scanState),
            24.verticalSpace,

            // Camera / Upload Area
            _buildScanArea(isDark, scanState),
            24.verticalSpace,

            // Results
            if (scanState.result != null) _buildResults(scanState.result!, isDark),
            if (scanState.error != null) _buildError(scanState.error!, isDark),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildScanTypeSelector(bool isDark, AiScanState scanState) {
    final scanTypes = [
      ('hand', 'اليد', Icons.back_hand, const Color(0xFF4CAF50)),
      ('tongue', 'اللسان', Icons.record_voice_over, const Color(0xFFE91E63)),
      ('eye', 'العيون', Icons.visibility, const Color(0xFF2196F3)),
      ('skin', 'الجلد', Icons.face, const Color(0xFFFF9800)),
    ];

    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: scanTypes.length,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          final type = scanTypes[index];
          final isSelected = scanState.selectedScanType == type.$1;
          return GestureDetector(
            onTap: () => ref.read(aiScanProvider.notifier).setScanType(type.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [type.$4, type.$4.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected
                    ? null
                    : isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? type.$4
                      : isDark
                          ? Colors.white12
                          : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: type.$4.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type.$3,
                    color: isSelected ? Colors.white : type.$4,
                    size: 26.sp,
                  ),
                  8.verticalSpace,
                  Text(
                    type.$2,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : isDark
                              ? Colors.white70
                              : AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanArea(bool isDark, AiScanState scanState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Main Scan Circle
          GestureDetector(
            onTap: () => _showImageSourceSheet(),
            child: AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Container(
                  width: 220.w,
                  height: 220.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scanState.isScanning
                          ? Color.lerp(
                              const Color(0xFF6C63FF),
                              const Color(0xFF00BCD4),
                              (_scanController.value * 2) % 1.0,
                            )!
                          : const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      width: scanState.isScanning ? 3 : 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating scan line
                      if (scanState.isScanning)
                        Transform.rotate(
                          angle: _scanController.value * 6.28,
                          child: Container(
                            width: 200.w,
                            height: 200.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF6C63FF).withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Center content
                      _pickedImage != null
                          ? ClipOval(
                              child: Image.file(
                                File(_pickedImage!.path),
                                width: 200.w,
                                height: 200.w,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  scanState.isScanning
                                      ? Icons.autorenew
                                      : Icons.camera_alt_rounded,
                                  color: const Color(0xFF6C63FF),
                                  size: 48.sp,
                                ),
                                8.verticalSpace,
                                Text(
                                  scanState.isScanning ? 'جاري التحليل...' : 'اضغط للمسح',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
          20.verticalSpace,

          // Action Buttons
          if (!scanState.isScanning) ...[
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'الكاميرا',
                    color: const Color(0xFF4CAF50),
                    isDark: isDark,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.photo_library_rounded,
                    label: 'المعرض',
                    color: const Color(0xFF2196F3),
                    isDark: isDark,
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            8.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AiScanResultModel result, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAnimation.fadeInUp(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: _getStatusColor(result.overallStatus).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: _getStatusColor(result.overallStatus).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          _getStatusIcon(result.overallStatus),
                          color: _getStatusColor(result.overallStatus),
                          size: 20.sp,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نتائج المسح',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textColor,
                              ),
                            ),
                            Text(
                              result.scanType,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          12.verticalSpace,

          // Metrics Grid
          ...result.metrics.entries.map((entry) {
            return AppAnimation.fadeInUp(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _buildMetricCard(entry.value, isDark),
              ),
            );
          }),

          // Recommendations
          if (result.recommendations.isNotEmpty) ...[
            12.verticalSpace,
            AppAnimation.fadeInUp(
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: const Color(0xFFFFD700),
                          size: 18.sp,
                        ),
                        8.horizontalSpace,
                        Text(
                          'التوصيات',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    ...result.recommendations.map((rec) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF4CAF50),
                              size: 14.sp,
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Text(
                                rec,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(ScanMetric metric, bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getStatusColor(metric.status).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: _getStatusColor(metric.status),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                if (metric.description != null)
                  Text(
                    metric.description!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${metric.value.toStringAsFixed(1)} ${metric.unit}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(metric.status),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(metric.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _getStatusLabel(metric.status),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(metric.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 24.sp),
            12.horizontalSpace,
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
      case 'healthy':
        return AppColors.success;
      case 'warning':
      case 'moderate':
        return AppColors.warning;
      case 'critical':
      case 'bad':
      case 'danger':
        return AppColors.error;
      default:
        return const Color(0xFF6C63FF);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
      case 'healthy':
        return Icons.check_circle;
      case 'warning':
      case 'moderate':
        return Icons.warning;
      case 'critical':
      case 'bad':
      case 'danger':
        return Icons.dangerous;
      default:
        return Icons.info;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
      case 'healthy':
        return 'طبيعي';
      case 'warning':
      case 'moderate':
        return 'انتبه';
      case 'critical':
      case 'bad':
      case 'danger':
        return 'خطر';
      default:
        return status;
    }
  }
}
