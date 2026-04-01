/// ERP System - Paginated Response Model
///
/// Generic wrapper for paginated API responses.
/// Works with any model type across all modules.
library;

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    final dataList = (json['data'] as List?)
            ?.map((e) => fromJsonItem(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse(
      data: dataList,
      meta: PaginationMeta.fromJson(json['meta'] ?? json),
    );
  }

  bool get hasMore => meta.currentPage < meta.lastPage;
  bool get isEmpty => data.isEmpty;
  int get nextPage => meta.currentPage + 1;
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? json['currentPage'] ?? 1,
      lastPage: json['last_page'] ?? json['lastPage'] ?? 1,
      perPage: json['per_page'] ?? json['perPage'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class PaginationParams {
  final int page;
  final int perPage;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final Map<String, dynamic>? filters;

  const PaginationParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.filters,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'per_page': perPage,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (filters != null) ...filters!,
    };
  }

  PaginationParams copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      filters: filters ?? this.filters,
    );
  }
}
