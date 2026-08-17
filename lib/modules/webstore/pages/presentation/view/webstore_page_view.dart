import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/pages/data/models/cms_page_model.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:erp/core/localization/locale_keys.dart';

class WebStorePageView extends ConsumerStatefulWidget {
  final String slug;
  final String initialTitle;

  const WebStorePageView({
    super.key,
    required this.slug,
    required this.initialTitle,
  });

  @override
  ConsumerState<WebStorePageView> createState() => _WebStorePageViewState();
}

class _WebStorePageViewState extends ConsumerState<WebStorePageView> {
  AsyncValue<CmsPageModel>? _pageState;

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  /// Cleans the slug if it comes as a full URL from the API.
  String _cleanSlug(String slug) {
    if (slug.contains('://')) {
      try {
        final uri = Uri.parse(slug);
        final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        return segments.isNotEmpty ? segments.last : slug;
      } catch (e) {
        return slug;
      }
    }
    return slug;
  }

  Future<void> _fetchPage() async {
    setState(() => _pageState = const AsyncValue.loading());

    final targetSlug = _cleanSlug(widget.slug);
    final result = await ref
        .read(cmsRepositoryProvider)
        .getPageBySlug(targetSlug);

    if (mounted) {
      result.when(
        success: (data) {
          final pageData = data['data'];
          if (pageData != null) {
            setState(
              () =>
                  _pageState = AsyncValue.data(CmsPageModel.fromJson(pageData)),
            );
          } else {
            setState(
              () => _pageState = AsyncValue.error(
                LocaleKeys.common.page_not_found.tr(),
                StackTrace.current,
              ),
            );
          }
        },
        failure: (error) {
          setState(
            () => _pageState = AsyncValue.error(
              error.message,
              StackTrace.current,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contentColor = isDark
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.black87;
    final titleColor = isDark ? Colors.white : Colors.black;

    return WebStoreBaseScaffold(
      title: Text(
        widget.initialTitle,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body:
          _pageState?.when(
            data: (page) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (page.imageUrl != null && page.imageUrl!.isNotEmpty) ...[
                    AppImage(imagePath: page.imageUrl!, width: double.infinity, fit: BoxFit.contain),
                    24.verticalSpace,
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      context.locale.languageCode == 'ar' ? page.titleAr : page.title,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Html(
                    data: context.locale.languageCode == 'ar' ? page.contentAr : page.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.5.sp),
                        color: contentColor,
                        lineHeight: LineHeight.em(1.7),
                        margin: Margins.zero,
                        padding: HtmlPaddings.symmetric(horizontal: 16.w),
                        textAlign: TextAlign.justify,
                        fontFamily: context.locale.languageCode == 'ar' ? 'Tajawal' : null,
                      ),
                      "p": Style(
                        margin: Margins.only(bottom: 16.h),
                      ),
                      "strong": Style(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.primaryWine : AppColors.primaryBlue,
                      ),
                      "a": Style(
                        color: AppColors.primaryWine,
                        textDecoration: TextDecoration.underline,
                      ),
                    },
                  ),
                  80.verticalSpace,
                ],
              ),
            ),
            loading: () => Center(
              child: Column(
                children: [
                  AppShimmer.box(width: 350.w, height: 200.h),
                  20.verticalSpace,
                  AppShimmer.box(width: 300.w, height: 30.h),
                  20.verticalSpace,
                  AppShimmer.box(width: double.infinity, height: 400.h),
                ],
              ),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 60.sp,
                      color: Colors.redAccent,
                    ),
                    20.verticalSpace,
                    Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: contentColor),
                    ),
                    24.verticalSpace,
                    ElevatedButton(
                      onPressed: _fetchPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryWine,
                      ),
                      child: Text(
                        LocaleKeys.common.try_again.tr(context: context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) ??
          const SizedBox.shrink(),
    );
  }
}
