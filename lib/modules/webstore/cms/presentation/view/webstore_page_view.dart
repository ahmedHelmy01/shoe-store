import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/cms/data/models/cms_page_model.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

class WebStorePageView extends ConsumerStatefulWidget {
  final String slug;
  final String title;

  const WebStorePageView({
    super.key,
    required this.slug,
    required this.title,
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

  Future<void> _fetchPage() async {
    setState(() => _pageState = const AsyncValue.loading());
    
    final result = await ref.read(cmsRepositoryProvider).getPageBySlug(widget.slug);
    
    if (mounted) {
      result.when(
        success: (data) {
          final pageData = data['data'];
          if (pageData != null) {
            setState(() => _pageState = AsyncValue.data(CmsPageModel.fromJson(pageData)));
          } else {
            setState(() => _pageState = AsyncValue.error('Page not found', StackTrace.current));
          }
        },
        failure: (error) {
          setState(() => _pageState = AsyncValue.error(error.message, StackTrace.current));
        },
      );
    }
  }

  /// Basic HTML tag stripper for rendering CMS content as plain text.
  /// TODO: Add `flutter_widget_from_html` package for rich HTML rendering.
  String _stripHtmlTags(String html) {
    return html
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<p[^>]*>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return WebStoreBaseScaffold(
      title: Text(widget.title),
      showBack: true,
      body: _pageState?.when(
            data: (page) => SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (page.image != null && page.image!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        page.image!,
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    20.verticalSpace,
                  ],
                  Text(
                    page.titleAr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  15.verticalSpace,
                  Text(
                    _stripHtmlTags(page.contentAr),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
            loading: () => Center(
              child: AppShimmer.box(width: double.infinity, height: 1.sh),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(err.toString()),
                  16.verticalSpace,
                  ElevatedButton(
                    onPressed: _fetchPage,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ) ??
          const SizedBox.shrink(),
    );
  }
}
