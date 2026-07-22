import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:image_picker/image_picker.dart';

class ArMedicineCheckView extends ConsumerStatefulWidget {
  const ArMedicineCheckView({super.key});

  @override
  ConsumerState<ArMedicineCheckView> createState() => _ArMedicineCheckViewState();
}

class _ArMedicineCheckViewState extends ConsumerState<ArMedicineCheckView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanLineController;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  List<MedicineItem>? _detectedMedicines;
  List<MedicineInteraction>? _interactions;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanLineController.dispose();
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
      _startAnalysis();
    }
  }

  void _startAnalysis() async {
    setState(() {
      _isScanning = true;
      _detectedMedicines = null;
      _interactions = null;
      _error = null;
    });

    _scanLineController.repeat();

    // Simulate AR detection
    await Future.delayed(const Duration(seconds: 3));

    _scanLineController.stop();

    final mockMedicines = [
      MedicineItem(
        name: 'باراسيتامول',
        dosage: '500mg',
        frequency: '3 مرات يومياً',
        icon: Icons.medication,
        color: const Color(0xFF4CAF50),
        description: 'مسكن ألم وخافض حرارة',
      ),
      MedicineItem(
        name: 'أموكسيسيلين',
        dosage: '250mg',
        frequency: '3 مرات يومياً لمدة 7 أيام',
        icon: Icons.medical_services,
        color: const Color(0xFF2196F3),
        description: 'مضاد حيوي',
      ),
      MedicineItem(
        name: 'أوميبرازول',
        dosage: '20mg',
        frequency: 'مرة يومياً قبل الأكل',
        icon: Icons.healing,
        color: const Color(0xFFFF9800),
        description: 'مثبط مضخة البروتون - لحماية المعدة',
      ),
    ];

    final mockInteractions = [
      MedicineInteraction(
        medicine1: 'أموكسيسيلين',
        medicine2: 'أوميبرازول',
        severity: InteractionSeverity.warning,
        description: 'أوميبرازول ممكن يقلل امتصاص أموكسيسيلين. خذ الفاصل بينهم ساعتين على الأقل.',
        recommendation: 'اشرب أموكسيسيلين بعد أوميبرازول بساعتين',
      ),
    ];

    setState(() {
      _isScanning = false;
      _detectedMedicines = mockMedicines;
      _interactions = mockInteractions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WebStoreBaseScaffold(
      title: Text(
        'فحص الأدوية AR',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            24.verticalSpace,

            // Camera/Scan Area
            _buildScanArea(isDark),
            20.verticalSpace,

            // Action Buttons
            if (!_isScanning) _buildActionButtons(isDark),
            24.verticalSpace,

            // Detected Medicines
            if (_detectedMedicines != null) ...[
              _buildDetectedSection(isDark),
              20.verticalSpace,
            ],

            // Interactions
            if (_interactions != null && _interactions!.isNotEmpty) ...[
              _buildInteractionsSection(isDark),
              20.verticalSpace,
            ],

            // Error
            if (_error != null) _buildErrorState(isDark),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildScanArea(bool isDark) {
    return AppAnimation.fadeInDown(
      child: Container(
        width: double.infinity,
        height: 280.h,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: _isScanning
                ? const Color(0xFF6C63FF).withValues(alpha: 0.5)
                : isDark
                    ? Colors.white12
                    : Colors.grey.shade200,
            width: _isScanning ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // AR Overlay Grid
              Positioned.fill(
                child: CustomPaint(
                  painter: ArGridPainter(
                    color: _isScanning
                        ? const Color(0xFF6C63FF).withValues(alpha: 0.3)
                        : const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Scanning line
              if (_isScanning)
                AnimatedBuilder(
                  animation: _scanLineController,
                  builder: (context, _) {
                    return Positioned(
                      top: _scanLineController.value * 280.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF6C63FF),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.lerp(
                              const Color(0xFF6C63FF),
                              const Color(0xFF00BCD4),
                              (_pulseController.value * 2) % 1.0,
                            )!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(
                                alpha: 0.2 + (_pulseController.value * 0.3),
                              ),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isScanning ? Icons.autorenew : Icons.view_in_ar_rounded,
                          color: const Color(0xFF6C63FF),
                          size: 48.sp,
                        ),
                      );
                    },
                  ),
                  16.verticalSpace,
                  Text(
                    _isScanning
                        ? 'جاري تحليل الأدوية...'
                        : 'صوّر الأدوية لفحصها',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textColor,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    _isScanning
                        ? 'استخدم كاميرا الـ AR لاكتشاف الأدوية'
                        : 'اضغط على الكاميرا أو المعرض',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Corner brackets (AR style)
              if (!_isScanning) ...[
                _buildCornerBracket(Alignment.topLeft, 20.w),
                _buildCornerBracket(Alignment.topRight, 20.w),
                _buildCornerBracket(Alignment.bottomLeft, 20.w),
                _buildCornerBracket(Alignment.bottomRight, 20.w),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerBracket(Alignment alignment, double inset) {
    return Positioned(
      top: alignment.y < 0 ? inset : null,
      bottom: alignment.y > 0 ? inset : null,
      left: alignment.x < 0 ? inset : null,
      right: alignment.x > 0 ? inset : null,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Color(0xFF6C63FF), width: 2)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Color(0xFF6C63FF), width: 2)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Color(0xFF6C63FF), width: 2)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Color(0xFF6C63FF), width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return AppAnimation.fadeInUp(
      child: Row(
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
          12.horizontalSpace,
          Expanded(
            child: _buildActionButton(
              icon: Icons.view_in_ar_rounded,
              label: 'AR مباشر',
              color: const Color(0xFF9C27B0),
              isDark: isDark,
              onTap: () => _startAnalysis(),
            ),
          ),
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
        padding: EdgeInsets.symmetric(vertical: 16.h),
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
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            6.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectedSection(bool isDark) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20.sp,
                ),
              ),
              10.horizontalSpace,
              Text(
                'تم اكتشاف ${_detectedMedicines!.length} أدوية',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ..._detectedMedicines!.map((med) {
            return AppAnimation.fadeInUp(
              child: _buildMedicineCard(med, isDark),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(MedicineItem medicine, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: medicine.color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: medicine.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              medicine.icon,
              color: medicine.color,
              size: 22.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                2.verticalSpace,
                Text(
                  '${medicine.dosage} • ${medicine.frequency}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                2.verticalSpace,
                Text(
                  medicine.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: medicine.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified,
            color: medicine.color,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionsSection(bool isDark) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                  size: 20.sp,
                ),
              ),
              10.horizontalSpace,
              Text(
                'تنبيهات التفاعل',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ..._interactions!.map((interaction) {
            return _buildInteractionCard(interaction, isDark);
          }),
        ],
      ),
    );
  }

  Widget _buildInteractionCard(MedicineInteraction interaction, bool isDark) {
    final severityColor = interaction.severity == InteractionSeverity.dangerous
        ? AppColors.error
        : interaction.severity == InteractionSeverity.warning
            ? AppColors.warning
            : AppColors.info;

    final severityLabel = interaction.severity == InteractionSeverity.dangerous
        ? 'خطير'
        : interaction.severity == InteractionSeverity.warning
            ? 'تنبيه'
            : 'معلومة';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  severityLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${interaction.medicine1} + ${interaction.medicine2}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            interaction.description,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.textColor,
              height: 1.5,
            ),
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.success, size: 16.sp),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    interaction.recommendation,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 24.sp),
          12.horizontalSpace,
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: AppColors.error, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineItem {
  final String name;
  final String dosage;
  final String frequency;
  final IconData icon;
  final Color color;
  final String description;

  const MedicineItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class MedicineInteraction {
  final String medicine1;
  final String medicine2;
  final InteractionSeverity severity;
  final String description;
  final String recommendation;

  const MedicineInteraction({
    required this.medicine1,
    required this.medicine2,
    required this.severity,
    required this.description,
    required this.recommendation,
  });
}

enum InteractionSeverity { safe, warning, dangerous }

class ArGridPainter extends CustomPainter {
  final Color color;

  ArGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
