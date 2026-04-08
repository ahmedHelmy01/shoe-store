class AdminPagedResponse<T> {
  final List<T> items;
  final int page;
  final int? lastPage;
  final int? total;

  const AdminPagedResponse({
    required this.items,
    required this.page,
    this.lastPage,
    this.total,
  });
}

