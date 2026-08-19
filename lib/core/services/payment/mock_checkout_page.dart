/// Mock Checkout Page
///
/// Simulates Tabby / Tamara BNPL checkout UI when the app is running
/// with placeholder API keys (design / test mode). Returns a
/// [PaymentGatewayResult] exactly like the real SDKs would.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'payment_gateway_models.dart';

class MockCheckoutPage extends StatefulWidget {
  final String gateway;
  final double totalAmount;
  final double shippingAmount;
  final double discountAmount;
  final String currency;
  final List<PaymentGatewayItem> items;
  final String buyerName;
  final String buyerPhone;

  const MockCheckoutPage({
    super.key,
    required this.gateway,
    required this.totalAmount,
    required this.shippingAmount,
    required this.discountAmount,
    required this.currency,
    required this.items,
    required this.buyerName,
    required this.buyerPhone,
  });

  @override
  State<MockCheckoutPage> createState() => _MockCheckoutPageState();
}

class _MockCheckoutPageState extends State<MockCheckoutPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;
  bool _isProcessing = false;

  // Brand colours
  static const _tabbyGreen = Color(0xFF3BFFC1);
  static const _tabbyDark = Color(0xFF292929);
  static const _tamaraBlue = Color(0xFF2D4187);
  static const _tamaraLight = Color(0xFFE8ECF7);

  bool get _isTabby => widget.gateway.toLowerCase().contains('tabby');
  Color get _accent => _isTabby ? _tabbyGreen : _tamaraBlue;
  Color get _accentBg => _isTabby ? _tabbyDark : _tamaraLight;
  String get _gatewayName => _isTabby ? 'Tabby' : 'Tamara';

  double get _subtotal =>
      widget.totalAmount - widget.shippingAmount + widget.discountAmount;
  double get _installment => widget.totalAmount / 4;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _confirm() async {
    setState(() => _isProcessing = true);
    // Simulate a short delay like a real payment gateway
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pop(
      context,
      PaymentGatewayResult(
        status: PaymentGatewayStatus.authorized,
        gatewayPaymentId:
            'mock_${widget.gateway}_${DateTime.now().millisecondsSinceEpoch}',
        gatewayOrderId:
            'mock_order_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  void _cancel() {
    Navigator.pop(
      context,
      const PaymentGatewayResult(status: PaymentGatewayStatus.cancelled),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1B263B) : Colors.grey.shade50;
    final textColor = isDark ? Colors.white : const Color(0xFF090F47);
    final subTextColor = isDark ? Colors.white60 : Colors.grey.shade600;

    return PopScope(
      canPop: !_isProcessing,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: _isTabby ? _tabbyDark : _accent,
          foregroundColor: _isTabby ? _tabbyGreen : Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _gatewayName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: _isTabby ? _tabbyGreen : Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: _isProcessing ? null : _cancel,
            icon: const Icon(Icons.close),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            children: [
              // ══════ MOCK MODE BANNER ══════
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.science_rounded, color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'وضع تجريبي — TEST MODE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // ══════ SCROLLABLE CONTENT ══════
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Gateway branding card
                      _brandCard(cardBg, textColor, subTextColor),
                      SizedBox(height: 16.h),

                      // Buyer info
                      _sectionCard(
                        cardBg: cardBg,
                        title: 'معلومات المشتري',
                        titleColor: textColor,
                        icon: Icons.person_outline_rounded,
                        child: Column(
                          children: [
                            _infoRow('الاسم', widget.buyerName, subTextColor),
                            SizedBox(height: 6.h),
                            _infoRow('الهاتف', widget.buyerPhone, subTextColor),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Items
                      _sectionCard(
                        cardBg: cardBg,
                        title: 'المنتجات (${widget.items.length})',
                        titleColor: textColor,
                        icon: Icons.shopping_bag_outlined,
                        child: Column(
                          children: widget.items.map((item) {
                            final lineTotal = item.unitPrice * item.quantity;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity}x  ${item.unitPrice.toStringAsFixed(2)} ${widget.currency}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${lineTotal.toStringAsFixed(2)} ${widget.currency}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Order Summary
                      _sectionCard(
                        cardBg: cardBg,
                        title: 'ملخص الطلب',
                        titleColor: textColor,
                        icon: Icons.receipt_long_outlined,
                        child: Column(
                          children: [
                            _summaryRow(
                              'المجموع الفرعي',
                              '${_subtotal.toStringAsFixed(2)} ${widget.currency}',
                              subTextColor,
                            ),
                            if (widget.shippingAmount > 0)
                              _summaryRow(
                                'الشحن',
                                '${widget.shippingAmount.toStringAsFixed(2)} ${widget.currency}',
                                subTextColor,
                              ),
                            if (widget.discountAmount > 0)
                              _summaryRow(
                                'الخصم',
                                '-${widget.discountAmount.toStringAsFixed(2)} ${widget.currency}',
                                Colors.green,
                              ),
                            Divider(height: 16.h),
                            _summaryRow(
                              'الإجمالي',
                              '${widget.totalAmount.toStringAsFixed(2)} ${widget.currency}',
                              textColor,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Installment Plan
                      _installmentCard(cardBg, textColor, subTextColor),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // ══════ BOTTOM BUTTONS ══════
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                decoration: BoxDecoration(
                  color: bg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isTabby ? _tabbyGreen : const Color(0xFF2E7D32),
                          foregroundColor:
                              _isTabby ? _tabbyDark : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 2,
                        ),
                        child: _isProcessing
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: _isTabby ? _tabbyDark : Colors.white,
                                ),
                              )
                            : Text(
                                'تأكيد الدفع التجريبي ✓',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: _isProcessing ? null : _cancel,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: subTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Helper widgets
  // ═══════════════════════════════════════════════

  Widget _brandCard(Color cardBg, Color textColor, Color subTextColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _accentBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _accent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Gateway icon
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: _isTabby
                  ? _tabbyGreen.withValues(alpha: 0.15)
                  : _tamaraBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                _isTabby ? 'T' : 'ت',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: _accent,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدفع عبر $_gatewayName',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: _isTabby ? Colors.white : _tamaraBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'قسّم المبلغ على ٤ دفعات بدون فوائد',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isTabby ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Color cardBg,
    required String title,
    required Color titleColor,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: _accent),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12.sp, color: color)),
        Text(value,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: color)),
      ],
    );
  }

  Widget _summaryRow(String label, String value, Color color,
      {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: color)),
        ],
      ),
    );
  }

  Widget _installmentCard(Color cardBg, Color textColor, Color subTextColor) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined,
                  size: 18.sp, color: _accent),
              SizedBox(width: 8.w),
              Text(
                'خطة الأقساط (٤ دفعات)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...List.generate(4, (i) {
            final isFirst = i == 0;
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFirst
                          ? _accent
                          : _accent.withValues(alpha: 0.12),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isFirst
                              ? (_isTabby ? _tabbyDark : Colors.white)
                              : _accent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      isFirst ? 'اليوم (عند الشراء)' : 'بعد $i شهر',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: subTextColor,
                      ),
                    ),
                  ),
                  Text(
                    '${_installment.toStringAsFixed(2)} ${widget.currency}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_outlined,
                  size: 14.sp, color: Colors.green),
              SizedBox(width: 6.w),
              Text(
                'بدون فوائد أو رسوم إضافية',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
