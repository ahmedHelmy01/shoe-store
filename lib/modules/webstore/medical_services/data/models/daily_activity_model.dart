class DailyActivity {
  final String type;
  final String label;
  final double currentValue;
  final double targetValue;
  final String unit;
  final String icon;
  final int colorValue;

  const DailyActivity({
    required this.type,
    required this.label,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.icon,
    required this.colorValue,
  });

  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => currentValue >= targetValue;

  DailyActivity copyWith({double? currentValue}) {
    return DailyActivity(
      type: type,
      label: label,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue,
      unit: unit,
      icon: icon,
      colorValue: colorValue,
    );
  }
}
