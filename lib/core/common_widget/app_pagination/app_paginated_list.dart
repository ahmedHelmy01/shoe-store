/// ERP System - Paginated List View
///
/// Generic infinite-scroll list widget with automatic pagination.
/// Works with any Riverpod AsyncNotifier that implements pagination.
library;

import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

class AppPaginatedList<T> extends StatefulWidget {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final EdgeInsets? padding;
  final Widget? separator;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AppPaginatedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
    this.onLoadMore,
    this.onRefresh,
    this.onRetry,
    this.emptyWidget,
    this.loadingWidget,
    this.padding,
    this.separator,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  State<AppPaginatedList<T>> createState() => _AppPaginatedListState<T>();
}

class _AppPaginatedListState<T> extends State<AppPaginatedList<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore && widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Error state
    if (widget.errorMessage != null && widget.items.isEmpty) {
      return AppErrorWidget(
        errorMessage: widget.errorMessage,
        onRetry: widget.onRetry,
      );
    }

    // Loading state
    if (widget.isLoading && widget.items.isEmpty) {
      return widget.loadingWidget ?? AppShimmer.list();
    }

    // Empty state
    if (widget.items.isEmpty) {
      return widget.emptyWidget ?? const AppEmptyWidget();
    }

    // Data state
    final listView = ListView.separated(
      controller: _scrollController,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      padding: widget.padding ?? const EdgeInsets.all(16),
      itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, index) =>
          widget.separator ?? const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return widget.itemBuilder(context, widget.items[index], index);
      },
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRefresh!(),
        child: listView,
      );
    }

    return listView;
  }
}
