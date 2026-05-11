enum ContactUsStatus { initial, loading, success, error }

class ContactUsState {
  final ContactUsStatus status;
  final String? errorMessage;
  
  ContactUsState({this.status = ContactUsStatus.initial, this.errorMessage});

  ContactUsState copyWith({ContactUsStatus? status, String? errorMessage}) {
    return ContactUsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
