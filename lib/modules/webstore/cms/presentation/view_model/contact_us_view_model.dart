import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/cms/data/models/contact_request_model.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';

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

class ContactUsVm extends Notifier<ContactUsState> {
  @override
  ContactUsState build() => ContactUsState();

  Future<void> submitContact(ContactRequestModel request) async {
    state = state.copyWith(status: ContactUsStatus.loading);
    
    final result = await ref.read(cmsRepositoryProvider).submitContact(request);
    
    result.when(
      success: (_) {
        state = state.copyWith(status: ContactUsStatus.success);
      },
      failure: (error) {
        state = state.copyWith(status: ContactUsStatus.error, errorMessage: error.message);
      },
    );
  }

  void reset() => state = ContactUsState();
}

final contactUsVmProvider = NotifierProvider<ContactUsVm, ContactUsState>(ContactUsVm.new);
