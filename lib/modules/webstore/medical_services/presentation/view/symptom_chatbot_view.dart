import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/symptom_chat_model.dart';

class SymptomChatbotView extends ConsumerStatefulWidget {
  const SymptomChatbotView({super.key});

  @override
  ConsumerState<SymptomChatbotView> createState() => _SymptomChatbotViewState();
}

class _SymptomChatbotViewState extends ConsumerState<SymptomChatbotView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _selectedSymptoms = [];
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendSymptoms() {
    if (_selectedSymptoms.isEmpty && _textController.text.trim().isEmpty) return;

    final symptoms = _selectedSymptoms.isNotEmpty
        ? _selectedSymptoms
        : [_textController.text.trim()];

    ref.read(symptomChatProvider.notifier).sendSymptoms(
      symptoms,
      additionalInfo: _textController.text.trim(),
    );

    _textController.clear();
    _selectedSymptoms.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chatState = ref.watch(symptomChatProvider);

    ref.listen<SymptomChatState>(symptomChatProvider, (prev, next) {
      _scrollToBottom();
    });

    return WebStoreBaseScaffold(
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(
                    alpha: 0.5 + (_pulseController.value * 0.5),
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 6 + (_pulseController.value * 4),
                    ),
                  ],
                ),
              );
            },
          ),
          8.horizontalSpace,
          Text(
            'مساعد الأعراض الذكي',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];
                return _buildMessageBubble(message, isDark);
              },
            ),
          ),
          _buildQuickSymptomSelector(isDark),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(SymptomChatMessage message, bool isDark) {
    if (message.type == ChatMessageType.loading) {
      return AppAnimation.fadeInUp(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFF6C63FF),
                  size: 18.sp,
                ),
              ),
              8.horizontalSpace,
              _buildTypingIndicator(isDark),
            ],
          ),
        ),
      );
    }

    final isUser = message.isUser;

    return AppAnimation.fadeInUp(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFF6C63FF),
                  size: 18.sp,
                ),
              ),
              8.horizontalSpace,
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF6C63FF)
                          : isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                        bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.type == ChatMessageType.diagnosis &&
                            message.diagnosis != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getDiagnosisColor(message.diagnosis!).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getDiagnosisIcon(message.diagnosis!),
                                  color: _getDiagnosisColor(message.diagnosis!),
                                  size: 16.sp,
                                ),
                                6.horizontalSpace,
                                Text(
                                  message.diagnosis!,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _getDiagnosisColor(message.diagnosis!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          8.verticalSpace,
                        ],
                        Text(
                          message.content,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isUser
                                ? Colors.white
                                : isDark
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : AppColors.textColor,
                            height: 1.5,
                          ),
                        ),
                        if (message.suggestedMedicines != null &&
                            message.suggestedMedicines!.isNotEmpty) ...[
                          12.verticalSpace,
                          Text(
                            'الادوية المقترحة:',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: isUser
                                  ? Colors.white70
                                  : isDark
                                      ? Colors.white60
                                      : AppColors.textSecondary,
                            ),
                          ),
                          6.verticalSpace,
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: message.suggestedMedicines!.map((med) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  med,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: isUser
                                        ? Colors.white
                                        : const Color(0xFF4CAF50),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isUser) ...[
              8.horizontalSpace,
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: const Color(0xFF6C63FF),
                  size: 18.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(
                    alpha: 0.3 + (((_pulseController.value + index * 0.3) % 1.0) * 0.7),
                  ),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildQuickSymptomSelector(bool isDark) {
    final quickSymptoms = [
      ('صداع', Icons.psychology, const Color(0xFFE91E63)),
      ('حمى', Icons.thermostat, const Color(0xFFFF5722)),
      ('الم معدة', Icons.sick, const Color(0xFFFF9800)),
      ('bronze', Icons.air, const Color(0xFF2196F3)),
      ('دوخة', Icons.sync_problem, const Color(0xFF9C27B0)),
      ('إرهاق', Icons.battery_1_bar, const Color(0xFF607D8B)),
      ('الم ظهر', Icons.accessibility, const Color(0xFF795548)),
      ('حكة', Icons.sensors, const Color(0xFFFF5722)),
    ];

    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickSymptoms.length,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final symptom = quickSymptoms[index];
          final isSelected = _selectedSymptoms.contains(symptom.$1);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSymptoms.remove(symptom.$1);
                } else {
                  _selectedSymptoms.add(symptom.$1);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? symptom.$3.withValues(alpha: 0.2)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? symptom.$3
                      : isDark
                          ? Colors.white12
                          : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    symptom.$2,
                    color: isSelected ? symptom.$3 : AppColors.textHint,
                    size: 16.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    symptom.$1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? symptom.$3
                          : isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
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

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: _textController,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textColor,
                    fontSize: 14.sp,
                  ),
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'اوصف أعراضك...',
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                  ),
                  onSubmitted: (_) => _sendSymptoms(),
                ),
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: _sendSymptoms,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDiagnosisColor(String diagnosis) {
    final lower = diagnosis.toLowerCase();
    if (lower.contains('خطير') || lower.contains('حادة')) return AppColors.error;
    if (lower.contains('متوسط') || lower.contains('انتبه')) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getDiagnosisIcon(String diagnosis) {
    final lower = diagnosis.toLowerCase();
    if (lower.contains('خطير') || lower.contains('حادة')) return Icons.dangerous;
    if (lower.contains('متوسط') || lower.contains('انتبه')) return Icons.warning;
    return Icons.check_circle;
  }
}
