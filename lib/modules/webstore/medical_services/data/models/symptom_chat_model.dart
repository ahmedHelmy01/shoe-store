class SymptomChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final ChatMessageType type;
  final List<SymptomOption>? options;
  final String? diagnosis;
  final List<String>? suggestedMedicines;

  const SymptomChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = ChatMessageType.text,
    this.options,
    this.diagnosis,
    this.suggestedMedicines,
  });

  SymptomChatMessage copyWith({
    String? content,
    ChatMessageType? type,
    List<SymptomOption>? options,
    String? diagnosis,
    List<String>? suggestedMedicines,
  }) {
    return SymptomChatMessage(
      id: id,
      content: content ?? this.content,
      isUser: isUser,
      timestamp: timestamp,
      type: type ?? this.type,
      options: options ?? this.options,
      diagnosis: diagnosis ?? this.diagnosis,
      suggestedMedicines: suggestedMedicines ?? this.suggestedMedicines,
    );
  }
}

enum ChatMessageType {
  text,
  options,
  diagnosis,
  loading,
}

class SymptomOption {
  final String id;
  final String label;
  final String? icon;

  const SymptomOption({
    required this.id,
    required this.label,
    this.icon,
  });
}

class SymptomAnalysisResult {
  final String diagnosis;
  final String severity;
  final String description;
  final List<String> recommendedActions;
  final List<String> suggestedMedicines;
  final bool needsDoctor;

  const SymptomAnalysisResult({
    required this.diagnosis,
    required this.severity,
    required this.description,
    required this.recommendedActions,
    this.suggestedMedicines = const [],
    this.needsDoctor = false,
  });

  factory SymptomAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysisResult(
      diagnosis: json['diagnosis'] ?? '',
      severity: json['severity'] ?? 'low',
      description: json['description'] ?? '',
      recommendedActions: List<String>.from(json['recommended_actions'] ?? []),
      suggestedMedicines: List<String>.from(json['suggested_medicines'] ?? []),
      needsDoctor: json['needs_doctor'] ?? false,
    );
  }
}
