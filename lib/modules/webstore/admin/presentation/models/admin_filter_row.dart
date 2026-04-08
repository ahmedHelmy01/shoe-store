class AdminFilterRow {
  final int id;
  final String name;
  final String type; // e.g. "checkbox", "range", "select"
  final int optionsCount;
  final bool active;

  const AdminFilterRow({
    required this.id,
    required this.name,
    required this.type,
    required this.optionsCount,
    required this.active,
  });
}

