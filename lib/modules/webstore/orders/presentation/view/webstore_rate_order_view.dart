import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_rate_order_star_rating.dart';

class WebStoreRateOrderView extends ConsumerStatefulWidget {
  final int orderId;

  const WebStoreRateOrderView({super.key, required this.orderId});

  @override
  ConsumerState<WebStoreRateOrderView> createState() => _WebStoreRateOrderViewState();
}

class _WebStoreRateOrderViewState extends ConsumerState<WebStoreRateOrderView> {
  double deliveryRating = 0.0;
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasExistingRating = false;

  @override
  void initState() {
    super.initState();
    // Load existing rating if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingRating();
    });
  }

  Future<void> _loadExistingRating() async {
    final ratingAsync = ref.read(orderRatingProvider(widget.orderId));
    ratingAsync.whenData((data) {
      final ratingData = data['data'];
      if (ratingData != null && ratingData is Map) {
        setState(() {
          _hasExistingRating = true;
          deliveryRating = (ratingData['rating'] as num?)?.toDouble() ?? 0.0;
          _feedbackController.text = ratingData['rating_text']?.toString() ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch the existing rating to pre-fill
    final existingRatingAsync = ref.watch(orderRatingProvider(widget.orderId));
    existingRatingAsync.whenData((data) {
      final ratingData = data['data'];
      if (ratingData != null && ratingData is Map && !_hasExistingRating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasExistingRating = true;
              deliveryRating = (ratingData['rating'] as num?)?.toDouble() ?? 0.0;
              _feedbackController.text = ratingData['rating_text']?.toString() ?? '';
            });
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: LocaleKeys.webstore.orders.rate_order.tr(context: context)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────
            AppAnimation.fadeInDown(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_rounded, color: AppColors.primaryOrange, size: 48.sp),
                    ),
                    20.verticalSpace,
                    Text(
                      _hasExistingRating
                          ? LocaleKeys.webstore.orders.your_rating.tr(context: context)
                          : LocaleKeys.webstore.orders.experience_question.tr(context: context),
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      _hasExistingRating
                          ? LocaleKeys.webstore.orders.update_rating_hint.tr(context: context)
                          : LocaleKeys.webstore.orders.improve_service_hint.tr(context: context),
                      style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            32.verticalSpace,

            // ─── Delivery Rating ─────────────────────────
            _sectionHeader(LocaleKeys.webstore.orders.rate_delivery_service.tr(context: context)),
            12.verticalSpace,
            WebStoreRateOrderStarRatingWidget(
              rating: deliveryRating,
              onRatingUpdate: (val) => setState(() => deliveryRating = val),
            ),

            32.verticalSpace,

            // ─── Feedback Field ──────────────────────────
            _sectionHeader(LocaleKeys.webstore.orders.add_feedback.tr(context: context)),
            12.verticalSpace,
            AppCard(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: LocaleKeys.webstore.orders.feedback_hint.tr(context: context),
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                ),
              ),
            ),

            40.verticalSpace,

            // Submit Button
            AppButton(
              onPressed: _isSubmitting || deliveryRating == 0 ? null : () => _submitRating(),
              isGradient: true,
              child: _isSubmitting
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      _hasExistingRating
                          ? LocaleKeys.webstore.orders.update_rating.tr(context: context)
                          : LocaleKeys.webstore.orders.submit_feedback.tr(context: context),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    if (deliveryRating == 0) return;

    setState(() => _isSubmitting = true);

    try {
      final ratingText = _feedbackController.text.trim().isEmpty ? null : _feedbackController.text.trim();
      final params = (orderId: widget.orderId, rating: deliveryRating.toInt(), ratingText: ratingText);

      await ref.read(rateOrderProvider(params).future);

      // Invalidate the existing rating cache so it refreshes
      ref.invalidate(orderRatingProvider(widget.orderId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.webstore.orders.rating_success.tr(context: context))),
        );
        AppNavigator.pushAndRemoveUntil(context, AppRouteNames.webstoreMain);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
    );
  }
}
